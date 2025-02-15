package gnote;
import connexion.*;
import gecolage.*;
import java.sql.*;
import java.sql.Date;
import java.util.*;
import java.io.*;

public class Functions {
    private Connect con;

    public Functions(Connect con) throws SQLException{
        this.con = con;
    }

    public void addEtudiant(String etu, String nom, Date entree)throws SQLException{
        String insert = "INSERT INTO ETUDIANT VALUES (?,?,?)";
        try(PreparedStatement stmt = con.getConnectionMysql().prepareStatement(insert)){
            stmt.setString(1,etu);
            stmt.setString(2,nom);
            stmt.setDate(3,entree);
            stmt.executeUpdate();
            System.out.println("Etudiant "+ etu + nom + " ajouter avec succes");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


    public Etudiant getEtudiant(String etu) throws SQLException {
    String query = "SELECT * FROM ETUDIANT WHERE ETU = ?";
    Etudiant etudiant = null;

    try (PreparedStatement pstmt = con.getConnectionMysql().prepareStatement(query)) {
        pstmt.setString(1, etu);

        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                etudiant = new Etudiant(
                    rs.getString("ETU"),        // Récupère l'ID de l'étudiant
                    rs.getString("NOM"),
                        rs.getDate("DATE_ENTREE")
                        // Récupère le nom de l'étudiant
                );
            }
        }
    } catch (SQLException e) {
        throw new SQLException("Erreur lors de la récupération des informations de l'étudiant : " + e.getMessage());
    }

    return etudiant;
}

