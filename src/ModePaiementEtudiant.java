package gecolage;

public class ModePaiementEtudiant {
    public String etu;
    public int idModePayement;
    public int idAnneeScolaire;

    public ModePaiementEtudiant(String etu,int idModePayement,int idAnneeScolaire){
        this.etu = etu;
        this.idModePayement=idModePayement;
        this.idAnneeScolaire = idAnneeScolaire;
    }

    public int getIdModePayement() {
        return idModePayement;
    }

    public int getIdAnneeScolaire() {
        return idAnneeScolaire;
    }

    public String getEtu() {
        return etu;
    }

    public void setEtu(String etu) {
        this.etu = etu;
    }

    public void setIdModePayement(int idModePayement) {
        this.idModePayement = idModePayement;
    }

    public void setIdAnneeScolaire(int idAnneeScolaire) {
        this.idAnneeScolaire = idAnneeScolaire;
    }
}
