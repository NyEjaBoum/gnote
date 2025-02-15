<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="connexion.*" %>
<%@ page import="gnote.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gestion des Étudiants</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --success-color: #4caf50;
            --error-color: #f44336;
            --background-color: #f8f9fa;
            --text-color: #333;
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

        /* Responsive Design */
        @media (max-width: 768px) {
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
                
                /* navbar */
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

        /* Styles existants */
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

        /* Styles du menu latéral */
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

        /* Modification du conteneur principal pour s'adapter au menu */
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

        /* Styles existants inchangés */
        .card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-top: 2rem;
            transition: transform 0.3s ease;
        }

        /* ... Reste des styles existants ... */

        /* Responsive Design mis à jour */
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

    <!-- Contenu principal -->
    <div class="main-content">
        <div class="container">
            <h1><i class="fas fa-user-graduate"></i> Gestion des Étudiants</h1>
            
            <div class="card">
                <form method="POST">
                    <div class="form-group">
                        <label for="etu">
                            <i class="fas fa-id-card"></i> Numéro ETU
                        </label>
                        <input type="text" id="etu" name="etu" placeholder="Entrez le numéro ETU" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="nom">
                            <i class="fas fa-user"></i> Nom de l'étudiant
                        </label>
                        <input type="text" id="nom" name="nom" placeholder="Entrez le nom complet" required>
                    </div>

                    <div class="form-group">
                        <label for="date">
                            <i class="fas fa-user"></i> Date d'entree
                        </label>
                        <input type="date" id="date" name="date" placeholder="Entrez la date" required>
                    </div>
                    
                    <button type="submit" class="btn">
                        <i class="fas fa-plus-circle"></i> Ajouter l'étudiant
                    </button>
                </form>

<%
    String etu = request.getParameter("etu");
    String nom = request.getParameter("nom");
    String dateParam = request.getParameter("date");
    java.sql.Date date = null;

    if (dateParam != null && !dateParam.isEmpty()) {
        try {
            date = java.sql.Date.valueOf(dateParam); // Format attendu: "YYYY-MM-DD"
        } catch (IllegalArgumentException e) {
            out.println("<div class='message error'>Format de date invalide : " + dateParam + "</div>");
        }
    }

    if (request.getMethod().equals("POST")) {
        if (etu != null && !etu.isEmpty() && nom != null && !nom.isEmpty() && date != null) {
            Connect connect = new Connect();
            connect.connectToBoth();
            Functions f = new Functions(connect);

            try {
                f.addEtudiant(etu, nom, date);
                %>
                <div class="message success">
                    <i class="fas fa-check-circle"></i> L'étudiant a été ajouté avec succès!
                </div>
                <%
            } catch (Exception e) {
                %>
                <div class="message error">
                    <i class="fas fa-exclamation-circle"></i> Erreur: <%= e.getMessage() %>
                </div>
                <%
            }
        } else {
            %>
            <div class="message error">
                <i class="fas fa-exclamation-circle"></i> Veuillez remplir tous les champs correctement!
            </div>
            <%
        }
    }
%>

            </div>
        </div>
    </div>
</body>
</html>