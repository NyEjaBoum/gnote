package gecolage;

public class Ecolage {
    private int id;
    private int idAnneeScolaire;
    private double montantAnnuel;

    // Getters et Setters
    public int getId() {
        return id;
    }

    public Ecolage(int idAnneeScolaire,double montantAnnuel){
        this.idAnneeScolaire = idAnneeScolaire;
        this.montantAnnuel = Ecolage.this.montantAnnuel;
    }


    public void setId(int id) {
        this.id = id;
    }

    public int getIdAnneeScolaire() {
        return idAnneeScolaire;
    }

    public void setIdAnneeScolaire(int idAnneeScolaire) {
        this.idAnneeScolaire = idAnneeScolaire;
    }


    public double getValeur() {
        return montantAnnuel;
    }

    public void setValeur(double montantAnnuel) {
        this.montantAnnuel = Ecolage.this.montantAnnuel;
    }
}

