package gecolage;

public class PayementEcolage {
    private int id;
    private String etu;
    private int idAnneeScolaire;
    private double montant;
    private double reste;

    public PayementEcolage(String etu,int idAnneeScolaire,double montant,double reste){
        this.etu = etu;
        this.idAnneeScolaire = idAnneeScolaire;
        this.montant = montant;
        this.reste = reste;
    }

    // Getters et Setters
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

    public void setIdAnneeScolaire(int idEcolage) {
        this.idAnneeScolaire = idEcolage;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }
}

