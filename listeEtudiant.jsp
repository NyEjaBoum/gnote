<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="functions.*" %>
<%@ page import="connexion.*" %>
<%@ page import="gnote.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vérification de Passage de Semestre</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --background-color: #f8f9fa;
            --sidebar-bg: #2c3e50;
            --sidebar-hover: #34495e;
            --table-header-bg: #4361ee;
            --table-row-hover: #f1f3f5;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: var(--background-color);
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

        .menu-item.active {
            background-color: var(--secondary-color);
            border-left-color: var(--primary-color);
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
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
        }

        select {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 2px solid var(--primary-color);
            border-radius: 8px;
        }

        .table-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        table thead {
            background-color: var(--table-header-bg);
            color: white;
        }

        table th, table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }

        table th {
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 0.5px;
        }

        table tbody tr:hover {
            background-color: var(--table-row-hover);
        }

        table tbody tr:last-child td {
            border-bottom: none;
        }

        .status-admis {
            color: #2ecc71;
            font-weight: bold;
        }

        .status-non-admis {
            color: #e74c3c;
            font-weight: bold;
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

    <div class="main-content">
        <div class="container">
            <h1>Vérification de Passage de Semestre</h1>
            <form method="post">
                <select name="semestre" onchange="this.form.submit()">
                    <option value="">Sélectionnez un semestre</option>
                    <%
                        Connect con = new Connect();
                            con.connectToBoth();
                        Functions f = new Functions(con);
                        List<Semestre> semestres = f.getAllSemestres();
                        for(Semestre sem : semestres) {
                    %>
                        <option value="<%= sem.getId() %>" 
                            <%= request.getParameter("semestre") != null && request.getParameter("semestre").equals(String.valueOf(sem.getId())) ? "selected" : "" %>>
                            <%= sem.getNom() %> - <%= sem.getParcours() %>
                        </option>
                    <% } %>
                </select>
            </form>

            <%
                String selectedSemestre = request.getParameter("semestre");
                if(selectedSemestre != null && !selectedSemestre.isEmpty()) {
                    try {
                        int semesterId = Integer.parseInt(selectedSemestre);
                        List<Etudiant> etudiants = f.getEtudiantForSemestre(semesterId);
            %>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Numéro ETU</th>
                                    <th>Nom</th>
                                    <th>Statut</th>
                                    <th>Moyenne</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Etudiant etudiant : etudiants) { 
                                    List<Notes> notes = f.getNotesWithoutCredit(etudiant.getETU(), semesterId);
                                    boolean passed = f.thisStudentPass(etudiant.getETU(), semesterId, notes);
                                    double moyenne = f.moyenneGeneraleSemestre(etudiant.getETU(),semesterId,notes);
                                %>
                                    <tr>
                                        <td><%= etudiant.getETU() %></td>
                                        <td><%= etudiant.getNom() %></td>
                                        <td class="<%= passed ? "status-admis" : "status-non-admis" %>">
                                            <%= passed ? "Admis" : "Non Admis" %>
                                        </td>
                                        <td><%= moyenne %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
            <%
                    } catch(SQLException e) {
                        out.println("<p>Erreur : " + e.getMessage() + "</p>");
                    }
                }
            %>
        </div>
    </div>
</body>
</html>