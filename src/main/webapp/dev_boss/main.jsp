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
        request.getRequestDispatcher("/jdc?action=display_new_tickets").forward(request, response);
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
<nav class="navbar navbar-dark bg-dark navbar-expand-sm">
    <div class="container-fluid">
        <div class="navbar-nav me-auto">
            <a class="nav-link active" aria-current="page" href="#">Inicio</a>
            <a class="nav-link" href="#">Supervisar</a>
        </div>
        <div class="navbar-nav ms-auto">
            <a class="nav-link btn btn-danger text-white" href="../session_handler?operacion=logout">Cerrar sesión</a>
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
            <table class="table table-striped table-bordered text-center">
                <thead>
                    <tr>
                        <th>Código</th>
                        <th>Solicitante</th>
                        <th>Título</th>
                        <th>Acción</th>
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
                        <td>
                            <button
                                class="btn btn-primary justify-content-center"
                                data-bs-toggle="modal"
                                data-bs-target="#ticketModal"
                                onclick="loadTicketInfo({
                                    id: <%= ticket.getId() %>,
                                    code: '<%= ticket.getCode() %>',
                                    title: '<%= ticket.getName() %>',
                                    description: '<%= ticket.getDescription() %>',
                                    observations: null,
                                    requester_name: '<%= ticket.getBoss_name() %>',
                                    requester_area_name: '<%= ticket.getRequester_area_name() %>'
                                })"
                            >
                                Ver más
                            </button>
                        </td>
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

<!-- Modal -->
<div class="modal fade" id="ticketModal" tabindex="-1" aria-labelledby="ticketModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="ticketModalLabel">Detalles del Ticket</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">X</button>
            </div>
            <div class="modal-body" id="ticketModalBody">
                <!-- Aquí se mostrará la información del ticket -->
            </div>
        </div>
    </div>
</div>

</body>

<script>

    function loadTicketInfo(ticket) {
        // Construir el HTML con la información del ticket
        document.getElementById("ticketModalBody").innerHTML = "<h2 class='text-center'>Solicitud del caso " + ticket.code + "</h2><form>" +
            "<div class='form-group'>" +
            "<label for='code'><strong>ID:</strong></label>" +
            "<input type='text' id='code' class='form-control' value='" + ticket.id + "' readonly>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label for='title'><strong>Título:</strong></label>" +
            "<input type='text' id='title' class='form-control' value='" + ticket.title + "' readonly>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label for='description'><strong>Descripción:</strong></label>" +
            "<textarea id='description' class='form-control' rows='3' readonly>" + ticket.description + "</textarea>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label for='requester_name'><strong>Solicitante:</strong></label>" +
            "<input type='text' id='requester_name' class='form-control' value='" + ticket.requester_name + " (Depto de. " + ticket.requester_area_name + ")' readonly>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label for='observations'><strong>Observaciones:</strong></label>" +
            "<textarea id='observations' class='form-control' rows='3' placeholder='Escribe aquí tus observaciones...'></textarea>" +
            "</div>" +
            "</form>" +
            "<div class='d-flex justify-content-center gap-2'>" +
            "<button type='button' class='btn btn-success mr-2'>Aceptar</button>" +
            "<button type='button' class='btn btn-danger mr-2'>Rechazar</button>" +
            "<button type='button' class='btn btn-info' data-bs-dismiss='modal' aria-label='Close'>Salir</button>" +
            "</div>";
    }
</script>
</html>
