package gecolage;

public class PayementDroit {
    private int id;                     
    private String etu;                 
    private int idAnneeScolaire;        
    private double droit;               

    public PayementDroit() {
    }

    public PayementDroit(int id, String etu, int idAnneeScolaire, double droit) {
        this.id = id;
        this.etu = etu;
        this.idAnneeScolaire = idAnneeScolaire;
        this.droit = droit;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEtu() {
        return etu;
    }

    public void setEtu(String etu) {
        this.etu = etu;
    }

    public int getIdAnneeScolaire() {
        return idAnneeScolaire;
    }

    public void setIdAnneeScolaire(int idAnneeScolaire) {
        this.idAnneeScolaire = idAnneeScolaire;
    }

    public double getDroit() {
        return droit;
    }

    public void setDroit(double droit) {
        this.droit = droit;
    }


}