    public List<Etudiant> getAllEtudiant() throws SQLException {
        List<Etudiant> list = new ArrayList<>();
        String query = "SELECT * FROM ETUDIANT";
        try (PreparedStatement stmt = con.getConnectionMysql().prepareStatement(query)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Etudiant etudiant = new Etudiant(
                            rs.getString("ETU"),
                            rs.getString("NOM"),
                            rs.getDate("DATE_ENTREE")
                    );
                    // Add other necessary fields
                    list.add(etudiant);
                }
            }
        }
        return list;
    }

    public List<Semestre> getAllSemestres() { /// pour jsp
        List<Semestre> semestres = new ArrayList<>();
        try {
            Statement statement = con.getConnectionOracle().createStatement();
            ResultSet resultSet = statement.executeQuery("SELECT * FROM semestre");

            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String nom = resultSet.getString("nom");
                String parcours = resultSet.getString("parcours");

                Semestre semestre = new Semestre(id, nom, parcours);
                semestres.add(semestre);
            }
            resultSet.close();
            statement.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return semestres;
    }

    public Semestre getSemestre(int semestre) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String query = "SELECT * FROM SEMESTRE WHERE ID = ?";
            pstmt = con.getConnectionOracle().prepareStatement(query);
            pstmt.setInt(1, semestre);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return new Semestre(
                        rs.getInt("ID"),
                        rs.getString("NOM"),
                        rs.getString("PARCOURS")
                );
            }
            return null;
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
    }

    public int countMatiereInf10(String etu, int semester,int annee) throws SQLException {
        List<Notes> notes = getNotesWithoutCredit(etu, semester,annee);
        int count = 0;
        for (Notes note : notes) {
            if (note.getValeur() < 10) {
                count++;
            }
        }
        return count;
    }

    public boolean thisStudentPass(String etu, int semester,List<Notes>notes,int annee) throws SQLException {
        //List<Notes> notes = getNotesWithoutCredit(etu, semester);
        boolean misyInf6 = false;
        int nbMatiereInf10 = countMatiereInf10(etu, semester,annee);
        double moyenneGenerale = moyenneGeneraleSemestre(etu, semester,notes);

        for (Notes n : notes) {
            if (n.getValeur() < 6) {
                misyInf6 = true;
            }
            if (n.getValeur() == 0) {
                return false;
            }
        }

        if (misyInf6 || moyenneGenerale < 10 || nbMatiereInf10 >= 3) {
            return false;
        }
        return moyenneGenerale >= 10 && nbMatiereInf10 <= 2 && !misyInf6;
    }

    public List<Matieres> getMatieresSemester(int semester) throws SQLException {
        List<Matieres> listMatieres = new ArrayList<>();
        String query = "SELECT * FROM MATIERES WHERE ID_SEMESTRE = " + semester;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = con.getConnectionOracle().createStatement();
            rs = stmt.executeQuery(query);
            while (rs.next()) {
                Matieres matieres = new Matieres(
                        rs.getString("ID"),
                        rs.getInt("CREDIT"),
                        rs.getInt("ID_SEMESTRE"),
                        rs.getInt("OPTIONNEL"),
                        rs.getInt("GRP_OPT"),
                        rs.getInt("USEAVERAGE")
                );
                listMatieres.add(matieres);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
        return listMatieres;
    }

///

    public Object[] getMaxNotesMatiere(String etu, int semester,int annee, String matiere) throws SQLException {
        String query = "SELECT MAX(n.valeur) as val, m.id as nom " +
                "FROM notes n " +
                "JOIN matieres m ON n.id_matiere = m.id " +
                "WHERE n.etu = ? AND n.id_matiere = ? AND n.id_semestre = ? AND ANNEE =?" +
                "GROUP BY m.id";

        return executeNoteQuery(query, etu, semester, matiere,annee);
    }

    public Object[] getAverageNotesMatiere(String etu, int semester,int annee, String matiere) throws SQLException {
        String query = "SELECT AVG(n.valeur) as val, m.id as nom " +
                "FROM notes n " +
                "JOIN matieres m ON n.id_matiere = m.id " +
                "WHERE n.etu = ? AND n.id_matiere = ? AND n.id_semestre = ? AND ANNEE = ? " +
                "GROUP BY m.id";

        return executeNoteQuery(query, etu, semester, matiere,annee);
    }

private Object[] executeNoteQuery(String query, String etu, int semester, String matiere, int annee) throws SQLException {
    try (PreparedStatement pstmt = con.getConnectionOracle().prepareStatement(query)) {
        // Assigner les paramètres au PreparedStatement
        pstmt.setString(1, etu);
        pstmt.setString(2, matiere);
        pstmt.setInt(3, semester);
        pstmt.setInt(4, annee); // Ajout du paramètre année

        // Exécuter la requête et traiter les résultats
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                double val = rs.getDouble("val");
                // Limiter la précision à deux chiffres après la virgule
                val = Math.round(val * 100.0) / 100.0;
                return new Object[]{
                        rs.getString("nom"), // Récupérer le nom de la matière
                        val                  // La valeur calculée (MAX ou AVG)
                };
            }
            // Retourner des valeurs par défaut si aucun résultat n'est trouvé
            return new Object[]{matiere, 0.0};
        }
    }
}


    public Matieres getMatiere(String matiereId) throws SQLException {
        String query = "SELECT * FROM MATIERES WHERE ID = ?";
        try (PreparedStatement pstmt = con.getConnectionOracle().prepareStatement(query)) {
            pstmt.setString(1, matiereId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Matieres(
                            rs.getString("ID"),
                            rs.getInt("CREDIT"),
                            rs.getInt("ID_SEMESTRE"),
                            rs.getInt("OPTIONNEL"),
                            rs.getInt("GRP_OPT"),
                            rs.getInt("USEAVERAGE")
                    );
                }
            }
        }
        return null;
    }

    public List<String> getMatiereID(int grp, int semester) throws SQLException {
        List<String> list = new ArrayList<>();
        // Correction de la requête : ajout du FROM MATIERES
        String query = "SELECT ID FROM MATIERES WHERE GRP_OPT = ? AND ID_SEMESTRE = ?";

        try (PreparedStatement pstmt = con.getConnectionOracle().prepareStatement(query)) {
            pstmt.setInt(1, grp);
            pstmt.setInt(2, semester);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String id = rs.getString("ID");
                    list.add(id);
                }
            }
        }
        return list;
    }

    public Object[] getNotesMatiere(String etu, int semester,int annee, String matiere) throws SQLException { /// ty fonction maka note matiere
        Matieres m = getMatiere(matiere);
        // if(m.getId().equals("INF207")) {
        //     System.out.println("ID_MATIERE " + m.getId());
        // }
        if (m.getUseAverage()==1) {
            return getAverageNotesMatiere(etu, semester,annee, matiere);
        } else if(m.getUseAverage()==0) {
            return getMaxNotesMatiere(etu, semester,annee, matiere);
        }
        return null;
    }

