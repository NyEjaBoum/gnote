<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="functions.*" %>
<%@ page import="connexion.*" %>
<%@ page import="gnote.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Matières par Semestre</title>
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

        .main-content {
            margin-left: 280px;
            flex: 1;
            width: calc(100% - 280px);
        }

        .container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 20px;
        }

        .card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-top: 2rem;
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        h1 {
            color: var(--primary-color);
            text-align: center;
            font-size: 2.5rem;
            margin-bottom: 2rem;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            color: #555;
            font-weight: 500;
        }

        input[type="text"] {
            width: 100%;
            padding: 0.8rem;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        input[type="text"]:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        .btn {
            display: inline-block;
            background: var(--primary-color);
            color: white;
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
        }

        .btn:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
        }

        .message {
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
            animation: slideIn 0.5s ease;
        }

        .message.success {
            background-color: rgba(76, 175, 80, 0.1);
            color: var(--success-color);
            border: 1px solid var(--success-color);
        }

        .message.error {
            background-color: rgba(244, 67, 54, 0.1);
            color: var(--error-color);
            border: 1px solid var(--error-color);
        }

        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

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
                padding: 0 15px;
            }

            .card {
                padding: 1.5rem;
            }

            h1 {
                font-size: 2rem;
            }
        }
        /* Table Styles */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        table th, table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        table th {
            background-color: var(--primary-color);
            color: white;
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 1px;
        }

        table tr:last-child td {
            border-bottom: none;
        }

        table tr:hover {
            background-color: rgba(67, 97, 238, 0.05);
        }

        /* Form within table cell */
        table form {
            display: inline-block;
            margin-left: 10px;
        }

        table form input[type="submit"] {
            background: var(--secondary-color);
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.8rem;
            transition: background 0.3s ease;
        }

        table form input[type="submit"]:hover {
            background: var(--primary-color);
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="logo">
            <h2>GNote</h2>
        </div>
        <a href="index.html" class="menu-item">
            <i class="fas fa-home"></i>
            <span>Accueil</span>
        </a>
        <a href="ajouter_etudiant.jsp" class="menu-item active">
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

    <div class="main-content">

    <div class="container">
        <h2>Liste des Matières par Semestre</h2>

        <form method="post">
            <select name="semestre" onchange="this.form.submit()">
                <option value="">Sélectionnez un semestre</option>
                <%
                        Connect con = new Connect();
                        con.connexion();
                        Functions f = new Functions(con);
                        List<Semestre> semestres = f.getAllSemestres();
                    for(Semestre sem : semestres) {
                %>
                    <option value="<%= sem.getId() %>" <%= request.getParameter("semestre") != null && request.getParameter("semestre").equals(String.valueOf(sem.getId())) ? "selected" : "" %>>
                        <%= sem.getNom() %> - <%= sem.getParcours() %>
                    </option>
                <% } %>
            </select>
        </form>

        <%
            String selectedSemestre = request.getParameter("semestre");
            if(selectedSemestre != null && !selectedSemestre.isEmpty()) {
                try {
                    List<Matieres> matieres = f.getMatieresSemester(Integer.parseInt(selectedSemestre));
                    if(!matieres.isEmpty()) {
        %>
                        <table>
                            <tr>
                                <th>ID Matière</th>
                                <th>Crédits</th>
                                <th>Semestre</th>
                                <th>Optionnel</th>
                                <th>Groupe Option</th>
                                <th>Mode de calcul</th>
                            </tr>
                            <% for(Matieres matiere : matieres) { %>
                                <tr>
                                    <td><%= matiere.getId() %></td>
                                    <td><%= matiere.getCredit() %></td>
                                    <td><%= matiere.getIdSemestre() %></td>
                                    <td><%= matiere.getOptionnel() %></td>
                                    <td><%= matiere.getGrpOption() %></td>
                                    <td>
                                        <%= matiere.getUseAverage() == 1 ? "MOYENNE" : "MAX" %>
                                        <form method="post" style="display:inline;">
                                            <input type="hidden" name="semestre" value="<%= selectedSemestre %>">
                                            <input type="hidden" name="idMatiere" value="<%= matiere.getId() %>">
                                            <input type="submit" name="action" value="<%= matiere.getUseAverage() == 1 ? "Passer en MAX" : "Passer en MOYENNE" %>">
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </table>
        <%
                    } else {
                        out.println("<p>Aucune matière trouvée pour ce semestre.</p>");
                    }
                } catch(SQLException e) {
                    out.println("<p>Erreur : " + e.getMessage() + "</p>");
                }
            }

            // Traitement des modifications
            String idMatiere = request.getParameter("idMatiere");
            String action = request.getParameter("action");
            if(idMatiere != null && action != null) {
                if(action.equals("Passer en MAX")) {
                    f.setEnMax(idMatiere);
                } else if(action.equals("Passer en MOYENNE")) {
                    f.setEnMoyenne(idMatiere);
                }
                response.sendRedirect(request.getRequestURI() + "?semestre=" + selectedSemestre);
            }
        %>
    </div>
    </div>
</body>
</html>