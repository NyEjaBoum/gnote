package gnote;

import java.sql.Date;

public class Etudiant {
    private String etu;
    private String nom;
    private Date dateEntree;
    
    public Etudiant (String ETU,String nom,Date entree){
        this.etu = ETU;
        this.nom = nom;
        this.dateEntree = entree;
    }

    public String getNom() {
        return nom;
    }

    public Date getDateEntree() {
        return dateEntree;
    }

    public void setDateEntree(Date dateEntree) {
        this.dateEntree = dateEntree;
    }

    public String getETU() {
        return etu;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public void setETU(String ETU) {
        this.etu = ETU;
    }



}
