<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="connexion.*" %>
<%@ page import="gnote.*" %>
<%@ page import="gecolage.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Paiement Droit d'Inscription</title>
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
        }

        .menu-item i {
            margin-right: 15px;
        }

        .menu-item:hover {
            background-color: var(--sidebar-hover);
            border-left-color: var(--primary-color);
        }

        .main-content {
            margin-left: 280px;
            flex: 1;
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

        input:focus, select:focus {
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
    </style>
</head>
<body>
    <!-- Sidebar -->
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
        <a href="insert_ecolage.jsp" class="menu-item">
            <i class="fas fa-money-bill"></i>
            <span>Inserer Écolage</span>
        </a>
        <a href="fiche.jsp" class="menu-item">
            <i class="fas fa-file-alt"></i>
            <span>Relevé de Notes</span>
        </a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <%
                Connect connect = new Connect();
                connect.connectToBoth();
                GestionE g = new GestionE(connect);

                String etu = request.getParameter("etu");
                String idAnneeScolaireStr = request.getParameter("idAnneeScolaire");
                String montantStr = request.getParameter("montant");

                if (etu != null && idAnneeScolaireStr != null && montantStr != null) {
                    try {
                        int idAnneeScolaire = Integer.parseInt(idAnneeScolaireStr);
                        double montant = Double.parseDouble(montantStr);
                        
                        g.insertDroitInscription(etu, idAnneeScolaire, montant);
                        out.println("<div class='message success'><i class='fas fa-check-circle'></i> Paiement du droit d'inscription enregistré avec succès!</div>");
                    } catch (NumberFormatException e) {
                        out.println("<div class='message error'><i class='fas fa-exclamation-circle'></i> Erreur : Veuillez vérifier les valeurs numériques</div>");
                    } catch (Exception e) {
                        out.println("<div class='message error'><i class='fas fa-exclamation-circle'></i> Erreur : " + e.getMessage() + "</div>");
                    }
                }
            %>

            <div class="card">
                <h1><i class="fas fa-money-check-alt"></i> Paiement Droit d'Inscription</h1>
                <form method="POST">
                    <div class="form-group">
                        <label for="etu">
                            <i class="fas fa-user"></i> Numéro ETU
                        </label>
                        <input type="text" 
                               id="etu" 
                               name="etu" 
                               required 
                               placeholder="Ex: ETU002145">
                    </div>

                    <div class="form-group">
                        <label for="idAnneeScolaire">
                            <i class="fas fa-calendar-alt"></i> Année Scolaire
                        </label>
                        <select id="idAnneeScolaire" name="idAnneeScolaire" required>
                            <option value="">Sélectionnez une année scolaire</option>
                            <%
                                try {
                                    Statement stmt = connect.getConnectionMysql().createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT ID, NOM FROM ANNEESCOLAIRE ORDER BY DATE_DEBUT DESC");
                                    while(rs.next()) {
                                        out.println("<option value=\"" + rs.getInt("ID") + "\">" + rs.getString("NOM") + "</option>");
                                    }
                                } catch(SQLException e) {
                                    out.println("<option value=''>Erreur de chargement des années scolaires</option>");
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="montant">
                            <i class="fas fa-money-bill-wave"></i> Montant du Droit
                        </label>
                        <input type="number" 
                               id="montant" 
                               name="montant" 
                               required 
                               step="0.01" 
                               min="0"
                               placeholder="Ex: 50000">
                    </div>

                    <button type="submit" class="btn">
                        <i class="fas fa-save"></i> Enregistrer le Paiement
                    </button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>