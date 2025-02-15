<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gecolage.*" %>
<%@ page import="connexion.Connect" %>
<%@ page import="java.util.List" %>
<%@ page import="gecolage.ModePaiement" %>

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

    <div class="main-content">
        <div class="container">
            <div class="card">
                <h2><i class="fas fa-money-bill-wave"></i> Formulaire de Paiement Écolage</h2>
                
                <%
                    Connect connect = null;
                    GestionE g = null;
                    List<AnneeScolaire> anneeScolaires = null;
                    
                    try {
                        connect = new Connect();
                        connect.connectToBoth();
                        
                        g = new GestionE(connect);
                        anneeScolaires = g.getAllAnneeScolaire();
                        
                    } catch(Exception e) {
                        e.printStackTrace();
                %>
                        <div class="message error">
                            <i class="fas fa-exclamation-circle"></i> 
                            Erreur de connexion à la base de données
                        </div>
                <%
                    }
                    
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        try {
                            String etu = request.getParameter("etu");
                            String anneeScolaireParam = request.getParameter("idAnneeScolaire");
                            String montantParam = request.getParameter("montant");

                            if (etu == null || etu.isEmpty()) {
                                throw new Exception("Numéro étudiant invalide");
                            }
                            if (anneeScolaireParam == null || anneeScolaireParam.isEmpty()) {
                                throw new Exception("Année scolaire non sélectionnée");
                            }
                            if (montantParam == null || montantParam.isEmpty()) {
                                throw new Exception("Montant non spécifié");
                            }

                            int anneeScolaire = Integer.parseInt(anneeScolaireParam);
                            double montant = Double.parseDouble(montantParam);

                            g.isAllPayed(etu, anneeScolaire);
                            if(g.nandoaDroit(etu,anneeScolaire)){
                                g.checkMontantInsert(etu, anneeScolaire, montant);
                            } else{
                                    response.sendRedirect("insert_droit.jsp");
                                throw new Exception("il a pas paye droit");
                            }

                            
                %>
                            <div class="message success">
                                <i class="fas fa-check-circle"></i> 
                                Paiement enregistré avec succès
                            </div>
                <%
                        } catch(Exception e) {
                %>
                            <div class="message error">
                                <i class="fas fa-exclamation-circle"></i> 
                                Erreur: <%= e.getMessage() %>
                            </div>
                <%
                        }
                    }
                %>

                <form method="POST" action="payement_ecolage.jsp">
                    <div class="form-group">
                        <label for="etu">
                            <i class="fas fa-user"></i> Numéro Étudiant
                        </label>
                        <input type="text" id="etu" name="etu" required 
                               pattern="[A-Za-z0-9]+" 
                               title="Veuillez entrer un numéro étudiant valide">
                    </div>

                    <div class="form-group">
                        <label for="idAnneeScolaire">
                            <i class="fas fa-calendar-alt"></i> Année Scolaire
                        </label>
                        <select id="idAnneeScolaire" name="idAnneeScolaire" required>
                            <option value="">Sélectionnez une année scolaire</option>
                            <% if (anneeScolaires != null) {
                                   for (AnneeScolaire annee : anneeScolaires) { %>
                                <option value="<%= annee.getId() %>">
                                    <%= annee.getNom() %> 
                                    (<%= annee.getDateDebut().getYear() %> - <%= annee.getDateFin().getYear() %>)
                                </option>
                            <% }
                               } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="montant">
                            <i class="fas fa-coins"></i> Montant
                        </label>
                        <input type="number" id="montant" name="montant" 
                               required min="0" step="0.01">
                    </div>

                    <button type="submit" class="btn">
                        <i class="fas fa-save"></i> Enregistrer le Paiement
                    </button>
                </form>

                <div class="separator"></div>

<div class="form-group">
    <h3>Reste à payer par année</h3>
    <div class="search-student" style="margin-bottom: 20px;">
        <label for="searchEtu">
            <i class="fas fa-search"></i> Numéro Étudiant
        </label>
        <div style="display: flex; gap: 10px;">
            <input 
                type="text" 
                id="searchEtu" 
                name="searchEtu" 
                pattern="[A-Za-z0-9]+" 
                title="Veuillez entrer un numéro étudiant valide"
                style="flex: 1;"
            >
            <button 
                onclick="updateBalance()" 
                class="btn" 
                style="width: auto; padding: 0.8rem 1.5rem;"
            >
                <i class="fas fa-search"></i> Rechercher
            </button>
        </div>
    </div>
    
    <div id="balanceResults">
        <% if (anneeScolaires != null) {
            String etuNumber = request.getParameter("searchEtu");
            if (etuNumber != null && !etuNumber.trim().isEmpty()) {
                for (AnneeScolaire annee : anneeScolaires) {
                    try { %>
                        <p>
                            Reste à payer de l'année <%= annee.getNom() %> : 
                            <%= g.getResteApayer(etuNumber, annee.getId()) %> Ar
                        </p>
                        <p> 
                            Montant minimal pouvant être inséré :
                            <%= g.getMontantAttendu(etuNumber, annee.getId()) %>
                        </p>
                    <%  } catch(Exception e) {
                            e.printStackTrace(); %>
                        <p class="message error">
                            Erreur de calcul pour l'année <%= annee.getNom() %>
                        </p>
                    <% }
                }
            } else { %>
                <p class="message">
                    <i class="fas fa-info-circle"></i> 
                    Veuillez saisir un numéro d'étudiant pour voir le reste à payer
                </p>
            <% }
        } %>
    </div>
</div>

<script>
function updateBalance() {
    const searchEtu = document.getElementById('searchEtu').value;
    if (searchEtu) {
        // Reload the page with the search parameter
        window.location.href = window.location.pathname + '?searchEtu=' + encodeURIComponent(searchEtu);
    }
}

// Add event listener for Enter key
document.getElementById('searchEtu').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        updateBalance();
    }
});
</script>
            </div>
        </div>
    </div>
</body>
</html>