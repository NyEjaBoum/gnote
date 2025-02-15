package gnote;

import java.lang.reflect.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import connexion.*;
import gecolage.*;

public class Reflect {
    public Connect con;

    public Reflect(Connect con){
        this.con = con;
    }
    public List<Field> getAttribut(Class<?> classe) {
        List<Field> allField = new ArrayList<>();
        try {
            Field[] champs = classe.getDeclaredFields();
            for (Field champ : champs) {
                allField.add(champ);
            }
        } catch (SecurityException e) {
            throw new RuntimeException("Erreur d'accès aux champs de la classe", e);
        }
        return allField;
    }

    public Class<?>getClass(String className){
        Class<?> classe = null;
        try{
            classe = Class.forName(className);
        }catch (ClassNotFoundException e) {
            System.err.println("La classe " + className + " n'a pas été trouvée.");
            e.printStackTrace();
        }
        return classe;
    }



    public List<Object[]>getDataFromTable(String className)throws SQLException {
        List<Object[]>list = new ArrayList<>();
        Class<?>classe = getClass(className);
        try {
            Statement stmt = con.getStatement(classe.getSimpleName());
            String query = "SELECT * FROM " + classe.getSimpleName();
            ResultSet rs = stmt.executeQuery(query);
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            while(rs.next()){
                Object [] row = new Object[columnCount];
                for(int i = 1; i<=columnCount; i++){
                    row[i-1] = rs.getObject(i);
                }
                list.add(row);
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public void displayData(List<Object[]> data) {
        if (data == null || data.isEmpty()) {
            System.out.println("Aucune donnée à afficher.");
            return;
        }

        // Afficher les données
        System.out.println("Données de la table :");
        for (Object[] row : data) {
            for (Object column : row) {
                System.out.print((column != null ? column.toString() : "NULL") + "\t");
            }
            System.out.println(); // Saut de ligne pour la prochaine ligne de données
        }
    }

        public boolean []isNumeric(ResultSetMetaData metaData,int columnCount) throws SQLException{
        boolean[] isNumeric = new boolean[columnCount];
        for (int i = 1; i <= columnCount; i++) {
            int columnType = metaData.getColumnType(i);
            isNumeric[i - 1] = (columnType == Types.BIGINT ||
                    columnType == Types.DECIMAL ||
                    columnType == Types.DOUBLE ||
                    columnType == Types.FLOAT ||
                    columnType == Types.INTEGER ||
                    columnType == Types.NUMERIC ||
                    columnType == Types.REAL);
        }
        return isNumeric;
    }

        public double [] somme(List<Object[]>data,boolean[] isNumeric) {
        double[]sums = new double[isNumeric.length];
        for (Object[] row : data) {
            for (int i = 0; i < row.length; i++) {
                if (isNumeric[i] && row[i] != null && row[i] instanceof Number) {
                    sums[i] += ((Number) row[i]).doubleValue();
                }
            }
        }

        return sums;

    }

    public double []moyenne(List<Object[]>data,boolean[] isNumeric){
        double []somme = somme(data,isNumeric);
        double [] moyenne = new double[isNumeric.length];
        int[] counts = new int[isNumeric.length];

        for(Object[]row : data) {
            for (int i = 0; i < row.length; i++) {
                if (isNumeric[i] && row[i] != null && row[i] instanceof Number) {
                    counts[i]++;
                }
            }
        }
        for(int i=0;i < moyenne.length; i++){
            if(counts[i]>0){
                moyenne[i] = somme[i] / counts[i];
            }
        }
        return moyenne;
    }

public String genererHTML(String className) {
    StringBuilder html = new StringBuilder();

    try {
        Class<?> classe = getClass(className);

        List<Field> tableFields = getAttribut(classe);

        List<Object[]> tableData = getDataFromTable(className);

        // Début du document HTML
        html.append("<!DOCTYPE html>\n")
            .append("<html lang='fr'>\n")
            .append("<head>\n")
            .append("  <meta charset='UTF-8'>\n")
            .append("  <meta name='viewport' content='width=device-width, initial-scale=1.0'>\n")
            .append("  <title>Tableau des données</title>\n")
            .append("  <link rel='stylesheet' href='style.css'>\n")
            .append("</head>\n")
            .append("<body>\n");

        // Sidebar HTML
        html.append("  <div class='sidebar'>\n")
            .append("    <div class='logo'>\n")
            .append("      <h2>GNote</h2>\n")
            .append("    </div>\n")
            .append("    <a href='index.html' class='menu-item'>\n")
            .append("      <i class='fas fa-home'></i>\n")
            .append("      <span>Accueil</span>\n")
            .append("    </a>\n")
            .append("    <a href='ajouter_etudiant.jsp' class='menu-item'>\n")
            .append("      <i class='fas fa-user-plus'></i>\n")
            .append("      <span>Ajouter étudiant</span>\n")
            .append("    </a>\n")
            .append("    <a href='liste_general.jsp' class='menu-item'>\n")
            .append("      <i class='fas fa-list'></i>\n")
            .append("      <span>Selection Reflect</span>\n")
            .append("    </a>\n")
            .append("    <a href='fiche.jsp' class='menu-item'>\n")
            .append("      <i class='fas fa-file-alt'></i>\n")
            .append("      <span>Relevé de Notes</span>\n")
            .append("    </a>\n")
            .append("    <div class='separator'></div>\n")
            .append("    <a href='liste_admis.jsp' class='menu-item'>\n")
            .append("      <i class='fas fa-check-circle'></i>\n")
            .append("      <span>Étudiants Admis</span>\n")
            .append("    </a>\n")
            .append("    <a href='listeEtudiant.jsp' class='menu-item'>\n")
            .append("      <i class='fas fa-check-circle'></i>\n")
            .append("      <span>Liste Etudiants</span>\n")
            .append("    </a>\n")
            .append("    <a href='liste_non_admis.jsp' class='menu-item'>\n")
            .append("      <i class='fas fa-times-circle'></i>\n")
            .append("      <span>Étudiants Non Admis</span>\n")
            .append("    </a>\n")
            .append("    <a href='liste_deliberation.jsp' class='menu-item'>\n")
            .append("      <i class='fas fa-gavel'></i>\n")
            .append("      <span>Délibération</span>\n")
            .append("    </a>\n")
            .append("    <div class='separator'></div>\n")
            .append("    <a href='modif_matieres.jsp' class='menu-item'>\n")
            .append("      <i class='fas fa-edit'></i>\n")
            .append("      <span>Modifier matières</span>\n")
            .append("    </a>\n")
            .append("    <a href='liste_admis_avant_delib.jsp' class='menu-item'>\n")
            .append("      <i class='fas fa-clock'></i>\n")
            .append("      <span>Admis avant délibération</span>\n")
            .append("    </a>\n")
            .append("    <a href='liste_admis_apres_delib.jsp' class='menu-item'>\n")
            .append("      <i class='fas fa-check-double'></i>\n")
            .append("      <span>Admis après délibération</span>\n")
            .append("    </a>\n")
            .append("  </div>\n");

        // Contenu principal
        html.append("<div class='main-content'>\n");
        html.append("<div class='container'>\n");
        html.append("<h1>Tableau des données : ").append(classe.getSimpleName()).append("</h1>\n");

        // Début du tableau HTML
        html.append("<table class='styled-table'>\n");

        // En-tête du tableau (noms des colonnes)
        html.append("  <thead>\n  <tr>\n");
        for (Field field : tableFields) {
            html.append("    <th>")
                .append(field.getName())
                .append("</th>\n");
        }
        html.append("  </tr>\n  </thead>\n");

        // Données du tableau
        html.append("  <tbody>\n");
        for (Object[] row : tableData) {
            html.append("  <tr>\n");
            for (Object cell : row) {
                html.append("    <td>")
                    .append(cell != null ? cell.toString() : "NULL")
                    .append("</td>\n");
            }
            html.append("  </tr>\n");
        }

        // Check numeric fields based on Java field types
        boolean[] isNumeric = new boolean[tableFields.size()];
        for (int i = 0; i < tableFields.size(); i++) {
            Class<?> fieldType = tableFields.get(i).getType();
            isNumeric[i] = (fieldType == int.class || 
                            fieldType == Integer.class || 
                            fieldType == long.class || 
                            fieldType == Long.class || 
                            fieldType == float.class || 
                            fieldType == Float.class || 
                            fieldType == double.class || 
                            fieldType == Double.class);
        }

        // Calculate sums and averages using the data and numeric field information
        double[] sommes = new double[tableFields.size()];
        double[] moyennes = new double[tableFields.size()];
        int[] counts = new int[tableFields.size()];

        // Calculate sums and count for numeric fields
        for (Object[] row : tableData) {
            for (int i = 0; i < row.length; i++) {
                if (isNumeric[i] && row[i] != null) {
                    if (row[i] instanceof Number) {
                        sommes[i] += ((Number) row[i]).doubleValue();
                        counts[i]++;
                    }
                }
            }
        }

        // Calculate averages
        for (int i = 0; i < sommes.length; i++) {
            if (counts[i] > 0) {
                moyennes[i] = sommes[i] / counts[i];
            }
        }

        // Add sum row
        html.append("  <tr class='summary-row'>\n");
        for (int i = 0; i < tableFields.size(); i++) {
            if (isNumeric[i]) {
                html.append("    <td><strong>")
                    .append(String.format("%.2f", sommes[i]))
                    .append("</strong></td>\n");
            } else {
                html.append("    <td></td>\n");
            }
        }
        html.append("  </tr>\n");

        // Add average row
        html.append("  <tr class='summary-row'>\n");
        for (int i = 0; i < tableFields.size(); i++) {
            if (isNumeric[i]) {
                html.append("    <td><strong>")
                    .append(String.format("%.2f", moyennes[i]))
                    .append("</strong></td>\n");
            } else {
                html.append("    <td></td>\n");
            }
        }
        html.append("  </tr>\n");

        html.append("  </tbody>\n");

        // Fin du tableau
        html.append("</table>\n");
        html.append("</div>\n");
        html.append("</div>\n");

        // Fin du document HTML
        html.append("</body>\n</html>");

    } catch (Exception e) {
        // Gestion des erreurs
        html.append("<!DOCTYPE html>\n")
            .append("<html lang='fr'>\n")
            .append("<head>\n")
            .append("  <meta charset='UTF-8'>\n")
            .append("  <meta name='viewport' content='width=device-width, initial-scale=1.0'>\n")
            .append("  <title>Erreur</title>\n")
            .append("  <link rel='stylesheet' href='style.css'>\n")
            .append("</head>\n")
            .append("<body>\n")
            .append("<div class='container'>\n")
            .append("<div class='error'>Erreur de génération : ")
            .append(e.getMessage())
            .append("</div>\n</div>\n")
            .append("</body>\n</html>");
    }

    return html.toString();
}

// public String genererHtmlInsert(String className){
//     StringBuilder html = new StringBuilder();

//     return html.toString();



// }

    // public Notes(String etu, String idMatiere,int idSemestre, double valeur,int annee) {
    //     this.etu = etu;
    //     this.idMatiere = idMatiere;
    //     this.idSemestre = idSemestre;
    //     this.valeur = valeur;
    // }


// public void insertData(String className, Object[]data)throws SQLException{
//     Class<?> classe = getClass(className);
//
//     try{
//
//     }
//     catch (SQLException e) {
//             throw new RuntimeException(e);
//     }
//
// }

}
