<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="functions.*" %>
<%@ page import="connexion.*" %>
<%@ page import="gnote.*" %>
<%@ page import="gecolage.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Relevé de Notes</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --success-color: #4caf50;
            --error-color: #f44336;
            --background-color: #f8f9fa;
            --text-color: #333;
            --sidebar-bg: #2c3e50;
            --sidebar-hover: #34495e;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background: var(--sidebar-bg);
            padding: 20px 0;
            height: 100vh;
            position: fixed;
            left: 0;
            overflow-y: auto;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .logo {
            text-align: center;
            padding: 20px;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--sidebar-hover);
        }

        .logo h2 {
            color: #ecf0f1;
            font-size: 1.8rem;
        }

        .menu-item {
            display: flex;
            align-items: center;
            padding: 15px 25px;
            color: #ecf0f1;
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
            margin-bottom: 5px;
        }

        .menu-item i {
            margin-right: 15px;
            width: 20px;
            text-align: center;
        }

        .menu-item:hover, .menu-item.active {
            background-color: var(--sidebar-hover);
            border-left-color: var(--primary-color);
            padding-left: 30px;
        }

        .separator {
            height: 1px;
            background-color: var(--sidebar-hover);
            margin: 15px 20px;
            opacity: 0.5;
        }

        /* Main Content Styles */
        .main-content {
            margin-left: 280px;
            flex: 1;
            padding: 2rem;
            position: relative;
        }

        h1 {
            margin-bottom: 2rem;
            color: var(--primary-color);
        }

        /* Form Styles */
        form {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        label {
            display: block;
            margin: 15px 0 8px;
            font-weight: 500;
            color: var(--text-color);
        }

        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        input[type="text"]:focus,
        input[type="number"]:focus,
        select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(67, 97, 238, 0.1);
        }

        input[type="submit"] {
            background: var(--primary-color);
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: background 0.3s ease;
        }

        input[type="submit"]:hover {
            background: var(--secondary-color);
        }

        /* Table Styles */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: var(--primary-color);
            color: white;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.9rem;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        /* Summary Styles */
        .summary {
            background-color: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-top: 30px;
        }

        .summary h2 {
            color: var(--primary-color);
            margin-bottom: 20px;
            font-size: 1.5rem;
        }

        .summary h3 {
            color: var(--text-color);
            margin: 20px 0 15px;
            font-size: 1.2rem;
        }

        .error {
            background-color: #ffebee;
            border-left: 4px solid var(--error-color);
            padding: 15px;
            margin-top: 20px;
            color: var(--error-color);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar {
                width: 70px;
            }

            .menu-item span {
                display: none;
            }

            .menu-item i {
                margin: 0;
            }

            .main-content {
                margin-left: 70px;
            }

            .logo h2 {
                font-size: 1.2rem;
            }

            table {
                display: block;
                overflow-x: auto;
            }
        }

        /* Print Styles */
        @media print {
            .sidebar {
                display: none;
            }

            .main-content {
                margin-left: 0;
                padding: 0;
            }

            form {
                display: none;
            }

            .summary {
                box-shadow: none;
                border: 1px solid #ddd;
            }
        }
    </style>
