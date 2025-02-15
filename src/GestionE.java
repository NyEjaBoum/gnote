package gecolage;

import java.sql.*;
import java.sql.Date;
import java.time.*;
import gnote.*;
import connexion.*;
import java.util.*;
import java.util.ArrayList;
import java.util.List;

public class GestionE {
    private Connect con;
    public GestionE(Connect con) throws SQLException{
        this.con = con;
    }

public void insertModePaiementEtudiant(String etu, int idModePaiement, int idAnneeScolaire) throws SQLException {
    String insert = "INSERT INTO modepaiementetudiant (ETU, ID_MODE_PAYEMENT, ID_ANNEE_SCOLAIRE) VALUES (?, ?, ?)";
    try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(insert)) {
        ps.setString(1, etu);
        ps.setInt(2, idModePaiement);
        ps.setInt(3, idAnneeScolaire);

        // Exécuter la requête
        ps.executeUpdate();
        System.out.println("Mode de paiement inséré avec succès pour l'étudiant " + etu);
    } catch (SQLException e) {
        System.err.println("Erreur lors de l'insertion du mode de paiement : " + e.getMessage());
        throw e;
    }
}


    public void insertAnneeScolaire(String nom,LocalDate debut,LocalDate fin,double montantDroit)throws SQLException{
        String insert = "INSERT INTO ANNEESCOLAIRE (NOM,DATE_DEBUT,DATE_FIN,montantDroit) VALUES (?,?,?,?)";
        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(insert)) {
            ps.setString(1,nom);
            ps.setDate(2, Date.valueOf(debut));
            ps.setDate(3, Date.valueOf(fin));
            ps.setDouble(4,montantDroit);
            // Exécuter la requête
            ps.executeUpdate();
            System.out.println("Insertion réussie !");
        } catch (SQLException e) {
            System.err.println("Erreur lors de l'insertion : " + e.getMessage());
            throw e;
        }
    }

    public void insertEcolage(int idAnneeScolaire,double valeur)throws SQLException{
        String sql = "INSERT INTO ECOLAGE (ID_ANNEE_SCOLAIRE,MONTANT_ANNUEL ) VALUES (?,?)";
        try(PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)){
            ps.setInt(1,idAnneeScolaire);
            ps.setDouble(2,valeur);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    

    /////=======>LOGQIUE ANNEESCOLAIRE

    public List<AnneeScolaire> getAllAnneeScolaire() throws SQLException {
        String sql = "SELECT * FROM ANNEESCOLAIRE";
        List<AnneeScolaire> list = new ArrayList<>();

        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("ID");
                    String nom = rs.getString("NOM");
                    LocalDate dateDebut = rs.getDate("DATE_DEBUT").toLocalDate();
                    LocalDate dateFin = rs.getDate("DATE_FIN").toLocalDate();
                    double montantDroit = rs.getDouble("montantDroit");
                    // Ajouter l'année scolaire dans la liste en utilisant le constructeur spécifique
                    list.add(new AnneeScolaire(id,nom,dateDebut, dateFin,montantDroit));
                }
            }
        }

        return list;
    }

    public int getNombreMoisAnneeScolaire(int idAnneeScolaire) throws SQLException {
        String sql = "SELECT DATE_DEBUT, DATE_FIN FROM ANNEESCOLAIRE WHERE ID = ?";
        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
            ps.setInt(1, idAnneeScolaire);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Récupérer les dates
                    Date dateDebut = rs.getDate("DATE_DEBUT");
                    Date dateFin = rs.getDate("DATE_FIN");

                    // Calculer la différence en mois
                    int moisDebut = dateDebut.toLocalDate().getMonthValue();
                    int anneeDebut = dateDebut.toLocalDate().getYear();
                    int moisFin = dateFin.toLocalDate().getMonthValue();
                    int anneeFin = dateFin.toLocalDate().getYear();

                    // Calculer la différence en mois
                    int differenceAnnee = anneeFin - anneeDebut;
                    int differenceMois = moisFin - moisDebut;

                    // Nombre total de mois
                    return differenceAnnee * 12 + differenceMois + 1; // +1 pour inclure le mois de début
                } else {
                    throw new SQLException("Année scolaire non trouvée pour ID : " + idAnneeScolaire);
                }
            }
        }
    }

    public int[] getMoisEtAnneeDebut(int idAnneeScolaire) throws SQLException {
        String sql = "SELECT EXTRACT(MONTH FROM DATE_DEBUT) AS mois, EXTRACT(YEAR FROM DATE_DEBUT) AS annee FROM ANNEESCOLAIRE WHERE ID = ?";
        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
            ps.setInt(1, idAnneeScolaire);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int mois = rs.getInt("mois");
                    int annee = rs.getInt("annee");
                    return new int[]{mois, annee}; // Retourne le mois et l'année
                } else {
                    throw new SQLException("Année scolaire non trouvée pour ID : " + idAnneeScolaire);
                }
            }
        }
    }

    public int getMoisDifference(LocalDate now, int idAnneeScolaire) throws SQLException {
        // Obtenir l'année et le mois de la date actuelle
        int anneeNow = now.getYear();
        int moisNow = now.getMonthValue();

        // Obtenir l'année et le mois de début de l'année scolaire
        int[] moisDebut = getMoisEtAnneeDebut(idAnneeScolaire);
        int anneeDebut = moisDebut[1];
        int moisDebutAnnee = moisDebut[0];

        // Calculer la différence en mois
        int difference = (anneeNow - anneeDebut) * 12 + (moisNow - moisDebutAnnee);

        return difference+1;
    }

    ///======> LOGIQUE ECOLAGE

