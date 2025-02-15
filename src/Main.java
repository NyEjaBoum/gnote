package aff;
//import gecolage.GestionEcolage;
import gecolage.*;
import gnote.*;
import connexion.*;
import gnote.Reflect;
import java.lang.reflect.*;
import java.sql.SQLException;
import java.time.LocalDate;

public class Main {
    public static void main(String[] args) throws Exception {
        System.out.println("Bonjour");
        Connect con = new Connect();
        con.connectToBoth();
        Reflect r = new Reflect(con);
        Functions f = new Functions(con);
        //System.out.println(f.getMatieresSemester(1).get(0).getId());
        con.displayAllTables();
        //System.out.println(con.getStatement("Etudiant"));
        r.displayData(r.getDataFromTable("gnote.Matieres"));

        GestionE g = new GestionE(con);
        LocalDate dateDebut = LocalDate.of(2022, 9, 9);
        LocalDate dateFin = LocalDate.of(2023, 8, 31);

        //g.insertAnneeScolaire("2022-2023",dateDebut,dateFin);
        //g.insertEcolage(5,3300000);
        //System.out.println(g.getNombreMoisAnneeScolaire(2));

        //g.insert("3383",1,3300000);
         //System.out.println(g.getNombreMoisPaye("3383",6));
        //System.out.println(g.checkEcolageSemestre("3383",7,3));
        System.out.println("pas annee "+ g.getMontantAttendu("3383",7));
        System.out.println("annee "+ g.getMontantAttenduForReste("3383",7));
        //System.out.println("annee "+ g.checkEcolageSemestre("3383",1,3));
       // System.out.println(g.getAllAnneeScolaire().get(0).getNom());
        System.out.println("reste " + g.getResteApayer("3383",7));
        System.out.println("montant a inserer " + g.montantAInserer("3383",7));


    }
}