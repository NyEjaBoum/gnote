package gnote;

public class Notes {
    private int id;
    private String etu;         // Correspond au champ ETU dans la table
    private String idMatiere;   // Correspond au champ ID_MATIERE dans la table
    private int idSemestre;
    private double valeur;  
    private int annee;    // Correspond au champ VALEUR dans la table
    
    public Notes(String etu, String idMatiere,int idSemestre, double valeur,int annee) {
        this.etu = etu;
        this.idMatiere = idMatiere;
        this.idSemestre = idSemestre;
        this.valeur = valeur;
    }

    public String getEtu() {
        return etu;
    }

    public int getIdSemestre() {
        return idSemestre;
    }

    public void setIdSemestre(int idSemestre) {
        this.idSemestre = idSemestre;
    }

    public void setEtu(String etu) {
        this.etu = etu;
    }

    public String getIdMatiere() {
        return idMatiere;
    }

    public void setIdMatiere(String idMatiere) {
        this.idMatiere = idMatiere;
    }

    public double getValeur() {
        return valeur;
    }

    public void setValeur(double valeur) {
        this.valeur = valeur;
    }

}
