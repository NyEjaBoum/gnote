//package gecolage;
//
//import java.sql.*;
//import java.time.LocalDate;
//
//import gnote.*;
//import connexion.*;
//import gnote.Functions;
//
//import java.util.List;
//import java.util.ArrayList;
//
//
/////CREATE SEQUENCE seq_annee_scolaire
///// START WITH 1
///// INCREMENT BY 1;
//
/////create sequence seq_ecolage start with 1 increment by 1;
///// create sequence seq_payement_ecolage start with 1 increment by 1;
//
//
//public class GestionEcolage {
//    private Connect con;
//
//    public GestionEcolage(Connect con) throws SQLException {
//        this.con = con;
//    }
//
//    public void insertAnneeScolaire(LocalDate debut,LocalDate fin)throws SQLException{
//        String insert = "INSERT INTO ANNEESCOLAIRE VALUES (?,?)";
//        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(insert)) {
//            ps.setDate(1, Date.valueOf(debut));
//            ps.setDate(2, Date.valueOf(fin));
//            // Exécuter la requête
//            ps.executeUpdate();
//            System.out.println("Insertion réussie !");
//        } catch (SQLException e) {
//            System.err.println("Errecur lors de l'insertion : " + e.getMessage());
//            throw e;
//        }
//    }
//
//    public void insertEcolage(int idAnneeScolaire,double valeur)throws SQLException{
//        String sql = "INSERT INTO ECOLAGE (ID_ANNEE_SCOLAIRE,VALEUR) VALUES (?,?)";
//        try(PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)){
//            ps.setInt(1,idAnneeScolaire);
//            ps.setDouble(2,valeur);
//            ps.executeUpdate();
//        } catch (SQLException e) {
//            throw new RuntimeException(e);
//        }
//    }
//
//    public List<PayementEcolage> getPayementsByEtuAndAnnee(String etu, int idAnneeScolaire) throws SQLException {
//    List<PayementEcolage> payements = new ArrayList<>();
//    String sql = "SELECT ETU, ID_ANNEE_SCOLAIRE, MONTANT FROM PAYEMENTECOLAGE WHERE ID_ANNEE_SCOLAIRE = ? AND ETU = ?";
//
//    try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
//        ps.setInt(1, idAnneeScolaire);
//        ps.setString(2, etu);
//
//        try (ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                String etudiant = rs.getString("ETU");
//                int idEcolage = rs.getInt("ID_ANNEE_SCOLAIRE");
//                double montant = rs.getDouble("MONTANT");
//
//                payements.add(new PayementEcolage(etudiant, idEcolage, montant));
//            }
//        }
//    } catch (SQLException e) {
//        throw new RuntimeException("Erreur lors de la récupération des paiements", e);
//    }
//
//    return payements;
//}
//
//
//    public int getNombreMoisAnneeScolaire(int idAnneeScolaire) throws SQLException {
//        String sql = "SELECT DATE_DEBUT, DATE_FIN FROM ANNEESCOLAIRE WHERE ID = ?";
//        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
//            ps.setInt(1, idAnneeScolaire);
//
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    // Récupérer les dates
//                    Date dateDebut = rs.getDate("DATE_DEBUT");
//                    Date dateFin = rs.getDate("DATE_FIN");
//
//                    // Calculer la différence en mois
//                    int moisDebut = dateDebut.toLocalDate().getMonthValue();
//                    int anneeDebut = dateDebut.toLocalDate().getYear();
//                    int moisFin = dateFin.toLocalDate().getMonthValue();
//                    int anneeFin = dateFin.toLocalDate().getYear();
//
//                    // Calculer la différence en mois
//                    int differenceAnnee = anneeFin - anneeDebut;
//                    int differenceMois = moisFin - moisDebut;
//
//                    // Nombre total de mois
//                    return differenceAnnee * 12 + differenceMois + 1; // +1 pour inclure le mois de début
//                } else {
//                    throw new SQLException("Année scolaire non trouvée pour ID : " + idAnneeScolaire);
//                }
//            }
//        }
//    }
//
//
//    public int[] getMoisEtAnneeDebut(int idAnneeScolaire) throws SQLException {
//        String sql = "SELECT EXTRACT(MONTH FROM DATE_DEBUT) AS mois, EXTRACT(YEAR FROM DATE_DEBUT) AS annee FROM ANNEESCOLAIRE WHERE ID = ?";
//        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
//            ps.setInt(1, idAnneeScolaire);
//
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    int mois = rs.getInt("mois");
//                    int annee = rs.getInt("annee");
//                    return new int[]{mois, annee}; // Retourne le mois et l'année
//                } else {
//                    throw new SQLException("Année scolaire non trouvée pour ID : " + idAnneeScolaire);
//                }
//            }
//        }
//    }
//
//    public double getMontantMensuelEcolage(int idAnneeScolaire) throws SQLException {
//        double montantAnnuel = 0.0;
//        String sql = "SELECT VALEUR FROM ECOLAGE WHERE ID_ANNEE_SCOLAIRE = ?";
//        // Connexion et préparation de la requête SQL
//        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
//            ps.setInt(1, idAnneeScolaire); // Injection du paramètre idAnneeScolaire
//
//            // Exécution de la requête et récupération des résultats
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    montantAnnuel = rs.getDouble("VALEUR");
//                } else {
//                    throw new SQLException("Aucune donnée trouvée pour l'année scolaire " + idAnneeScolaire);
//                }
//            }
//        } catch (SQLException e) {
//            throw new RuntimeException("Erreur SQL : " + e.getMessage(), e);
//        }
//
//        return montantAnnuel;
//    }
//
//    public double getMontantAnnuelEcolage(int idAnneeScolaire) throws SQLException {
//        double montantAnnuel = 0.0;
//        String sql = "SELECT VALEUR FROM ECOLAGE WHERE ID_ANNEE_SCOLAIRE = ?";
//        int nbMois = getNombreMoisAnneeScolaire(idAnneeScolaire); /// nb de mois par annee scolaire
//        // Connexion et préparation de la requête SQL
//        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
//            ps.setInt(1, idAnneeScolaire); // Injection du paramètre idAnneeScolaire
//
//            // Exécution de la requête et récupération des résultats
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    montantAnnuel = rs.getDouble("VALEUR") * nbMois;
//                } else {
//                    throw new SQLException("Aucune donnée trouvée pour l'année scolaire " + idAnneeScolaire);
//                }
//            }
//        } catch (SQLException e) {
//            throw new RuntimeException("Erreur SQL : " + e.getMessage(), e);
//        }
//
//        return montantAnnuel;
//    }
//
//
//    public int moisDifference(LocalDate now, int idAnneeScolaire) throws SQLException {
//        // Obtenir l'année et le mois de la date actuelle
//        int anneeNow = now.getYear();
//        int moisNow = now.getMonthValue();
//
//        // Obtenir l'année et le mois de début de l'année scolaire
//        int[] moisDebut = getMoisEtAnneeDebut(idAnneeScolaire);
//        int anneeDebut = moisDebut[1];
//        int moisDebutAnnee = moisDebut[0];
//
//        // Calculer la différence en mois
//        int difference = (anneeNow - anneeDebut) * 12 + (moisNow - moisDebutAnnee);
//
//        return difference+1;
//    }
//
//    public double ecolageTotalPaye(String etu,int idAnneeScolaire)throws SQLException{
//        double result = 0;
//        String sql = "SELECT SUM(MONTANT) as somme  FROM PAYEMENTECOLAGE WHERE ID_ANNEE_SCOLAIRE = ? AND ETU = ?";
//        try(PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)){
//            ps.setInt(1,idAnneeScolaire);
//            ps.setString(2,etu);
//            //ps.executeUpdate();
//            try(ResultSet rs = ps.executeQuery()){
//                if(rs.next()){
//                    result = rs.getDouble("somme");
//                }
//                else{
//                    throw new SQLException("ERREUR DANS PAYEMENTECOLAGE");
//                }
//            }
//        } catch (SQLException e) {
//            throw new RuntimeException(e);
//        }
//        return result;
//    }
//
//    public int nombreMoisPaye(String etu,int idEcolage)throws SQLException{
//        int result = 0;
//            double totalPaye = ecolageTotalPaye(etu,idEcolage);
//            double montantAnnuel = getMontantAnnuelEcolage(idEcolage);
//            result = (int) ((totalPaye * 12) / montantAnnuel);
//        return result;
//    }
//
//
//    public boolean nandoaEcolageVeMois(String etu,int idAnneeScolaire,LocalDate now)throws SQLException{
//        int moisDif = moisDifference(now,idAnneeScolaire);
//        int nombreMoisPaye = nombreMoisPaye(etu,idAnneeScolaire);
//        if(moisDif == nombreMoisPaye || moisDif < nombreMoisPaye){
//            return true;
//        }
//        return false;
//    }
//
//    //public Semestre getDistinctSemestre
//
//    public boolean nandoaEcolageVeSemestre(String etu,int idAnneeScolaire,int semestre,LocalDate now)throws SQLException{
//        Functions f = new Functions(con);
//        Semestre s = f.getSemestre(semestre);
//
//        int numero = Integer.parseInt(s.getNom().substring(1));
//
//        int moisDif = moisDifference(now,idAnneeScolaire);
//        int nombreMoisPaye = nombreMoisPaye(etu,idAnneeScolaire);
//        int moisRequis = (numero*6); // Impair : 6 mois, Pair : 12 mois
//        return nombreMoisPaye >= moisRequis;
//    }
//
//public List<ModePaiement> getAllModePaiement() throws SQLException {
//    String sql = "SELECT ID, MODE FROM ModePaiement";
//    List<ModePaiement> modes = new ArrayList<>();
//
//    try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql);
//         ResultSet rs = ps.executeQuery()) {
//        while (rs.next()) {
//            int id = rs.getInt("ID");
//            String mode = rs.getString("MODE");
//            modes.add(new ModePaiement(id, mode));
//        }
//    }
//
//    return modes;
//}
//
//// public boolean isMontantValide(int idAnneeScolaire,double montant, int idMode)throws SQLException{
////     double valeurEcolage = getMontantMensuelEcolage(idAnneeScolaire);
////     if (idMode == 1) { // Mensuel
////         return montant >= valeurEcolage;
////     }
////     if (idMode == 2) { // Trimestriel
////         return montant >= (valeurEcolage * 3)-(valeurEcolage*3*0.06);
////     }
////     if (idMode == 3) { // Semestriel
////         return montant >= (valeurEcolage * 6)-(valeurEcolage*6*0.12);
////     }
////     if (idMode == 4) { // Annuel
////         return montant >= (valeurEcolage * 12)-(valeurEcolage*12*0.2);
////     }
//
////     // Si le mode de paiement n'est pas reconnu
////     throw new IllegalArgumentException("Mode de paiement inconnu avec ID : " + idMode);
//// }
//
//public boolean isMontantValide(int idAnneeScolaire, double montant, int idMode) throws SQLException {
//    double valeurEcolage = getMontantMensuelEcolage(idAnneeScolaire);
//    double montantAttendu = 0;
//
//    if (idMode == 1) { // Mensuel
//        montantAttendu = valeurEcolage;
//    } else if (idMode == 2) { // Trimestriel
//        montantAttendu = valeurEcolage * 3 * (1 - 0.06); // 6%
//    } else if (idMode == 3) { // Semestriel
//        montantAttendu = valeurEcolage * 6 * (1 - 0.12); // 12%
//    } else if (idMode == 4) { // Annuel
//        montantAttendu = valeurEcolage * 12 * (1 - 0.20); //20%
//    } else {
//        throw new IllegalArgumentException("Mode de paiement inconnu avec ID : " + idMode);
//    }
//
//    return montant >= montantAttendu;
//}
//
//
//
//
//    public double getReste(String etu, int idAnnee) throws SQLException {
//        double result = 0;
//        String sql = "SELECT RESTE FROM PAYEMENTECOLAGE WHERE ETU = ? AND ID_ANNEE_SCOLAIRE = ? ORDER BY ID DESC LIMIT 1";
//
//        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
//            ps.setString(1, etu);
//            ps.setInt(2, idAnnee);
//
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    result = rs.getDouble("RESTE");
//                } else {
//                    //throw new SQLException("Aucun résultat trouvé pour l'étudiant et l'année scolaire spécifiés.");
//                }
//            }
//        } catch (SQLException e) {
//            throw e; // Relance l'exception SQL pour permettre une gestion au niveau supérieur.
//        } catch (Exception e) {
//            throw new RuntimeException("Erreur inattendue lors de l'exécution de getReste.", e);
//        }
//
//        return result;
//    }
//
//
//    // public double getSurplusPaiement(String etu,int idAnneeScolaire,double montantPaye,int ModePaiement)throws SQLException{
//    //     double ecolageMensuel = getMontantMensuelEcolage(idAnneeScolaire);
//    //     double ecolagetotalRequis = ecolageMensuel * getNombreMoisRequis(ModePaiement);
//    //     return Math.max(0,montantPaye-ecolagetotalRequis);
//    // }
//
//    public double getSurplusPaiement(String etu, int idAnneeScolaire, double montantPaye, int ModePaiement) throws SQLException {
//    double ecolageMensuel = getMontantMensuelEcolage(idAnneeScolaire);
//    double ecolagetotalRequis;
//
//    switch (ModePaiement) {
//        case 1: // Mensuel
//            ecolagetotalRequis = ecolageMensuel * 1;
//            break;
//        case 2: // Trimestriel
//            ecolagetotalRequis = ecolageMensuel * 3 * (1 - 0.06); // 6%
//            break;
//        case 3: // Semestriel
//            ecolagetotalRequis = ecolageMensuel * 6 * (1 - 0.12); // 12%
//            break;
//        case 4: // Annuel
//            ecolagetotalRequis = ecolageMensuel * 12 * (1 - 0.20); // 20%
//            break;
//        default:
//            throw new IllegalArgumentException("Mode de paiement inconnu avec ID : " + ModePaiement);
//    }
//
//    // Retourner le surplus, en s'assurant que ce ne soit pas négatif
//    return Math.max(0, montantPaye - ecolagetotalRequis);
//}
//
//
//
//public int getNombreMoisRequis(int idMode) {
//    switch (idMode) {
//        case 1: // Mensuel
//            return 1;
//        case 2: // Trimestriel
//            return 3;
//        case 3: // Semestriel
//            return 6;
//        case 4: // Annuel
//            return 12;
//        default:
//            throw new IllegalArgumentException("Mode de paiement inconnu avec ID : " + idMode);
//    }
//}
//
//
//    public void mandoaEcolage(String etu,int idAnneeScolaire,double montant,int idModePaiement)throws SQLException{
//
//        double surplus = getSurplusPaiement(etu,idAnneeScolaire,montant,idModePaiement);
//        double reste = getReste(etu,idAnneeScolaire);
//        double apayer = montant + reste;
//        String sql = "INSERT INTO PAYEMENTECOLAGE (ETU,ID_ANNEE_SCOLAIRE,MONTANT,ID_MODE_PAIEMENT,RESTE) VALUES (?,?,?,?,?)";
//
//        try(PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)){
//            ps.setString(1,etu);
//            ps.setInt(2,idAnneeScolaire);
//            ps.setDouble(3,apayer);
//            ps.setInt(4, idModePaiement);
//            ps.setDouble(5, surplus);
//            if(isMontantValide(idAnneeScolaire,apayer,idModePaiement)){
//                ps.executeUpdate();
//            }else{
//                throw new RuntimeException("Le montant payé ne respecte pas les règles pour le mode de paiement " + idModePaiement);
//            }
//            System.out.println("Etudiant " + etu + " a paye l'ecolage de annee scolaire "+ idAnneeScolaire);
//        } catch (SQLException e) {
//            throw new RuntimeException(e);
//        }
//    }
//
//    public int getIdAnneeScolaireActuelle(String etu) throws SQLException {
//    int annee = 0;
//
//    // Étape 1 : Obtenir l'année la plus récente dans NOTES
//    String queryNotes = "SELECT MAX(ANNEE) AS ANNEE FROM NOTES WHERE ETU = ?";
//    try (PreparedStatement pstmt = con.getConnectionOracle().prepareStatement(queryNotes)) {
//        pstmt.setString(1, etu);
//
//        try (ResultSet rs = pstmt.executeQuery()) {
//            if (rs.next()) {
//                annee = rs.getInt("ANNEE");
//            }
//        }
//    }
//
//    if (annee == 0) {
//        throw new SQLException("Aucune année trouvée pour l'étudiant " + etu);
//    }
//
//    // Étape 2 : Trouver l'année scolaire correspondante dans AnneeScolaire (MySQL)
//    String queryAnneeScolaire = "SELECT ID FROM AnneeScolaire WHERE ? BETWEEN YEAR(DATE_DEBUT) AND YEAR(DATE_FIN)";
//    try (PreparedStatement pstmt = con.getConnectionMysql().prepareStatement(queryAnneeScolaire)) {
//        pstmt.setInt(1, annee);
//
//        try (ResultSet rs = pstmt.executeQuery()) {
//            if (rs.next()) {
//                return rs.getInt("ID");
//            } else {
//                throw new SQLException("Aucune année scolaire correspondante trouvée pour l'année " + annee);
//            }
//        }
//    }
//}
//
//
//}