</head>
<body>
    <!-- Menu latéral -->
    <div class="sidebar">
        <div class="logo">
            <h2>GNote</h2>
        </div>
        <a href="index.html" class="menu-item">
            <i class="fas fa-home"></i>
            <span>Accueil</span>
        </a>
        <a href="ajouter_etudiant.jsp" class="menu-item">
            <i class="fas fa-user-plus"></i>
            <span>Ajouter étudiant</span>
        </a>
                <a href="insert_note.jsp" class="menu-item">
            <i class="fas fa-file"></i>
            <span>Inserer Note</span>
        </a>
        <a href="liste_general.jsp" class="menu-item">
            <i class="fas fa-list"></i>
            <span>Selection Reflect</span>
        </a>
        <a href="fiche.jsp" class="menu-item active">
            <i class="fas fa-file-alt"></i>
            <span>Relevé de Notes</span>
        </a>

        <div class="separator"></div>

        <a href="liste_admis.jsp" class="menu-item">
            <i class="fas fa-check-circle"></i>
            <span>Étudiants Admis</span>
        </a>
        <a href="listeEtudiant.jsp" class="menu-item">
            <i class="fas fa-check-circle"></i>
            <span>Liste Etudiants</span>
        </a>
        <a href="liste_non_admis.jsp" class="menu-item">
            <i class="fas fa-times-circle"></i>
            <span>Étudiants Non Admis</span>
        </a>
        <a href="liste_deliberation.jsp" class="menu-item">
            <i class="fas fa-gavel"></i>
            <span>Délibération</span>
        </a>

        <div class="separator"></div>

        <a href="modif_matieres.jsp" class="menu-item">
            <i class="fas fa-edit"></i>
            <span>Modifier matières</span>
        </a>
        <a href="liste_admis_avant_delib.jsp" class="menu-item">
            <i class="fas fa-clock"></i>
            <span>Admis avant délibération</span>
        </a>
        <a href="liste_admis_apres_delib.jsp" class="menu-item">
            <i class="fas fa-check-double"></i>
            <span>Admis après délibération</span>
        </a>
    </div>

    <!-- Contenu principal -->
    <div class="main-content">
        <h1>Relevé de Notes</h1>
        
        <% 
        Connect con = new Connect();
        try {
            con.connectToBoth();
            Functions f = new Functions(con);
            GestionE g = new GestionE(con);
            List<Semestre> semestres = f.getAllSemestres();
            List<AnneeScolaire> anneeScolaires = g.getAllAnneeScolaire();
        %>
        
        <form method="post">
            <label>Numéro Étudiant:</label>
            <input type="text" name="etudiant" required placeholder="Entrez le numéro étudiant">
            
            <label>Semestre:</label>
            <select name="semestre">
                <% for(Semestre sem : semestres) { %>
                    <option value="<%= sem.getId() %>">
                        <%= sem.getNom() %> - <%= sem.getParcours() %>
                    </option>
                <% } %>
            </select>
            <div class="form-group">
                <label for="idAnneeScolaire">
                       <i class="fas fa-calendar-alt"></i> Année Scolaire
                            </label>
                            <select id="idAnneeScolaire" name="idAnnee" required>
                                <option value="">Sélectionnez une année scolaire</option>
                                <%
                                if (anneeScolaires != null) {
                                    for (AnneeScolaire annee : anneeScolaires) {
                                %>
                                    <option value="<%= annee.getId() %>">
                                        <%= annee.getNom() %>
                                        (<%= annee.getDateDebut().getYear() %> - <%= annee.getDateFin().getYear() %>)
                                    </option>
                                <%
                                    }
                                }
                                %>
                </select>
            </div>
            <label for="annee">Année :</label>
            <input type="number" id="annee" name="annee" min="2000" max="2100" required>
            
            <input type="submit" value="Afficher Notes">
        </form>
        
        <% 
        String etu = request.getParameter("etudiant");
        String semestreParam = request.getParameter("semestre");
        String anneeStr = request.getParameter("annee");
        String anneeScolaire = request.getParameter("idAnnee");
        
        if (etu != null && semestreParam != null && anneeStr != null && anneeScolaire!=null) {
            int semestre = Integer.parseInt(semestreParam);
            int annee = Integer.parseInt(anneeStr);
            int idAnnee = Integer.parseInt(anneeScolaire);

            // Vérification du paiement de l'écolage
            if(g.checkEcolageSemestre(etu, idAnnee, semestre)) {
                try {
                    List<Notes> notesList = f.getNotesWithoutCredit(etu, semestre, annee);
                    List<Integer> credits = f.getCreditNotes2(etu, semestre, notesList, annee);
                    double moyenne = f.moyenneGeneraleSemestre(etu, semestre, notesList);
                    boolean admis = f.thisStudentPass(etu, semestre, notesList, annee);
                    int totalCredit = f.getCreditTotalForSemester(etu, semestre, annee);
        %>
                    <div class="summary">
                        <h2>Résultats pour l'étudiant <%= etu %> - Semestre <%= semestre %></h2>
                        
                        <h3>Notes</h3>
                        <table>
                            <tr>
                                <th>Code Matière</th>
                                <th>Note</th>
                                <th>Crédits</th>
                            </tr>
                            <% for(int i = 0; i < notesList.size(); i++) { %>
                                <tr>
                                    <td><%= notesList.get(i).getIdMatiere() %></td>
                                    <td><%= String.format("%.2f", notesList.get(i).getValeur()) %></td>
                                    <td><%= credits.get(i) %></td>
                                </tr>
                            <% } %>
                        </table>
                        
                        <h3>Statistiques</h3>
                        <p>Moyenne Générale: <%= String.format("%.2f", moyenne) %></p>
                        <p>Total Crédits: <%= totalCredit %></p>
                        <p>Statut: <strong style="color: <%= admis ? "var(--success-color)" : "var(--error-color)" %>">
                            <%= admis ? "Admis" : "Non Admis" %>
                        </strong></p>
                    </div>
        <%
                } catch (SQLException e) {
        %>
                    <div class="summary error">
                        <p>Erreur lors de la récupération des notes: <%= e.getMessage() %></p>
                    </div>
        <%
                }
            } else {
        %>
                <div class="summary error">
                    <p><i class="fas fa-exclamation-triangle"></i> 
                    Veuillez régler les frais de scolarité pour le semestre <%= semestre %> 
                    avant de consulter vos notes.</p>
                </div>
        <%
            }
        }
        } finally {
            if (con != null) {
                con.deconnexion();
            }
        }
        %>
    </div>
</body>
</html>