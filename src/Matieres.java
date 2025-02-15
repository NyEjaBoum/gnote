package gnote;

public class Matieres {
    private String id;
    private int credit;
    private int idSemestre; // Correspond au champ ID_SEMESTRE dans la table
    private int optionnel;
    private int grpOption;
    private int useAverage;

    public Matieres(String id, int credit, int idSemestre,int option,int grpOption,int useAverage) {
        this.id = id;
        this.credit = credit;
        this.idSemestre = idSemestre;
        this.optionnel = option;
        this.grpOption = grpOption;
        this.useAverage = useAverage;
    }

    public String getId() {
        return id;
    }

    public int getUseAverage(){ // 1 == moyenne  0 max
        return useAverage;
    }

    public void setUseAverage(int check){
        this.useAverage = check;
    }

    public int getOptionnel() {
        return optionnel;
    }

    public int getGrpOption() {
        return grpOption;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getCredit() {
        return credit;
    }

    public void setCredit(int credit) {
        this.credit = credit;
    }

    public int getIdSemestre() {
        return idSemestre;
    }

    public void setIdSemestre(int idSemestre) {
        this.idSemestre = idSemestre;
    }

    public void setGrpOption(int grpOption) {
        this.grpOption = grpOption;
    }

    public void setOptionnel(int optionnel) {
        this.optionnel = optionnel;
    }
}