//    public Ecolage getEcolage(int idanneeScolaire) throws SQLException{
//        String sql = "SELECT * FROM ECOLAGE WHERE ID_ANNEE_SCOLAIRE = ?";
//        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)){
//            ps.setInt(1,idanneeScolaire);
//            try(ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) {
//                    int idAnneeScolaire = rs.getInt("ID_ANNEE_SCOLAIRE");
//                    double montantAnnuel = rs.getDouble("MONTANT_ANNUEL");
//                    return new Ecolage(idanneeScolaire,montantAnnuel);
//                }
//            }
//        }
//        return null;
//    }


    public double getEcolage(int idanneeScolaire) throws SQLException{
        double montantAnnuel = 0;
        String sql = "SELECT MONTANT_ANNUEL FROM ECOLAGE WHERE ID_ANNEE_SCOLAIRE = ?";
        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)){
            ps.setInt(1,idanneeScolaire);
            try(ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    montantAnnuel = rs.getDouble("MONTANT_ANNUEL");
                    return montantAnnuel;
                }
            }
        }
        return 0;
    }

    public double ecolageTotalPayeAnneeScolaire(String etu,int idAnneeScolaire)throws SQLException{
        double result = 0;
        String sql = "SELECT SUM(MONTANT) as somme  FROM PAYEMENTECOLAGE WHERE ID_ANNEE_SCOLAIRE = ? AND ETU = ?";
        try(PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)){
            ps.setInt(1,idAnneeScolaire);
            ps.setString(2,etu);
            //ps.executeUpdate();
            try(ResultSet rs = ps.executeQuery()){
                if(rs.next()){
                    result = rs.getDouble("somme");
                }
                else{
                    throw new SQLException("ERREUR DANS PAYEMENTECOLAGE");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return result;
    }

    public double ecolageTotalPaye(String etu)throws SQLException{
        double result = 0;
        String sql = "SELECT SUM(MONTANT) as somme  FROM PAYEMENTECOLAGE WHERE ETU = ?";
        try(PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)){
            //ps.setInt(1,idAnneeScolaire);
            ps.setString(1,etu);
            //ps.executeUpdate();
            try(ResultSet rs = ps.executeQuery()){
                if(rs.next()){
                    result = rs.getDouble("somme");
                }
                else{
                    throw new SQLException("ERREUR DANS PAYEMENTECOLAGE");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return result;
    }

//    public int getNombreMoisPaye(String etu,int idAnneeScolaire) throws SQLException{
//        int result = 0;
//        double payedTotal = ecolageTotalPaye(etu,idAnneeScolaire);
//        double montantAttendu = getMontantAttendu(etu,idAnneeScolaire);
//        int nbMoisAnneeScolaire = getNombreMoisAnneeScolaire(idAnneeScolaire);
//        result = (int) ((payedTotal*nbMoisAnneeScolaire)/montantAttendu);
//        return result;
//    }

    public int getNombreMoisPaye(String etu, int idAnneeScolaire) throws SQLException {
        int result = 0;

        double payedTotal = ecolageTotalPaye(etu);

        double montantAttendu = getMontantAttendu(etu, idAnneeScolaire);

        int idMode = getModePaiementEtudiant(etu, idAnneeScolaire);

        // Nombre de mois réellement payés selon le mode de paiement
        if (idMode == 1) { // Mensuel
            result = (int) (payedTotal / montantAttendu);
        } else if (idMode == 2) { // Trimestriel
            result = (int) (payedTotal / montantAttendu) * 3;
        } else if (idMode == 3) { // Semestriel
            result = (int) (payedTotal / montantAttendu) * 6;
        } else if (idMode == 4) { // Annuel
            result = (int) (payedTotal / montantAttendu) * 12;
        } else {
            throw new IllegalArgumentException("Mode de paiement inconnu avec ID : " + idMode);
        }


        return result;
    }



    public boolean checkEcolageMois(String etu,int idAnneeScolaire,LocalDate now) throws SQLException{
        int moisDeDifference = getMoisDifference(now,idAnneeScolaire);
        int nbMoisPaye = getNombreMoisPaye(etu,idAnneeScolaire);
        if(nbMoisPaye >= moisDeDifference){
            return true;
        }
        return false;
    }

    public boolean checkEcolageSemestre(String etu,int idAnneeScolaire,int semestre) throws SQLException{
        gnote.Functions f = new gnote.Functions(con);
        Semestre s = f.getSemestre(semestre);

        int numero = Integer.parseInt(s.getNom().substring(1));

        int nombreMoisPaye = getNombreMoisPaye(etu,idAnneeScolaire);
        int moisRequis = (numero*6); // Impair : 6 mois, Pair : 12 mois
        return nombreMoisPaye >= moisRequis;
    }

    ///=======> LOGIQUE PAYEMENTECOLAGE

    public List<ModePaiement> getAllModePaiement() throws SQLException {
        String sql = "SELECT ID, MODE FROM ModePaiement";
        List<ModePaiement> modes = new ArrayList<>();

        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("ID");
                String mode = rs.getString("MODE");
                modes.add(new ModePaiement(id, mode));
            }
        }

        return modes;
    }

    public int getModePaiementEtudiant(String etu,int idAnneeScolaire) throws SQLException{
        int result = 0;
        String sql = "SELECT * FROM MODEPAIEMENTETUDIANT WHERE ETU = ? AND ID_ANNEE_SCOLAIRE = ?";
        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)){
            ps.setString(1,etu);
            ps.setInt(2,idAnneeScolaire);
            try(ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    result = rs.getInt("ID_MODE_PAYEMENT");
                    return result;
                }
            }
        }
        return result;
    }

    public double getMontantAttendu(String etu, int idAnneeScolaire) throws SQLException {
        double montantAnnuel = getEcolage(idAnneeScolaire)/12; // Calcul du montant mensuel
        int idMode = getModePaiementEtudiant(etu, idAnneeScolaire); // Récupération du mode de paiement
        double montantAttendu = 0;

        if (idMode == 1) { // Mensuel
            montantAttendu = montantAnnuel;
        } else if (idMode == 2) { // Trimestriel
            montantAttendu = montantAnnuel * 3 * (1 - 0.06);
        } else if (idMode == 3) { // Semestriel
            montantAttendu = montantAnnuel * 6 * (1 - 0.12);
        } else if (idMode == 4) { // Annuel
            montantAttendu = montantAnnuel * 12 * (1 - 0.20);
        } else {
            throw new IllegalArgumentException("Mode de paiement inconnu avec ID : " + idMode);
        }

        return montantAttendu;
    }

    public double getMontantAttenduForReste(String etu, int idAnneeScolaire) throws SQLException {
    double montantAnnuel = getEcolage(idAnneeScolaire); 
    int idMode = getModePaiementEtudiant(etu, idAnneeScolaire); 
    double montantAttenduAnnuel = 0;

    if (idMode == 1) { // Mensuel
        montantAttenduAnnuel = montantAnnuel; 
    } else if (idMode == 2) { // Trimestriel
        montantAttenduAnnuel = montantAnnuel * (1 - 0.06); 
    } else if (idMode == 3) { // Semestriel
        montantAttenduAnnuel = montantAnnuel * (1 - 0.12); 
    } else if (idMode == 4) { // Annuel
        montantAttenduAnnuel = montantAnnuel * (1 - 0.20); 
    } else {
        throw new IllegalArgumentException("Mode de paiement inconnu avec ID : " + idMode);
    }

    return montantAttenduAnnuel;
}


    public double getSurplusPaiement(String etu,int idAnneeScolaire,double montantPaye) throws SQLException{
        double montantAttendu = getMontantAttendu(etu, idAnneeScolaire);
        double result = 0;
        return result = Math.max(0,montantPaye - montantAttendu);
    }

        public double getSurplusPaiementAnnee(String etu,int idAnneeScolaire,double montantPaye) throws SQLException{
        double montantAttendu = getMontantAttenduForReste(etu, idAnneeScolaire);
        double result = 0;
        return result = Math.max(0,montantPaye - montantAttendu);
    }

    public double getReste(String etu) throws SQLException {
        double result = 0;
        String sql = "SELECT RESTE FROM PAYEMENTECOLAGE WHERE ETU = ? ORDER BY ID DESC LIMIT 1";

        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
            ps.setString(1, etu);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    result = rs.getDouble("RESTE");
                } else {
                    //throw new SQLException("Aucun résultat trouvé pour l'étudiant et l'année scolaire spécifiés.");
                }
            }
        } catch (SQLException e) {
            throw e; // Relance l'exception SQL pour permettre une gestion au niveau supérieur.
        } catch (Exception e) {
            throw new RuntimeException("Erreur inattendue lors de l'exécution de getReste.", e);
        }

        return result;
    }

    public double montantAInserer(String etu,int idAnneeScolaire)throws SQLException{
        try{
            double montantAttendu = getMontantAttendu(etu,idAnneeScolaire);
            double totalPayed = ecolageTotalPayeAnneeScolaire(etu,idAnneeScolaire);
            if(totalPayed%montantAttendu==0){
                return montantAttendu;
            }
            else{
                return montantAttendu-(totalPayed%montantAttendu);
            }
        }catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

// public void insertPayement(String etu, int idAnneeScolaire, double montant) throws SQLException {
//     double surplusAnnee = getSurplusPaiementAnnee(etu, idAnneeScolaire, montant);
//     double surplus = 0;
//     double payedTotal = ecolageTotalPayeAnneeScolaire(etu, idAnneeScolaire);
//     String sql = "INSERT INTO PAYEMENTECOLAGE (ETU, ID_ANNEE_SCOLAIRE, MONTANT) VALUES (?, ?, ?)";
//     int nextAnnee = idAnneeScolaire + 1;
    
//     try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
//         // Calcul du surplus pour l'année scolaire en cours
//         surplus = getSurplusPaiement(etu, idAnneeScolaire, montant);
        
//         // Vérifier si le paiement total suffit à payer l'année en cours
//         if (payedTotal + montant >= getMontantAttenduForReste(etu, idAnneeScolaire)) {
//             // Compléter le paiement de l'année en cours
//             double paiementAnnee1 = getMontantAttenduForReste(etu, idAnneeScolaire);
//             ps.setString(1, etu);
//             ps.setInt(2, idAnneeScolaire);
//             ps.setDouble(3, paiementAnnee1);
//             ps.executeUpdate();

//             surplus = montant - paiementAnnee1; // Calculer le surplus restant

//             // Répartir le surplus sur les années suivantes (mais ne pas dépasser le montant attendu)
//             while (surplus >= getMontantAttenduForReste(etu, nextAnnee)) {
//                 ps.setString(1, etu);
//                 ps.setInt(2, nextAnnee);
//                 ps.setDouble(3, getMontantAttenduForReste(etu, nextAnnee));
//                 ps.executeUpdate();
//                 surplus -= getMontantAttenduForReste(etu, nextAnnee);
//                 nextAnnee++;
//             }

//             // Si un surplus reste après avoir payé pour toutes les années suivantes
//             if (surplus > 0) {
//                 ps.setString(1, etu);
//                 ps.setInt(2, nextAnnee);
//                 ps.setDouble(3, surplus);
//                 ps.executeUpdate();
//             }
//         } else {
//             // Si le paiement ne suffit pas pour l'année en cours, insérer le paiement partiel
//             ps.setString(1, etu);
//             ps.setInt(2, idAnneeScolaire);
//             ps.setDouble(3, getMontantAttendu(etu, idAnneeScolaire));
//             ps.executeUpdate();

//             if (surplus != 0) {
//                 ps.setString(1, etu);
//                 ps.setInt(2, idAnneeScolaire);
//                 ps.setDouble(3, surplus);
//                 ps.executeUpdate();
//             }
//         }

//         System.out.println("Etudiant " + etu + " a payé l'ecolage de l'année scolaire " + idAnneeScolaire);

//     } catch (SQLException e) {
//         throw new RuntimeException(e);
//     }
// }

public void insertPayement(String etu, int idAnneeScolaire, double montant) throws SQLException {
    double surplusAnnee = getSurplusPaiementAnnee(etu, idAnneeScolaire, montant);
    double surplus = 0;
    double payedTotal = ecolageTotalPayeAnneeScolaire(etu, idAnneeScolaire);
    String sql = "INSERT INTO PAYEMENTECOLAGE (ETU, ID_ANNEE_SCOLAIRE, MONTANT) VALUES (?, ?, ?)";
    int nextAnnee = idAnneeScolaire + 1;
    
    try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
        // Calcul du surplus pour l'année scolaire en cours
        surplus = getSurplusPaiement(etu, idAnneeScolaire, montant);
        
        // Vérifier si le paiement total suffit à payer l'année en cours
        if (payedTotal + montant > getMontantAttenduForReste(etu, idAnneeScolaire)) {
            // Répartir le surplus sur les années suivantes (mais ne pas dépasser le montant attendu)
            double paiementAnnee1 = getMontantAttenduForReste(etu, idAnneeScolaire);
            ps.setString(1, etu);
            ps.setInt(2, idAnneeScolaire);
            ps.setDouble(3, paiementAnnee1);
            ps.executeUpdate();

            surplus = montant - paiementAnnee1; // Calculer le surplus restant

            while (surplus >= getMontantAttenduForReste(etu, nextAnnee)) {
                ps.setString(1, etu);
                ps.setInt(2, nextAnnee);
                ps.setDouble(3, getMontantAttenduForReste(etu, nextAnnee));
                ps.executeUpdate();
                surplus -= getMontantAttenduForReste(etu, nextAnnee);
                nextAnnee++;
            }

            // Si un surplus reste après avoir payé pour toutes les années suivantes
            if (surplus > 0) {
                ps.setString(1, etu);
                ps.setInt(2, nextAnnee);
                ps.setDouble(3, surplus);
                ps.executeUpdate();
            }
        } 
            else if(payedTotal + montant == getMontantAttenduForReste(etu, idAnneeScolaire)){
                ps.setString(1, etu);
                ps.setInt(2, idAnneeScolaire);
                ps.setDouble(3, montant);
                ps.executeUpdate();
            }
        else {
            // Si le paiement ne suffit pas pour l'année en cours, insérer le paiement partiel
            ps.setString(1, etu);
            ps.setInt(2, idAnneeScolaire);
            ps.setDouble(3, montantAInserer(etu,idAnneeScolaire));
            ps.executeUpdate();

            if (surplus != 0) {
                ps.setString(1, etu);
                ps.setInt(2, idAnneeScolaire);
                ps.setDouble(3, surplus);
                ps.executeUpdate();
            }
        }

        System.out.println("Etudiant " + etu + " a payé l'ecolage de l'année scolaire " + idAnneeScolaire);

    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
}

public void checkMontantInsert(String etu,int idAnneeScolaire,double montant) throws SQLException{
    double montantAttendu = montantAInserer(etu,idAnneeScolaire);
    if(montant<montantAttendu){
        throw new IllegalArgumentException("Montant insuffisant pour cette année");
    }
    else{
        insertPayement(etu,idAnneeScolaire,montant);
    }
}

public double getResteApayer(String etu, int idAnneeScolaire) throws SQLException{
    double totalPayed = ecolageTotalPayeAnneeScolaire(etu,idAnneeScolaire);
    double montantAttenduAnnuel = getMontantAttenduForReste(etu,idAnneeScolaire);
    double reste = montantAttenduAnnuel - totalPayed;
    return reste;
}

public void isAllPayed(String etu,int idAnneeScolaire)throws Exception{
    double totalPayedAnneeScolaire = getMontantAttenduForReste(etu,idAnneeScolaire);
    double totalPayed = ecolageTotalPayeAnneeScolaire(etu,idAnneeScolaire);
    if(totalPayed == totalPayedAnneeScolaire){
        throw new Exception("Vous avez deja paye la totalite de l'ecolage de l'annee " + idAnneeScolaire);
    }
}

public void insertDroitInscription(String etu, int idAnneeScolaire,double montant) throws SQLException {
    String insert = "INSERT INTO PayementDroit (ETU,ID_ANNEE_SCOLAIRE,DROIT) VALUES (?, ?, ?)";
    try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(insert)) {
        ps.setString(1, etu);
        ps.setInt(2, idAnneeScolaire);
        ps.setDouble(3, montant);

        // Exécuter la requête
        ps.executeUpdate();
        System.out.println("Droit d'inscription avec succès pour l'étudiant " + etu);
    } catch (SQLException e) {
        System.err.println("Erreur lors de l'insertion du droit d'inscription : " + e.getMessage());
        throw e;
    }
}


    public double getDroitInscription(int idAnneeScolaire) throws SQLException {
        double result = 0.0;
        String sql = "SELECT montantDroit FROM ANNEESCOLAIRE WHERE ID = ?";
        
        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
            ps.setInt(1, idAnneeScolaire);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    result = rs.getDouble("montantDroit");
                    return result; 
                }
            }
        }
        return result; 
    }

    public double getDroitPayeEtu(String etu,int idAnneeScolaire)throws SQLException{
        double result = 0.0;
        String sql = "SELECT SUM(DROIT) AS DROIT FROM PayementDroit WHERE ETU = ? AND ID_ANNEE_SCOLAIRE = ?";
        
        try (PreparedStatement ps = con.getConnectionMysql().prepareStatement(sql)) {
            ps.setString(1,etu);
            ps.setInt(2, idAnneeScolaire);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    result = rs.getDouble("DROIT");
                    return result; 
                }
            }
        }
        return result; 
    }

    public boolean nandoaDroit(String etu,int idAnneeScolaire)throws SQLException{
        double droit = getDroitInscription(idAnneeScolaire);
        double droitPaye = getDroitPayeEtu(etu,idAnneeScolaire);
        if(droit == droitPaye){
            return true;
        }
        return false;

    }

}
