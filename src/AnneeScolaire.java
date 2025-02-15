package gecolage;

import java.time.LocalDate;

public class AnneeScolaire {
    private int id;
    private String nom;
    private LocalDate dateDebut; // Utilisation de LocalDate pour gérer les dates
    private LocalDate dateFin;
    public double montantDroit;

    public AnneeScolaire(int id,String nom,LocalDate debut,LocalDate fin,double montantDroit){
        this.id = id;
        this.nom = nom;
        this.dateDebut = debut;
        this.dateFin = fin;
        this.montantDroit = montantDroit;
    }

    // Getters et Setters
    public int getId() {
        return id;
    }

    public double getMontantDroit(){
        return montantDroit;
    }

    public void setMontantDroit(double ref) {
        this.montantDroit= ref;
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

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDate getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }
}
