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
    <title>Délibération Étudiant</title>
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

        /* Contenu principal */
        .main-content {
            margin-left: 280px;
            flex: 1;
            width: calc(100% - 280px);
            padding: 20px;
        }

        /* Styles existants de la page de délibération */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        h1, h2 {
            color: #2c3e50;
            margin-bottom: 20px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        
        th {
            background-color: #3498db;
            color: white;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        select, input {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        button {
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        
        button:hover {
            background-color: #2980b9;
        }
        
        .notes-comparison {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .note-section {
            background-color: #fff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .note-header {
            background-color: #f8f9fa;
            padding: 10px;
            margin: -15px -15px 15px -15px;
            border-radius: 8px 8px 0 0;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .status-box {
            padding: 15px;
            margin: 20px 0;
            border-radius: 8px;
            text-align: center;
            font-size: 18px;
            font-weight: bold;
        }
        
        .status-pass {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .status-fail {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .status-details {
            margin-top: 10px;
            font-size: 14px;
            font-weight: normal;
            line-height: 1.5;
        }
        
        .error {
            color: red;
            margin-bottom: 10px;
            padding: 10px;
            background-color: #fee;
            border: 1px solid #fcc;
            border-radius: 4px;
        }
        
        .success {
            color: green;
            margin-bottom: 10px;
            padding: 10px;
            background-color: #efe;
            border: 1px solid #cfc;
            border-radius: 4px;
        }

        /* Design responsive */
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

            .notes-comparison {
                grid-template-columns: 1fr;
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
            <i class="fas fa-users"></i>
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
            <%
            Connect con = new Connect();
            con.connectToBoth();
            Functions f = new Functions(con);
            
            String etu = request.getParameter("etu");
            int semester = Integer.parseInt(request.getParameter("semestre"));
            int annee = Integer.parseInt(request.getParameter("annee"));
            
            // Récupérer les informations de l'étudiant
            Etudiant etudiant = f.getEtudiant(etu);
            
            // Vérifier si une délibération existe déjà
            boolean hasDeliberation = f.hasNotesInDeliberation(etu, semester,annee);
            
            // Récupérer les notes actuelles et historiques
            List<Notes> currentNotes = f.getNotesWithoutCredit(etu, semester,annee);
            List<Notes> historicalNotes = hasDeliberation ? 
                f.getNotesWithoutCreditAvantDeliberation(etu, semester,annee) : 
                null;
            
            double moyenne = f.moyenneGeneraleSemestre(etu, semester,currentNotes);
            boolean isPass = f.thisStudentPass(etu, semester,currentNotes,annee);
            
            // Calculer les détails pour le statut
            boolean hasNoteBelow6 = false;
            int nbMatiereInf10 = 0;
            boolean hasZero = false;
            
            for (Notes note : currentNotes) {
                if (note.getValeur() < 6) hasNoteBelow6 = true;
                if (note.getValeur() < 10) nbMatiereInf10++;
                if (note.getValeur() == 0) hasZero = true;
            }
            
            // Traitement du formulaire de délibération
            String error = null;
            String success = null;
            
            if ("POST".equals(request.getMethod())) {
                try {
                    String matiereOmena = request.getParameter("matiereOmena");
                    String matiereAngalana = request.getParameter("matiereAngalana");
                    double points = Double.parseDouble(request.getParameter("points"));
                    
                    f.deliberation(etu, semester,annee, matiereOmena, matiereAngalana, points);
                    success = "Délibération effectuée avec succès!";
                    response.sendRedirect(request.getRequestURI() + "?etu=" + etu + "&semestre=" + semester);
                } catch (Exception e) {
                    error = e.getMessage();
                }
            }
            %>
            
            <h1>Délibération - <%= etudiant.getNom() %> (<%=etu%>)</h1>
            
            <!-- Reste du contenu JSP identique à l'original -->
            <!-- Status box -->
            <div class="status-box <%= isPass ? "status-pass" : "status-fail" %>">
                <%= isPass ? "ADMIS" : "NON ADMIS" %>
                <div class="status-details">
                    Moyenne générale: <%= String.format("%.2f", moyenne) %>/20
                    <% if (!isPass) { %>
                        <br>Raison(s):
                        <% if (hasZero) { %>
                            <br>- Présence d'une note égale à 0
                        <% } %>
                        <% if (hasNoteBelow6) { %>
                            <br>- Présence d'une note inférieure à 6
                        <% } %>
                        <% if (nbMatiereInf10 >= 3) { %>
                            <br>- Plus de 2 matières en dessous de 10
                        <% } %>
                        <% if (moyenne < 10) { %>
                            <br>- Moyenne générale inférieure à 10
                        <% } %>
                    <% } %>
                </div>
            </div>

            <!-- Messages d'erreur et de succès -->
            <% if (error != null) { %>
                <div class="error"><%= error %></div>
            <% } %>
            <% if (success != null) { %>
                <div class="success"><%= success %></div>
            <% } %>

            <!-- Le reste du contenu JSP reste identique -->
            <!-- ... [Le reste du code JSP reste inchangé] ... -->
            <div class="notes-comparison">
            <% if (hasDeliberation && historicalNotes != null) { %>
                <!-- Notes avant délibération -->
                <div class="note-section">
                    <div class="note-header">Notes avant délibération</div>
                    <table>
                        <thead>
                            <tr>
                                <th>Matière</th>
                                <th>Note</th>
                                <th>Crédit</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            for (Notes note : historicalNotes) {
                                Matieres matiere = f.getMatiere(note.getIdMatiere());
                            %>
                            <tr>
                                <td><%= matiere.getId() %></td>
                                <td><%= String.format("%.2f", note.getValeur()) %></td>
                                <td><%= matiere.getCredit() %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
            
            <!-- Notes actuelles -->
            <div class="note-section">
                <div class="note-header"><%= hasDeliberation ? "Notes après délibération" : "Notes actuelles" %></div>
                <table>
                    <thead>
                        <tr>
                            <th>Matière</th>
                            <th>Note</th>
                            <th>Crédit</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        for (Notes note : currentNotes) {
                            Matieres matiere = f.getMatiere(note.getIdMatiere());
                        %>
                        <tr>
                            <td><%= matiere.getId() %></td>
                            <td><%= String.format("%.2f", note.getValeur()) %></td>
                            <td><%= matiere.getCredit() %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Matières à refaire -->
        <div class="note-section">
            <div class="note-header">Matières à refaire</div>
            <table>
                <thead>
                    <tr>
                        <th>Matière</th>
                        <th>Note</th>
                        <th>Crédit</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    List<Matieres> matieresAverina = f.getMatieresAverinaSemestre(etu, semester,annee);
                    for (Matieres matiere : matieresAverina) {
                        Object[] noteInfo = f.getNotesMatiere(etu, semester,annee, matiere.getId());
                    %>
                    <tr>
                        <td><%= matiere.getId() %></td>
                        <td><%= String.format("%.2f", (Double)noteInfo[1]) %></td>
                        <td><%= matiere.getCredit() %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <!-- Formulaire de délibération -->
        <h2>Formulaire de délibération</h2>
        <form method="post">
            <div class="form-group">
                <label for="matiereOmena">Matière à améliorer:</label>
                <select name="matiereOmena" required>
                    <option value="">Sélectionner une matière</option>
                    <% for (Matieres matiere : matieresAverina) { %>
                        <option value="<%= matiere.getId() %>"><%= matiere.getId() %></option>
                    <% } %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="matiereAngalana">Matière source des points:</label>
                <select name="matiereAngalana" required>
                    <option value="">Sélectionner une matière</option>
                    <% 
                    for (Notes note : currentNotes) {
                        Matieres matiere = f.getMatiere(note.getIdMatiere());
                        if (note.getValeur() >= 10) {
                    %>
                        <option value="<%= matiere.getId() %>"><%= matiere.getId() %> (<%= String.format("%.2f", note.getValeur()) %>)</option>
                    <% }} %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="points">Points à transférer:</label>
                <input type="number" name="points" step="0.01" required>
            </div>
            
            <button type="submit">Appliquer la délibération</button>
        </form>
        
        <% con.deconnexion(); %>
    </div>
            <% con.deconnexion(); %>
        </div>
    </div>
</body>
</html>