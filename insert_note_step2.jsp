<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="connexion.*" %>
<%@ page import="gnote.*" %>
<%@ page import="gecolage.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Paiement Écolage</title>
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

        .message {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
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
        <a href="insert_note.jsp" class="menu-item">
            <i class="fas fa-file"></i>
            <span>Inserer Note</span>
        </a>
        <a href="insert_annee_scolaire.jsp" class="menu-item">
            <i class="fas fa-calendar"></i>
            <span>Inserer Annee Scolaire</span>
        </a>
        <a href="insertModePaiementE.jsp" class="menu-item">
            <i class="fas fa-money-bill"></i>
            <span>Inserer Mode Paiement Etudiant</span>
        </a>
        <a href="insert_ecolage.jsp" class="menu-item">
            <i class="fas fa-file-invoice-dollar"></i>
            <span>Inserer Ecolage</span>
        </a>
        <a href="payement_ecolage.jsp" class="menu-item">
            <i class="fas fa-cash-register"></i>
            <span>Payement Ecolage</span>
        </a>
        <div class="separator"></div>
        <a href="liste_general.jsp" class="menu-item">
            <i class="fas fa-list"></i>
            <span>Selection Reflect</span>
        </a>
        <a href="fiche.jsp" class="menu-item">
            <i class="fas fa-file-alt"></i>
            <span>Relevé de Notes</span>
        </a>
    </div>

    <!-- Contenu principal -->
    <div class="main-content">
        <div class="container">
            <%
                // Connexion à la base de données
                Connect connect = new Connect();
                connect.connectToBoth();
                Functions f = new Functions(connect);
                GestionE g = new GestionE(connect);

                // Paramètres reçus
                String etu = request.getParameter("etu");
                String semestreStr = request.getParameter("semestre");
                String anneeStr = request.getParameter("annee");
                String idAnnee = request.getParameter("idAnnee");
                String datePayementStr = request.getParameter("datePayement");

                // Notes soumises
                String[] selectedMatieres = request.getParameterValues("matieres");
                String[] noteValues = request.getParameterValues("notes");

                if (selectedMatieres != null && noteValues != null && idAnnee != null && datePayementStr != null) {
                    try {
                        int annee = Integer.parseInt(anneeStr);
                        int idAnneeScolaire = Integer.parseInt(idAnnee);

                        // Parse the date from the input
                        LocalDate datePayement = LocalDate.parse(datePayementStr);

                        if (!g.checkEcolageMois(etu, idAnneeScolaire, datePayement)) {
                            throw new Exception("L'étudiant " + etu + " n'a pas payé l'écolage pour ce mois.");
                        }

                        for (int i = 0; i < selectedMatieres.length; i++) {
                            double note = Double.parseDouble(noteValues[i]);
                            f.insertNotes(etu, Integer.parseInt(semestreStr), selectedMatieres[i], note, annee);
                        }
                        out.println("<div class='message success'><i class='fas fa-check-circle'></i> Notes insérées avec succès pour l'étudiant " + etu + ".</div>");
                    } catch (Exception e) {
                        out.println("<div class='message error'><i class='fas fa-exclamation-circle'></i> Erreur : " + e.getMessage() + "</div>");
                    }
                }

                // Récupérer les matières pour ce semestre
                List<Matieres> matieres = f.getMatieresSemester(Integer.parseInt(semestreStr));
            %>

            <div class="card">
                <form method="POST">
                    <h1><i class="fas fa-edit"></i> Saisie des Notes</h1>
                    <p class="text-center mb-4">
                        Étudiant: <strong><%= etu %></strong> |
                        Semestre: <strong><%= semestreStr %></strong> |
                        Année: <strong><%= anneeStr %></strong> |
                        ID Année: <strong><%= idAnnee %></strong> |
                        Date Payement: <strong><%= datePayementStr %></strong>
                    </p>

                    <div class="matieres-list">
                        <% for (Matieres matiere : matieres) { %>
                            <div class="matiere-item">
                                <div class="matiere-info">
                                    <i class="fas fa-book"></i>
                                    <%= matiere.getId() %>
                                    <%= matiere.getOptionnel() == 1 ? "<span class='badge'>(Optionnel)</span>" : "" %>
                                    <small>(Crédits: <%= matiere.getCredit() %>)</small>
                                </div>
                                <input type="hidden" name="matieres" value="<%= matiere.getId() %>">
                                <input type="number" name="notes" class="note-input" step="0.01" min="0" max="20" placeholder="Note" required>
                            </div>
                        <% } %>
                    </div>

                    <input type="hidden" name="datePayement" value="<%= datePayementStr %>">
                    <input type="hidden" name="etu" value="<%= etu %>">
                    <input type="hidden" name="semestre" value="<%= semestreStr %>">
                    <input type="hidden" name="annee" value="<%= anneeStr %>">
                    <input type="hidden" name="idAnnee" value="<%= idAnnee %>">
                    <button type="submit" class="btn">
                        <i class="fas fa-save"></i> Enregistrer les Notes
                    </button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>