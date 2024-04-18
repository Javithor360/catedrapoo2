<%--
  Created by IntelliJ IDEA.
  User: flore
  Date: 10/4/2024
  Time: 00:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>
<%@ page import="com.ticket.catedrapoo2.beans.Ticket" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Obtener la sesión actual
    HttpSession currentSession = request.getSession(false);
    UserSession user = (UserSession) currentSession.getAttribute("user");

    if(user == null || user.getRole_id() != 1) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Verificar si el parámetro "action" ya está presente en la URL
    String actionParam = request.getParameter("action");
    if (actionParam == null || !actionParam.equals("display_new_tickets")) {
        // Redirigir al servlet con el parámetro "action"
        response.sendRedirect("/jdc?action=display_new_tickets");
        return;
    }
%>

<html>
<head>
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="../assets/js/bootstrap.min.js"></script>
    <title>Title</title>
</head>
<body>
<nav class="navbar navbar-light bg-light navbar-expand-sm">
    <div class="container-fluid">
        <div class="navbar-nav me-auto">
            <a class="nav-link active" aria-current="page" href="#">Inicio</a>
            <a class="nav-link" href="#">Supervisar</a>
        </div>
        <div class="navbar-nav ms-auto">
            <a class="nav-link text-white bg-danger p-2 rounded" href="../session_handler?operacion=logout">Cerrar sesión</a>
        </div>
    </div>
</nav>
<main class="container mt-3">
    <div>
        <h1>Bienvenido <%= user.getName() %></h1>
        <p class="small"> Jefe de Desarrollo</p>
    </div>
    <div>
        <h3>Casos aperturados recientemente</h3>
        <div class="table-container">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th>Código</th>
                        <th>Solicitante</th>
                        <th>Título</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    HashMap<String, Ticket> new_tickets = (HashMap<String, Ticket>) request.getAttribute("new_tickets");
                    if(new_tickets == null) {
                %>
                    <tr>
                        <td colspan="3" class="text-center">Por el momento no hay tickets solicitados...</td>
                    </tr>
                <%
                    } else {
                        for(Ticket ticket : new_tickets.values()) {
                %>
                    <tr>
                        <td><%= ticket.getId() %></td>
                        <td><%= ticket.getBoss_name() %></td>
                        <td><%= ticket.getName() %></td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</main>
</body>
</html>
