<%@ page import="connexion.Connect" %>
<%@ page import="gnote.*" %>

<%

    Connect con = new Connect();
    con.connectToBoth();
    Reflect r = new Reflect(con);
    String html = r.genererHTML("gecolage.ModePaiementEtudiant");
    out.print(html);

%>