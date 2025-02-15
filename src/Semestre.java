package gnote;

public class Semestre {
    private int id;
    private String nom;
    private String parcours;

    public Semestre(int id, String nom,String parcours) {
        this.id = id;
        this.nom = nom;
        this.parcours = parcours;
    }

    public String getParcours() {
        return parcours;
    }

    public void setParcours(String parcours) {
        this.parcours = parcours;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}
