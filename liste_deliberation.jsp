<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="functions.*" %>
<%@ page import="connexion.*" %>
<%@ page import="gnote.*" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Étudiants pour Délibération</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Variables globales */
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --success-color: #4caf50;
            --error-color: #f44336;
            --background-color: #f5f5f5;
            --text-color: #333;
            --sidebar-bg: #2c3e50;
            --sidebar-hover: #34495e;
        }

        /* Reset et styles de base */
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

        /* Styles du Navbar */
        .sidebar {
            width: 280px;
            background: var(--sidebar-bg);
            padding: 20px 0;
            height: 100vh;
            position: fixed;
            left: 0;
            overflow-y: auto;
            transition: all 0.3s ease;
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

        .menu-item:hover {
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

        /* Contenu principal */
        .main-content {
            margin-left: 280px;
            flex: 1;
            width: calc(100% - 280px);
            padding: 20px;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        /* Styles du formulaire et tableau */
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
            font-size: 2rem;
        }

        .form-group {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            align-items: center;
            justify-content: center;
        }

        select {
            padding: 12px;
            border-radius: 6px;
            border: 1px solid #ddd;
            width: 250px;
            font-size: 1rem;
            background-color: white;
        }

        .btn-submit {
            padding: 12px 24px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1rem;
            font-weight: 500;
        }

        .btn-submit:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
        }

        /* Styles du tableau */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background-color: var(--primary-color);
            color: white;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.9rem;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        /* Style des liens de délibération */
        .delib-link {
            display: inline-block;
            padding: 8px 16px;
            background-color: var(--success-color);
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: all 0.3s ease;
        }

        .delib-link:hover {
            background-color: #45a049;
            transform: translateY(-2px);
        }

        .no-data {
            text-align: center;
            padding: 30px;
            color: #666;
            font-style: italic;
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
                width: calc(100% - 70px);
            }

            .logo h2 {
                font-size: 1.2rem;
            }

            .container {
                padding: 15px;
            }

            .form-group {
                flex-direction: column;
            }

            select, .btn-submit {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
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
        <a href="liste_general.jsp" class="menu-item">
            <i class="fas fa-list"></i>
            <span>Selection Reflect</span>
        </a>
        <a href="fiche.jsp" class="menu-item">
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
        <a href="liste_deliberation.jsp" class="menu-item active">
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
        <div class="container">
            <h1><i class="fas fa-gavel"></i> Liste des Étudiants pour Délibération</h1>
            
            <form method="post" class="form-group">
                <select name="semestre">
                    <option value="">Sélectionner un semestre</option>
                    <%
                    Connect con = new Connect();
                    con.connectToBoth();
                    Functions f = new Functions(con);
                    List<Semestre> semestres = f.getAllSemestres();
                    for(Semestre sem : semestres) {
                    %>
                        <option value="<%= sem.getId() %>">
                            <%= sem.getNom() %> - <%= sem.getParcours() %>
                        </option>
                    <% } %>
                </select>
            <label for="annee">Année scolaire :</label>
            <input type="number" id="annee" name="annee" min="2000" max="2100" placeholder="Année" required>

                <button type="submit" class="btn-submit">
                    <i class="fas fa-search"></i> Afficher les étudiants
                </button>
            </form>

            <% 
            String semestreParam = request.getParameter("semestre");
                String anneeStr = request.getParameter("annee");

            if(semestreParam != null && !semestreParam.isEmpty() && request.getMethod().equals("POST")) {
                int semestre = Integer.parseInt(semestreParam);
                            int annee = Integer.parseInt(anneeStr);

                List<Etudiant> etudiantsAdmis = f.getEtudiantsForDeliberation(semestre,annee);
            %>
                <table>
                    <thead>
                        <tr>
                            <th>N° Étudiant</th>
                            <th>Nom</th>
                            <th>Moyenne</th>
                            <th>Crédits</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(etudiantsAdmis != null && !etudiantsAdmis.isEmpty()) {
                            for(Etudiant etudiant : etudiantsAdmis) {
                                List<Notes> notesList = f.getNotesWithoutCredit(etudiant.getETU(), semestre,annee);
                                double moyenne = f.moyenneGeneraleSemestre(etudiant.getETU(), semestre, notesList);
                                int credits = f.getCreditTotalForSemester(etudiant.getETU(), semestre,annee);
                        %>
                            <tr>
                                <td><%= etudiant.getETU() %></td>
                                <td><%= etudiant.getNom() %></td>
                                <td><%= String.format("%.2f", moyenne) %></td>
                                <td><%= credits %></td>
                                <td>
                                    <a href="deliberation.jsp?etu=<%= etudiant.getETU() %>&semestre=<%= semestre %>&annee=<%= annee %>" 
                                       class="delib-link">
                                        <i class="fas fa-gavel"></i> Délibérer
                                    </a>
                                </td>
                            </tr>
                        <% 
                            }
                        } else { %>
                            <tr>
                                <td colspan="5" class="no-data">
                                    <i class="fas fa-info-circle"></i> 
                                    Aucun étudiant à délibérer pour ce semestre
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
            
            <% con.deconnexion(); %>
        </div>
    </div>
</body>
</html>