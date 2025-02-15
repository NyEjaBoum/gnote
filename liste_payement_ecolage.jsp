<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gecolage.GestionEcolage" %>
<%@ page import="gecolage.PayementEcolage" %>
<%@ page import="connexion.Connect" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Liste des Paiements Écolage</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* [Previous styles remain the same until .card] */
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
        .table-container {
            overflow-x: auto;
            margin-top: 2rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background-color: var(--primary-color);
            color: white;
            font-weight: 500;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .status {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .status.paid {
            background-color: rgba(76, 175, 80, 0.1);
            color: var(--success-color);
        }

        .status.pending {
            background-color: rgba(255, 152, 0, 0.1);
            color: #f57c00;
        }

        .payment-info {
            margin-top: 2rem;
            padding: 1rem;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .payment-info h3 {
            margin-bottom: 1rem;
            color: var(--primary-color);
        }

        .payment-stat {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
    <!-- [Sidebar remains the same] -->
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
            <div class="card">
                <h2><i class="fas fa-list"></i> Liste des Paiements Écolage</h2>

                <form method="GET" class="form-group">
                    <div class="form-group">
                        <label for="etu"><i class="fas fa-user"></i> Numéro Étudiant:</label>
                        <input type="text" id="etu" name="etu" value="${param.etu}" required>
                    </div>

                    <div class="form-group">
                        <label for="anneeScolaire"><i class="fas fa-calendar"></i> ID Année Scolaire:</label>
                        <input type="number" id="anneeScolaire" name="anneeScolaire" value="${param.anneeScolaire}" required>
                    </div>

                    <button type="submit" class="btn">
                        <i class="fas fa-search"></i> Rechercher
                    </button>
                </form>

                <%
                    String etu = request.getParameter("etu");
                    String anneeScolaireStr = request.getParameter("anneeScolaire");

                    if (etu != null && anneeScolaireStr != null) {
                        try {
                            Connect connect = new Connect();
                            connect.connectToBoth();
                            GestionEcolage gestionEcolage = new GestionEcolage(connect);
                            
                            int anneeScolaire = Integer.parseInt(anneeScolaireStr);
                            List<PayementEcolage> paiements = gestionEcolage.getPayementsByEtuAndAnnee(etu, anneeScolaire);
                            int nombreMoisPaye = gestionEcolage.nombreMoisPaye(etu, anneeScolaire);
                %>
                            <div class="payment-info">
                                <h3><i class="fas fa-info-circle"></i> Résumé des paiements</h3>
                                <div class="payment-stat">
                                    <span>Nombre de mois payés:</span>
                                    <strong><%= nombreMoisPaye %> / 12</strong>
                                </div>
                            </div>

                            <div class="table-container">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>ETU</th>
                                            <th>ID Écolage</th>
                                            <th>Montant</th>
                                            <th>Statut</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (PayementEcolage paiement : paiements) { %>
                                            <tr>
                                                <td><%= paiement.getEtu() %></td>
                                                <td><%= paiement.getIdAnneeScolaire() %></td>
                                                <td><%= String.format("%,.2f", paiement.getMontant()) %> Ar</td>
                                                <td>
                                                    <span class="status <%= paiement.getMontant() > 0 ? "paid" : "pending" %>">
                                                        <%= paiement.getMontant() > 0 ? "Payé" : "En attente" %>
                                                    </span>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                <%
                        } catch (Exception e) {
                %>
                            <div class="message error">
                                <i class="fas fa-exclamation-circle"></i> 
                                Erreur: <%= e.getMessage() %>
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