//    public Object[] getNotesMatieresGrp(String etu, int semester, int grp) throws SQLException {
//        List<String> matieres = getMatiereID(grp, semester);
//        Object[] result = new Object[2];
//        double maxNote = 0.0;
//        String bestMatiereId = null;
//
//        // Pour chaque matière du groupe, on récupère sa note
//        for (String matiereId : matieres) {
//            Object[] noteMatiere = getNotesMatiere(etu, semester, matiereId);
//            if (noteMatiere != null) {
//                double currentNote = (double) noteMatiere[1];
//                // On garde la meilleure note du groupe
//                if (currentNote > maxNote) {
//                    maxNote = currentNote;
//                    bestMatiereId = matiereId;
//                }
//            }
//        }
//
//        if (bestMatiereId != null) {
//            result[0] = bestMatiereId;
//            result[1] = maxNote;
//        }
//
//        return result;
//    }

    public Object[] getNotesMatieresGrp(String etu, int semester, int grp,int annee) throws SQLException {
        List<String> matieres = getMatiereID(grp, semester);
        Object[] result = new Object[2];
        double maxNote = -1.0;  // Changé à -1 pour distinguer absence de note
        String bestMatiereId = null;

        // Pour chaque matière du groupe, on récupère sa note
        for (String matiereId : matieres) {
            Object[] noteMatiere = getNotesMatiere(etu, semester,annee, matiereId);
            if (noteMatiere != null && noteMatiere[1] != null) {
                double currentNote = (double) noteMatiere[1];
                // On garde la meilleure note du groupe
                if (currentNote > maxNote) {
                    maxNote = currentNote;
                    bestMatiereId = matiereId;
                }
            }
        }

        // Si aucune note n'a été trouvée
        if (maxNote == -1.0) {
            result[0] = null;
            result[1] = null;
        } else {
            result[0] = bestMatiereId;
            result[1] = maxNote;
        }
        return result;
    }

    public List<Integer> getCreditNotes2(String etu, int semester, List<Notes> allNotes,int annee) throws SQLException {
        List<Integer> credits = new ArrayList<>();
        List<Matieres> allMatieres = getMatieresSemester(semester);
        List<Integer> groupesTraites = new ArrayList<>();
        boolean studentPassed = thisStudentPass(etu, semester, allNotes,annee);

        for (Matieres matiere : allMatieres) {
            // Si c'est une matière optionnelle déjà traitée, on passe
            if (matiere.getOptionnel() == 1 && groupesTraites.contains(matiere.getGrpOption())) {
                continue;
            }

            int credit = matiere.getCredit();
            boolean valide = true;

            // Traitement des matières optionnelles
            if (matiere.getOptionnel() == 1) {
                Object[] notesGrp = getNotesMatieresGrp(etu, semester, matiere.getGrpOption(),annee);
                if (notesGrp != null && notesGrp[1] != null) {
                    double maxNote = (double) notesGrp[1];
                    if (!studentPassed && maxNote < 10) {
                        valide = false;
                    }
                } else {
                    valide = false;  // Pas de note trouvée pour le groupe optionnel
                }
                groupesTraites.add(matiere.getGrpOption());
            }
            // Traitement des matières non optionnelles
            else {
                boolean hasNote = false;
                for (Notes note : allNotes) {
                    if (note.getIdMatiere().equals(matiere.getId())) {
                        hasNote = true;
                        if (!studentPassed && note.getValeur() < 10) {
                            valide = false;
                            break;
                        }
                    }
                }
                if (!hasNote) {
                    valide = false;
                }
            }

            if (valide) {
                credits.add(credit);
            } else {
                credits.add(0);
            }
        }
        return credits;
    }

    public Object[] getNotesGroupes(String etu, int semester, int grp,int annee) throws SQLException {
        return getNotesMatieresGrp(etu, semester, grp,annee);
    }

    public List<Notes> getNotesWithoutCredit(String etu, int semester,int annee) throws SQLException {
        List<Notes> list = new ArrayList<>();
        List<Matieres> listMatieres = getMatieresSemester(semester);
        List<Integer> groupesTraites = new ArrayList<>();
        Semestre s = getSemestre(semester);

        for (Matieres matiere : listMatieres) {
            if (matiere.getOptionnel() == 1 && !groupesTraites.contains(matiere.getGrpOption())) {
                // Traitement des matières optionnelles
                Object[] matiereNote = getNotesGroupes(etu, semester, matiere.getGrpOption(),annee);
                if (matiereNote[0] != null) {
                    String matiereId = (String) matiereNote[0];
                    double maxNote = (double) matiereNote[1];
                    list.add(new Notes(etu, matiereId, semester, maxNote,annee));
                }
                groupesTraites.add(matiere.getGrpOption());
            } else if (matiere.getOptionnel() == 0) {
                // Traitement des matières non optionnelles
                Object[] noteMatiere = getNotesMatiere(etu, semester,annee, matiere.getId());
                if (noteMatiere != null) {
                    String matiereId = (String) noteMatiere[0];
                    double note = (double) noteMatiere[1];
                    list.add(new Notes(etu, matiereId, semester, note,annee));
                }
            }
        }
        return list;
    }

    public double moyenneGeneraleSemestre(String etu, int semester,List<Notes>notes) throws SQLException {
        //List<Notes> notes = getNotesWithoutCredit(etu, semester);
        List<Matieres> allMatieres = getMatieresSemester(semester);
        double sommeNotePonderee = 0;
        int totalCredits = 0;

        for (Matieres matiere : allMatieres) {
            for (Notes note : notes) {
                if (note.getIdMatiere().equals(matiere.getId())) {
                    sommeNotePonderee += note.getValeur() * matiere.getCredit();
                    totalCredits += matiere.getCredit();
                    break;
                }
            }
        }

        return totalCredits > 0
                ? Math.round((sommeNotePonderee / totalCredits) * 100.0) / 100.0
                : 0.0;
    }

        public List<Integer> getCreditNotes(String etu, int semester,int annee) throws SQLException {
        List<Integer> credits = new ArrayList<>();
        List<Notes> allNotes = getNotesWithoutCredit(etu, semester,annee);
        List<Matieres> allMatieres = getMatieresSemester(semester);
        List<Integer> groupesTraites = new ArrayList<>();

        for (Matieres matiere : allMatieres) {
            // Si c'est une matière optionnelle déjà traitée, on passe
            if (matiere.getOptionnel() == 1 && groupesTraites.contains(matiere.getGrpOption())) {
                continue;
            }

            int credit = matiere.getCredit();
            boolean valide = true;

            // Traitement des matières optionnelles
            if (matiere.getOptionnel() == 1) {
                Object[] matiereGroupInfo = getNotesGroupes(etu, semester,annee, matiere.getGrpOption());
                double maxNote = (double) matiereGroupInfo[1]; // Extraction de la note
                if (!thisStudentPass(etu, semester,allNotes,annee) && maxNote < 10) {
                    valide = false;
                }
                groupesTraites.add(matiere.getGrpOption());
            }
            // Traitement des matières non optionnelles
            else {
                boolean hasNote = false;
                for (Notes note : allNotes) {
                    if (note.getIdMatiere().equals(matiere.getId())) {
                        hasNote = true;
                        if (!thisStudentPass(etu, semester,allNotes,annee) && note.getValeur() < 10) {
                            valide = false;
                            break;
                        }
                    }
                }
                if (!hasNote) valide = false;
            }
            if (valide) {
                credits.add(credit);
            } else {
                credits.add(0);
            }
        }
        return credits;
    }

    public int getCreditTotalForSemester(String etu,int semester,int annee)throws SQLException{
        List<Integer>allCredit = getCreditNotes(etu,semester,annee);
        int nb = 0;
        for(int a : allCredit){
            nb = nb+ a;
        }
        return nb;

    }

