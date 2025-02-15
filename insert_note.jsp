<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="connexion.*" %>
<%@ page import="gecolage.*" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Insertion de Notes</title>
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

        /* Main Content Styles */
        .main-content {
            margin-left: 280px;
            flex: 1;
            width: calc(100% - 280px);
            padding: 2rem;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
        }

        .card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-top: 2rem;
        }

        /* Form Styles */
        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            color: #555;
            font-weight: 500;
        }

        input[type="text"],
        input[type="number"],
        input[type="date"],
        select {
            width: 100%;
            padding: 0.8rem;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        input:focus,
        select:focus {
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

        /* Messages Styles */
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

            .card {
                padding: 1.5rem;
            }
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

        /* Additional styles for matiere items */
        .matieres-list {
            margin-bottom: 1.5rem;
        }

        .matiere-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem;
            border-bottom: 1px solid #f0f0f0;
        }

        .matiere-info {
            flex-grow: 1;
            margin-right: 1rem;
        }

        .note-input {
            max-width: 100px;
        }

        .badge {
            background-color: #f0f0f0;
            color: #666;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-size: 0.8rem;
            margin-left: 0.5rem;
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
        <a href="liste_general.jsp" class="menu-item">
            <i class="fas fa-list"></i>
            <span>Selection Reflect</span>
        </a>
        <a href="insert_note.jsp" class="menu-item">
            <i class="fas fa-file"></i>
            <span>Inserer Note</span>
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
            <%
                // Connexion à la base de données
                Connect connect = new Connect();
                connect.connectToBoth();
                GestionE g = new GestionE(connect);
                List<AnneeScolaire> anneeScolaires = g.getAllAnneeScolaire();
            %>

            <div class="card">
                <form action="insert_note_step2.jsp" method="GET">
                    <h1><i class="fas fa-graduation-cap"></i> Sélectionner Étudiant, Semestre et Année</h1>

                    <div class="form-group">
                        <label for="etu"><i class="fas fa-user"></i> ETU de l'étudiant :</label>
                        <input type="text" id="etu" name="etu" placeholder="Numéro ETU" required>
                    </div>

                    <div class="form-group">
                        <label for="semestre"><i class="fas fa-calendar"></i> Numéro de semestre :</label>
                        <input type="number" id="semestre" name="semestre" min="1" placeholder="Semestre" required>
                    </div>

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

                    <div class="form-group">
                        <label for="annee"><i class="fas fa-calendar-alt"></i> Année scolaire :</label>
                        <input type="number" id="annee" name="annee" min="2000" max="2100" placeholder="Année" required>
                    </div>

                    <div class="form-group">
                        <label for="datePayement"><i class="fas fa-calendar"></i> Date de Payement :</label>
                        <input type="date" id="datePayement" name="datePayement" required>
                    </div>

                    <button type="submit" class="btn">
                        <i class="fas fa-arrow-right"></i> Suivant
                    </button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>