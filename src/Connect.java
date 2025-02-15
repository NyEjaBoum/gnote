package connexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.*;
import java.util.*;

public class Connect {

    public Connection con;
    public Connection con2;

    public Connection getConnectionOracle() {
        return this.con;
    }

    public Connection getConnectionMysql() {
        return this.con2;
    }

    public void connexion() {
        try {
            // Charger la classe de driver Oracle
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Format avec SERVICE_NAME
            con = DriverManager.getConnection("jdbc:oracle:thin:@//localhost:1521/XE", "note2", "note2");

            System.out.println("Connexion réussie à Oracle !");
        } catch (Exception e) {
            System.out.println("Erreur de connexion à Oracle : " + e);
        }
    }


    public void connexion2() {
        try {
            // Charger la classe de driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connexion à la base de données MySQL
            con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/note2", "root", "");

            System.out.println("Connexion réussie à MySQL !");
        } catch (Exception e) {
            System.out.println("Erreur de connexion à MySQL : " + e);
        }
    }

    public void deconnexion() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                con2.close();
                System.out.println("Connexion fermée.");
            }
        } catch (SQLException e) {
            System.out.println("Erreur lors de la fermeture de la connexion : " + e);
        }
    }

    public Statement getStatement(String tableName){
        Statement stmt = null;
        connectToBoth();
        List<String> mysql = getMySQLTables();
        List<String> oracle = getOracleTables();

        System.out.println("Tables MySQL : " + mysql);
        System.out.println("Tables Oracle : " + oracle);
        System.out.println("Recherche de la table : " + tableName);

        try {
            for (String s : mysql) {
                if (s.equalsIgnoreCase(tableName)) {
                    stmt = con2.createStatement();
                    System.out.println("Table trouvée dans MySQL");
                    return stmt;
                }
            }
            for (String o : oracle) {
                if (o.equalsIgnoreCase(tableName)) {
                    stmt = con.createStatement();
                    System.out.println("Table trouvée dans Oracle");
                    return stmt;
                }
            }

            System.out.println("Table non trouvée : " + tableName);
        } catch (Exception e) {
            System.out.println("Erreur lors de la recherche de la table : " + e.getMessage());
            e.printStackTrace();
        }

        return stmt;
    }

    public List<String> getMySQLTables() {
        List<String> tables = new ArrayList<>();
        Statement stmt = null;
        ResultSet rs = null;

        try {
            // Connexion MySQL
            connexion2();

            if (con2 != null) {
                DatabaseMetaData metaData = con2.getMetaData();
                rs = metaData.getTables("note2", null, "%", new String[]{"TABLE"});

                while (rs.next()) {
                    tables.add(rs.getString("TABLE_NAME"));
                }
            }
        } catch (SQLException e) {
            System.out.println("Erreur lors de la récupération des tables MySQL : " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                //deconnexion();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return tables;
    }

    /// ho anle select

    public List<String> getOracleTables() {
        List<String> tables = new ArrayList<>();
        Statement stmt = null;
        ResultSet rs = null;

        try {
            // Connexion Oracle
            connexion();

            if (con != null) {
                DatabaseMetaData metaData = con.getMetaData();
                String schema = con.getMetaData().getUserName().toUpperCase();
                rs = metaData.getTables(null, schema, "%", new String[]{"TABLE"});

                while (rs.next()) {
                    tables.add(rs.getString("TABLE_NAME"));
                }
            }
        } catch (SQLException e) {
            System.out.println("Erreur lors de la récupération des tables Oracle : " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                //deconnexion();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return tables;
    }

    public List<String> getAllTables() {
        List<String> allTables = new ArrayList<>();

        try {
            connectToBoth();

            List<String> mysqlTables = getMySQLTables();
            List<String> oracleTables = getOracleTables();

            allTables.addAll(mysqlTables);
            allTables.addAll(oracleTables);
        } finally {
            deconnexion();
        }

        return allTables;
    }

    public void displayAllTables() {
        List<String> allTables = getAllTables();

        System.out.println("Liste des tables disponibles :");
        if (allTables.isEmpty()) {
            System.out.println("Aucune table trouvée.");
        } else {
            for (String table : allTables) {
                System.out.println("- " + table);
            }
        }
    }



    public  void connectToBoth(){
        connexion();
        connexion2();
    }

}