//    public List<Integer> getCreditNotes2(String etu, int semester, List<Notes> allNotes) throws SQLException {
//        List<Integer> credits = new ArrayList<>();
//        List<Matieres> allMatieres = getMatieresSemester(semester);
//        List<Integer> groupesTraites = new ArrayList<>();
//
//        for (Matieres matiere : allMatieres) {
//            // Si c'est une matière optionnelle déjà traitée, on passe
//            if (matiere.getOptionnel() == 1 && groupesTraites.contains(matiere.getGrpOption())) {
//                continue;
//            }
//
//            int credit = matiere.getCredit();
//            boolean valide = true;
//
//            // Traitement des matières optionnelles
//            if (matiere.getOptionnel() == 1) {
//                Object[] matiereGroupInfo = getNotesGroupes(etu, semester, matiere.getGrpOption());
//                double maxNote = (double) matiereGroupInfo[1]; // Extraction de la note
//                if (!thisStudentPass(etu, semester,allNotes) && maxNote < 10) {
//                    valide = false;
//                }
//                groupesTraites.add(matiere.getGrpOption());
//            }
//            // Traitement des matières non optionnelles
//            else {
//                boolean hasNote = false;
//                for (Notes note : allNotes) {
//                    if (note.getIdMatiere().equals(matiere.getId())) {
//                        hasNote = true;
//                        if (!thisStudentPass(etu, semester,allNotes) && note.getValeur() < 10) {
//                            valide = false;
//                            break;
//                        }
//                    }
//                }
//                if (!hasNote) valide = false;
//            }
//            if (valide) {
//                credits.add(credit);
//            } else {
//                credits.add(0);
//            }
//        }
//        return credits;
//    }

    public void afficherNotesWithoutCredit(String etu, int semester,int annee) throws SQLException {
        List<Notes> notesEtudiant = getNotesWithoutCredit(etu, semester,annee);
        List<Integer> credits = getCreditNotes2(etu, semester, notesEtudiant,annee);

        if (notesEtudiant.isEmpty()) {
            System.out.println("Aucune note disponible pour l'étudiant " + etu + " au semestre " + semester);
        } else {
            System.out.println("Notes et crédits de l'étudiant " + etu + " pour le semestre " + semester + " :");
            for (int i = 0; i < notesEtudiant.size(); i++) {
                Notes note = notesEtudiant.get(i);
                int credit = (i < credits.size()) ? credits.get(i) : 0; // Gestion des cas où la liste des crédits est plus courte
                System.out.println("Matière : " + note.getIdMatiere() + " | Note : " + note.getValeur() + " | Crédit : " + credit);
            }
        }
    }

    ///=======================================>modification notes moyenne ou max
    public void setEnMax(String idMatiere) {
        String update = "UPDATE MATIERES SET USEAVERAGE = 0 WHERE ID = ?";
        try (Connection connection = con.getConnectionOracle(); // Obtenez une connexion à la base de données
             PreparedStatement preparedStatement = connection.prepareStatement(update)) {
            preparedStatement.setString(1, idMatiere); // Remplissez le paramètre de la requête
            int rowsUpdated = preparedStatement.executeUpdate(); // Exécutez la mise à jour
            if (rowsUpdated > 0) {
                System.out.println("La matière " + idMatiere + " a été mise en mode 'MAX'.");
            } else {
                System.out.println("Aucune matière trouvée avec l'ID : " + idMatiere);
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la mise à jour de la matière en mode 'MAX' : " + e.getMessage());
        }
    }


    public void setEnMoyenne(String idMatiere) {
        String update = "UPDATE MATIERES SET USEAVERAGE = 1 WHERE ID = ?";
        try (Connection connection = con.getConnectionOracle();
             PreparedStatement preparedStatement = connection.prepareStatement(update)) {
            preparedStatement.setString(1, idMatiere);
            int rowsUpdated = preparedStatement.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("La matière " + idMatiere + " a été mise en mode 'MOYENNE'.");
            } else {
                System.out.println("Aucune matière trouvée avec l'ID : " + idMatiere);
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la mise à jour de la matière en mode 'MOYENNE' : " + e.getMessage());
        }
    }

    ///=======================================>logique deliberation

    public List<Etudiant> getEtudiantsForDeliberation(int semester,int annee) throws SQLException {
        List<Etudiant> admittedStudents = new ArrayList<>();
        List<Etudiant> allStudents = getAllEtudiant();
        double moyenne = 0.0;
        for (Etudiant etudiant : allStudents) {
            moyenne = moyenneGeneraleSemestre(etudiant.getETU(), semester,getNotesWithoutCredit(etudiant.getETU(),semester,annee));
            if (!thisStudentPass(etudiant.getETU(), semester,getNotesWithoutCredit(etudiant.getETU(),semester,annee),annee) && moyenne >= 10) {
                admittedStudents.add(etudiant);
            }
        }

        return admittedStudents;
    }

    public List<Matieres> getMatieresAverinaSemestre(String etu, int semester,int annee) throws SQLException {
        List<Matieres> list = new ArrayList<>();
        List<Notes> allNotes = getNotesWithoutCredit(etu, semester,annee);

        boolean hasNoteUnder6 = false; // Vérifier si une note < 6 existe
        for (Notes n : allNotes) {
            if (n.getValeur() < 6) {
                hasNoteUnder6 = true;
                break;
            }
        }

        int countInf10 = countMatiereInf10(etu, semester,annee);

        for (Notes n : allNotes) {
            if (hasNoteUnder6 && n.getValeur() < 6) {
                // Si une note < 6 est présente, on prend uniquement ces matières
                Matieres matiere = getMatiere(n.getIdMatiere());
                if (matiere != null) {
                    //list.clear(); // Réinitialiser la liste pour ne garder que les matières < 6
                    list.add(matiere);
                }
            } else if (!hasNoteUnder6 && countInf10 >= 3 && n.getValeur() < 10) {
                // Si pas de note < 6, on prend toutes les matières avec des notes < 10 si countInf10 >= 3
                Matieres matiere = getMatiere(n.getIdMatiere());
                if (matiere != null) {
                    list.add(matiere);
                }
            }
        }

        return list;
    }

    public void afficherMatiereAverina(String etu, int semester,int annee) {
        try {
            List<Matieres> matieresList = getMatieresAverinaSemestre(etu, semester,annee);

            if (matieresList.isEmpty()) {
                System.out.println("Aucune matière à repasser pour l'étudiant " + etu + " au semestre " + semester);
            } else {
                System.out.println("Matières à repasser pour l'étudiant " + etu + " au semestre " + semester + " :");
                for (Matieres matiere : matieresList) {
                    System.out.println("ID: " + matiere.getId() +
                            ", Crédit: " + matiere.getCredit() +
                            ", ID Semestre: " + matiere.getIdSemestre());
                }
            }
        } catch (SQLException e) {
            System.out.println("Erreur lors de la récupération des matières : " + e.getMessage());
        }
    }

    public void updateNotes(String etu, int semester, String idMatiere, double newNotes) throws SQLException {
        String update = "UPDATE NOTES SET VALEUR = ? WHERE ID_MATIERE = ? AND ETU = ?";

        try {
            PreparedStatement stmt = con.getConnectionOracle().prepareStatement(update);
            stmt.setDouble(1, newNotes);
            stmt.setString(2, idMatiere);
            stmt.setString(3, etu);
            stmt.executeUpdate();

            con.getConnectionOracle().commit();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<Matieres>getMatieresForGiving(String etu,String matiereOmena,int semester,int annee)throws SQLException{
        List<Matieres> list = new ArrayList<>();
        Matieres m = getMatiere(matiereOmena);
        Object [] notes=getNotesMatiere(etu, semester,annee, matiereOmena);
        double noteMatiere = (double) notes[1];
        List<Matieres>allMatieres = getMatieresSemester(semester);
        for(Matieres t : allMatieres){
           if(t.getCredit() == m.getCredit() && noteMatiere >= 10){
               list.add(t);
           }
        }
        return list;
    }

    public void insertIntoDeliberation(String etu, int semester) throws SQLException {
        String checkQuery = "SELECT COUNT(*) FROM DELIBERATION WHERE ETU = ? AND ID_SEMESTRE = ?";
        String insertQuery = "INSERT INTO DELIBERATION SELECT * FROM NOTES WHERE ETU = ? AND ID_SEMESTRE = ?";

        try {
            // Vérification des doublons
            PreparedStatement checkStmt = con.getConnectionOracle().prepareStatement(checkQuery);
            checkStmt.setString(1, etu);
            checkStmt.setInt(2, semester);

            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                System.out.println("Les notes pour l'étudiant " + etu + " et le semestre " + semester + " existent déjà dans DELIBERATION. Aucun ajout effectué.");
                return; // Les notes existent déjà, on quitte la fonction
            }

            // Insertion si aucune note correspondante n'existe dans DELIBERATION
            PreparedStatement insertStmt = con.getConnectionOracle().prepareStatement(insertQuery);
            insertStmt.setString(1, etu);
            insertStmt.setInt(2, semester);
            insertStmt.executeUpdate();

            con.getConnectionOracle().commit();
            System.out.println("Insertion dans DELIBERATION effectuée avec succès pour l'étudiant " + etu + " au semestre " + semester);
        } catch (SQLException e) {
            // Gestion des erreurs
            con.getConnectionOracle().rollback();
            throw new RuntimeException("Erreur lors de l'insertion dans DELIBERATION : " + e.getMessage(), e);
        }
    }


    public void deliberation(String etu, int semester,int annee, String idMatiereOmena, String idMatiereAngalana, double points) throws SQLException {
        Matieres matiereOmena = getMatiere(idMatiereOmena);
        Matieres matiereAngalana = getMatiere(idMatiereAngalana);
        List<Notes>allNotes = getNotesWithoutCredit(etu,semester,annee);
        if (matiereOmena == null || matiereAngalana == null) {
            throw new SQLException("Une des matières spécifiées n'existe pas.");
        }

        if(moyenneGeneraleSemestre(etu,semester,allNotes)<10){
            throw new SQLException("Il faut que l'etudiant aie la moyenne pour pouvoir etre delibere");
        }

        int creditMatiereOmena = matiereOmena.getCredit();
        int creditMatiereAngalana = matiereAngalana.getCredit();

        if (creditMatiereOmena != creditMatiereAngalana) {
            throw new SQLException("Les matières doivent avoir le même nombre de crédits pour effectuer un transfert de points.");
        }

        Object[] noteMatiereOmenaObj = getNotesMatiere(etu, semester,annee, idMatiereOmena);
        Object[] noteMatiereAngalanaObj = getNotesMatiere(etu, semester,annee, idMatiereAngalana);

        double noteMatiereOmena = (double) noteMatiereOmenaObj[1] * creditMatiereOmena;
        double noteMatiereAngalana = (double) noteMatiereAngalanaObj[1] * creditMatiereAngalana;

        double pointsAmena = points * creditMatiereAngalana;

        double newNotesMatiereOmena = (noteMatiereOmena + pointsAmena);
        double newNotesMatiereAngalana = noteMatiereAngalana - pointsAmena;

        if((newNotesMatiereAngalana / creditMatiereAngalana) < 10){
            throw new SQLException("La note de la matière " + idMatiereAngalana + " ne peut pas descendre en dessous de 10. Aucune modification effectuée.");
        }

        System.out.println("Matière Omena - Note: " + noteMatiereOmena + ", Crédit: " + creditMatiereOmena);
        System.out.println("Matière Angalana - Note: " + noteMatiereAngalana + ", Crédit: " + creditMatiereAngalana);

        System.out.println("Vaovao Matière Omena - Note: " + newNotesMatiereOmena + ", Crédit: " + creditMatiereOmena);
        System.out.println("Vaovao Matière Angalana - Note: " + newNotesMatiereAngalana + ", Crédit: " + creditMatiereAngalana);

        System.out.println("Point azo " + pointsAmena);

        double omenaSansCredit = newNotesMatiereOmena/creditMatiereOmena;
        double angalanaSansCredit = newNotesMatiereAngalana/creditMatiereAngalana;

        insertIntoDeliberation(etu,semester);

        updateNotes(etu, semester, idMatiereOmena, omenaSansCredit);
        updateNotes(etu, semester, idMatiereAngalana, angalanaSansCredit);

        System.out.println("Délibération appliquée avec succès !");
    }

    public Object[] getNotesMatiereDeliberation(String etu, int semester, String matiere,int annee) throws SQLException {
        Matieres m = getMatiere(matiere);

        if (m.getUseAverage() == 1) {
            return getAverageNotesMatiereDeliberation(etu, semester, matiere,annee);
        } else if (m.getUseAverage() == 0) {
            return getMaxNotesMatiereDeliberation(etu, semester, matiere,annee);
        }
        return null;
    }

    public Object[] getNotesMatieresGrpDeliberation(String etu, int semester, int grp,int annee) throws SQLException {
        List<String> matieres = getMatiereID(grp, semester);
        Object[] result = new Object[2];
        double maxNote = 0.0;
        String bestMatiereId = null;

        // Pour chaque matière du groupe, on récupère sa note
        for (String matiereId : matieres) {
            Object[] noteMatiere = getNotesMatiereDeliberation(etu, semester, matiereId,annee);
            if (noteMatiere != null) {
                double currentNote = (double) noteMatiere[1];
                // On garde la meilleure note du groupe
                if (currentNote > maxNote) {
                    maxNote = currentNote;
                    bestMatiereId = matiereId;
                }
            }
        }

        if (bestMatiereId != null) {
            result[0] = bestMatiereId;
            result[1] = maxNote;
        }

        return result;
    }

    public Object[] getNotesGroupesDeliberation(String etu, int semester, int grp,int annee) throws SQLException {
        if(hasNotesInDeliberation(etu,semester,annee)) {
            return getNotesMatieresGrp(etu, semester, grp,annee);
        }
        return null;
    }

    // Méthodes auxiliaires modifiées pour utiliser la table deliberation
    public Object[] getMaxNotesMatiereDeliberation(String etu, int semester, String matiere,int annee) throws SQLException {
        String query = "SELECT MAX(d.valeur) as val, m.id as nom " +
                "FROM deliberation d " +
                "JOIN matieres m ON d.id_matiere = m.id " +
                "WHERE d.etu = ? AND d.id_matiere = ? AND d.id_semestre = ? AND ANNEE = ?" +
                "GROUP BY m.id";

        return executeNoteQuery(query, etu, semester, matiere,annee);
    }

    public Object[] getAverageNotesMatiereDeliberation(String etu, int semester, String matiere,int annee) throws SQLException {
        String query = "SELECT AVG(d.valeur) as val, m.id as nom " +
                "FROM deliberation d " +
                "JOIN matieres m ON d.id_matiere = m.id " +
                "WHERE d.etu = ? AND d.id_matiere = ? AND d.id_semestre = ? AND ANNEE = ? " +
                "GROUP BY m.id";

        return executeNoteQuery(query, etu, semester, matiere,annee);
    }

    public List<Notes> getNotesWithoutCreditAvantDeliberation(String etu, int semester,int annee) throws SQLException {
        List<Notes> list = new ArrayList<>();
        List<Matieres> listMatieres = getMatieresSemester(semester);
        List<Integer> groupesTraites = new ArrayList<>();
        Semestre s = getSemestre(semester);

        for (Matieres matiere : listMatieres) {
            if (matiere.getOptionnel() == 1 && !groupesTraites.contains(matiere.getGrpOption())) {
                // Traitement des matières optionnelles
                Object[] matiereNote = getNotesGroupesDeliberation(etu, semester, matiere.getGrpOption(),annee);
                if (matiereNote == null) {
                    // Si pas de note, on met 0
                    list.add(new Notes(etu, matiere.getId(), semester, 0.0,annee));
                }
                else {
                    String matiereId = (String) matiereNote[0];
                    double maxNote = (double) matiereNote[1];
                    list.add(new Notes(etu, matiereId, semester, maxNote,annee));
                }

                groupesTraites.add(matiere.getGrpOption());
            } else if (matiere.getOptionnel() == 0) {
                // Traitement des matières non optionnelles
                Object[] noteMatiere = getNotesMatiereDeliberation(etu, semester, matiere.getId(),annee);
                if (noteMatiere != null) {
                    String matiereId = (String) noteMatiere[0];
                    double note = (double) noteMatiere[1];
                    list.add(new Notes(etu, matiereId, semester, note,annee));
                }
            }
        }
        return list;
    }

    public void afficherNotesWithoutCreditAvantDeliberation(String etu, int semester,int annee) throws SQLException {
        List<Notes> notesEtudiant = getNotesWithoutCreditAvantDeliberation(etu, semester,annee);
        List<Integer> credits = getCreditNotes2(etu, semester, notesEtudiant,annee);

        if (notesEtudiant.isEmpty()) {
            System.out.println("Aucune note disponible pour l'étudiant " + etu + " au semestre " + semester);
        } else {
            System.out.println("Notes et crédits Avant deliberations de l'étudiant " + etu + " pour le semestre " + semester + " :");
            for (int i = 0; i < notesEtudiant.size(); i++) {
                Notes note = notesEtudiant.get(i);
                int credit = (i < credits.size()) ? credits.get(i) : 0; // Gestion des cas où la liste des crédits est plus courte
                System.out.println("Matière : " + note.getIdMatiere() + " | Note : " + note.getValeur() + " | Crédit : " + credit);
            }
        }
    }

    public boolean hasNotesInDeliberation(String etu, int semester,int annee) throws SQLException {
        String query = "SELECT COUNT(*) FROM DELIBERATION WHERE ETU = ? AND ID_SEMESTRE = ? AND ANNEE = ?";
        try (PreparedStatement pstmt = con.getConnectionOracle().prepareStatement(query)) {
            pstmt.setString(1, etu);
            pstmt.setInt(2, semester);
            pstmt.setInt(3,annee);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public List<Etudiant> getAdmittedAfterDeliberation(int semester,int annee) throws SQLException {
        List<Etudiant> admittedAfter = new ArrayList<>();
        List<Etudiant> allStudents = getAllEtudiant();

        for (Etudiant etudiant : allStudents) {
            if (hasNotesInDeliberation(etudiant.getETU(), semester,annee) && thisStudentPass(etudiant.getETU(), semester,getNotesWithoutCredit(etudiant.getETU(),semester,annee),annee)) {
                admittedAfter.add(etudiant);
            }
        }

        return admittedAfter;
    }

    public List<Etudiant> getAdmittedBeforeDeliberation(int semester,int annee) throws SQLException {
        List<Etudiant> admittedBefore = new ArrayList<>();
        List<Etudiant> allStudents = getAllEtudiant();

        for (Etudiant etudiant : allStudents) {
            if (!hasNotesInDeliberation(etudiant.getETU(), semester,annee) && thisStudentPass(etudiant.getETU(), semester,getNotesWithoutCreditAvantDeliberation(etudiant.getETU(),semester,annee),annee)) {
                admittedBefore.add(etudiant);
            }
        }
        return admittedBefore;
    }

    private int getIdSemestre(String idMatiere) throws SQLException {
        String query = "SELECT ID_SEMESTRE FROM MATIERES WHERE ID = ?";
        try (PreparedStatement stmt = con.getConnectionOracle().prepareStatement(query)) {
            stmt.setString(1, idMatiere);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("ID_SEMESTRE");
                } else {
                    throw new SQLException("Matière introuvable : " + idMatiere);
                }
            }
        }
    }

    // Méthode pour importer les notes depuis un fichier TXT ou CSV
    public void importerNotes(File fichier) {
        String insertSQL = "INSERT INTO NOTES (NOTE_ID, ETU, ID_MATIERE, ID_SEMESTRE, VALEUR) "
                + "VALUES (NOTE_SEQ.NEXTVAL, ?, ?, ?, ?)";

        try (BufferedReader reader = new BufferedReader(new FileReader(fichier));
             PreparedStatement insertStmt = con.getConnectionOracle().prepareStatement(insertSQL)) {

            String ligne;
            int compteur = 0;

            while ((ligne = reader.readLine()) != null) {
                // Supprimer les slash (//) à la fin de la ligne
                ligne = ligne.trim();
                while (ligne.endsWith("/")) {
                    ligne = ligne.substring(0, ligne.length() - 1).trim();
                }

                String[] donnees = ligne.split(";"); // Séparer les données par ';'

                if (donnees.length < 3) {
                    // Ignorer la ligne si elle est mal formatée
                    System.out.println("Ligne ignorée : " + ligne);
                    continue;
                }

                String idEtudiant = donnees[0];
                String idMatiere = donnees[1];

                // Récupérer l'ID du semestre pour cette matière
                int idSemestre;
                try {
                    idSemestre = getIdSemestre(idMatiere);
                } catch (SQLException e) {
                    System.err.println("Erreur : " + e.getMessage());
                    continue; // Ignorer cette ligne si la matière est introuvable
                }

                // Ajouter chaque note pour cet étudiant et cette matière
                for (int i = 2; i < donnees.length; i++) {
                    try {
                        double valeurNote = Double.parseDouble(donnees[i]);

                        // Préparer la requête d'insertion
                        insertStmt.setString(1, idEtudiant);
                        insertStmt.setString(2, idMatiere);
                        insertStmt.setInt(3, idSemestre);
                        insertStmt.setDouble(4, valeurNote);

                        insertStmt.addBatch(); // Ajouter la requête au batch
                        compteur++;
                    } catch (NumberFormatException e) {
                        System.out.println("Note non valide ignorée : " + donnees[i]);
                    }
                }
            }

            // Exécuter toutes les requêtes
            int[] resultats = insertStmt.executeBatch();
            System.out.println("Importation terminée : " + resultats.length + " notes insérées.");
        } catch (IOException e) {
            System.err.println("Erreur de lecture du fichier : " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Erreur SQL : " + e.getMessage());
        }
    }

    public List<Etudiant>getEtudiantForSemestre(int semestre,int annee)throws SQLException{
        List<Etudiant> allEtudiant = getAllEtudiant();
        List<Etudiant> list = new ArrayList<Etudiant>();
        for(Etudiant e : allEtudiant){
            if(moyenneGeneraleSemestre(e.getETU(),semestre,getNotesWithoutCredit(e.getETU(),semestre,annee))!=0){
                list.add(e);
            }
        }
        return list;
    }

    ///=========================================> SUJET VAOVAO
    /// insertion notes



    public void insertNotes(String etu,int semestre,String idMatiere,double valeur,int annee) throws SQLException{
        String insert = "INSERT INTO NOTES (NOTE_ID,ETU,ID_MATIERE,ID_SEMESTRE,VALEUR,ANNEE) VALUES (NOTE_SEQ.NEXTVAL,?,?,?,?,?)";
        try(PreparedStatement stmt = con.getConnectionOracle().prepareStatement(insert)){
            stmt.setString(1,etu);
            stmt.setString(2,idMatiere);
            stmt.setInt(3,semestre);
            stmt.setDouble(4,valeur);
            stmt.setInt(5,annee);
            stmt.executeUpdate();
            System.out.println("Notes ajouter pour l'etudiant " + etu);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
