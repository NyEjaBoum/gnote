package gecolage;

public class ModePaiement {
    private int id;         // Identifiant unique pour le mode de paiement
    private String mode;    // Nom du mode de paiement (ex: "Trimestriel", "Annuel")

    // Constructeur par défaut
    public ModePaiement() {
    }

    // Constructeur avec paramètres
    public ModePaiement(int id, String mode) {
        this.id = id;
        this.mode = mode;
    }

    // Getter pour l'ID
    public int getId() {
        return id;
    }

    // Setter pour l'ID
    public void setId(int id) {
        this.id = id;
    }

    // Getter pour le mode
    public String getMode() {
        return mode;
    }

    // Setter pour le mode
    public void setMode(String mode) {
        this.mode = mode;
    }

    // Méthode toString pour afficher l'objet en texte
    @Override
    public String toString() {
        return "ModePaiement{" +
                "id=" + id +
                ", mode='" + mode + '\'' +
                '}';
    }
}
