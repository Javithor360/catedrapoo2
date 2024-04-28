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
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Objects" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="listNames" class="com.ticket.catedrapoo2.beans.JefeDesarrolloBean" scope="session" />

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

    // Verificar si hay un mensaje en la URL
    if (request.getParameter("info") != null) {
        if(Objects.equals(request.getParameter("info"), "success_accept_ticket")) {
            request.setAttribute("info", "El ticket ha sido aceptado correctamente...");
        } else if(Objects.equals(request.getParameter("info"), "success_deny_ticket")) {
            request.setAttribute("info", "El ticket ha sido rechazado correctamente...");
        } else if(Objects.equals(request.getParameter("info"), "error_accept_ticket")) {
            request.setAttribute("info", "Ha ocurrido un error al aceptar el ticket...");
        } else if(Objects.equals(request.getParameter("info"), "error_denny_ticket")) {
            request.setAttribute("info", "Ha ocurrido un error al rechazar el ticket...");

        }
    }
%>

<html>
<head>
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="../assets/js/bootstrap.min.js"></script>
    <title>Jefe de Desarrollo - Main</title>
</head>
<body>
<nav class="navbar navbar-dark bg-dark navbar-expand-sm">
    <div class="container-fluid">
        <div class="navbar-nav me-auto">
            <a class="nav-link active" aria-current="page" href="#">Inicio</a>
            <a class="nav-link" href="supervise.jsp">Supervisar</a>
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
                        <th>Fecha de solicitud</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    HashMap<String, Ticket> new_tickets = (HashMap<String, Ticket>) request.getAttribute("new_tickets");
                    if(new_tickets == null || new_tickets.isEmpty()) {
                %>
                    <tr>
                        <td colspan="5" class="text-center">Por el momento no hay tickets solicitados...</td>
                    </tr>
                <%
                    } else {
                        for(Ticket ticket : new_tickets.values()) {
                %>
                    <tr>
                        <td><%= ticket.getCode() %></td>
                        <td><%= ticket.getBoss_name() %></td>
                        <td><%= ticket.getName() %></td>
                        <td><%= ticket.getCreated_at() %></td>
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
        <%
            if(request.getParameter("info") != null) {
        %>
        <div class="alert mt-5 <%= request.getParameter("info").startsWith("error") ? "alert-danger" : "alert-success" %>"
        role="alert">
            <%= request.getAttribute("info") %>
        </div>
        <%
            }
        %>
    </div>
</main>

<!-- Modal: Mostrar información del ticket -->
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

<div class="modal fade" id="acceptTicketModal" tabindex="-1" aria-labelledby="ticketModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="acceptTicketModalLabel">Confirmación de seguimiento de caso</h5>
            </div>
            <div class="modal-body" id="acceptTicketModalBody">
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
            "<button type='button' class='btn btn-success mr-2' data-bs-toggle='modal' data-bs-target='#acceptTicketModal' onclick='validateObservations(" + JSON.stringify(ticket) + ", 10, \"accept\")'>Aceptar</button>" +
            "<button type='button' class='btn btn-danger mr-2' data-bs-toggle='modal' data-bs-target='#acceptTicketModal' onclick='validateObservations(" + JSON.stringify(ticket) + ", 50, \"deny\")'>Rechazar</button>" +
            "<button type='button' class='btn btn-info' data-bs-dismiss='modal' aria-label='Close'>Salir</button>" +
            "</div>";
    }

    function loadConfirmTicket(ticket, type, observations) {
        let message;
        if (type === "invalid") {
            message = "<p>Por favor, detalla las observaciones antes de continuar...</p>" +
                "<div class='d-flex justify-content-center'>" +
                "<button type='button' class='btn btn-secondary' data-bs-dismiss='modal' aria-label='Close'>Cancelar</button>" +
                "</div>";
        } else if (type === "accept") {
            message = "<p>Completa la siguiente información para poder aceptar el caso</p><form action='/jdc' method='post'>" +
                "<div class='form-group'>" +
                "<label for='programmer'><strong>Programador asignado:</strong></label>" +
                "<select class='form-control form-select' id='programmer' name='programmer'>";

            <%
                try {
                    for (Map.Entry<Integer, String> programmer : listNames.fetchProgramerListNames(user.getId(), 1).entrySet()) {
            %>
            message += "<option value='<%= programmer.getKey() %>'><%= programmer.getValue() %></option>";
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>

            message += "</select>" +
                "</div>" +
                "<div class='form-group'>" +
                "<label for='tester'><strong>Programador asignado:</strong></label>" +
                "<select class='form-control form-select' id='tester' name='tester'>";
            <%
                try {
                    for (Map.Entry<Integer, String> tester : listNames.fetchTestersListNames(user.getId(), 1).entrySet()) {
            %>
            message += "<option value='<%= tester.getKey() %>'><%= tester.getValue() %></option>";
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
            message += "</select>" +
                "</div>" +
                "<div class='form-group'>" +
                "<label for='observations'><strong>Observaciones:</strong></label>" +
                "<textarea id='observations' name='observations' class='form-control' rows='3' readonly>" + observations + "</textarea>" +
                "</div>" +
                "<div class='form-group'>" +
                "<label for='due_date'><strong>Fecha de entrega:</strong></label>" +
                "<input type='date' id='due_date' name='due_date' class='form-control' />" +
                "</div>" +
                "<div class='d-flex justify-content-center gap-2'>" +
                "<input type='hidden' name='id' value='" + ticket.id + "' /> " +
                "<input type='hidden' name='action' value='accept_ticket' /> " +
                "<button type='submit' class='btn btn-success mr-2'>Aceptar</button>" +
                "<button type='button' class='btn btn-secondary mr-2' data-bs-dismiss='modal' aria-label='Close'>Cancelar</button>" +
                "</div>" +
                "</form>";
        } else {
            message = "<p>¿Estás seguro que deseas rechazar este caso?</p>" +
                "<div class='d-flex justify-content-center gap-2'>" +
                "<a class='btn btn-danger mr-2 text-white' href='/jdc?action=deny_ticket&id=" + ticket.id + "&observations=" + observations + "'>Confirmar</a>" +
                "<button type='button' class='btn btn-secondary mr-2' data-bs-dismiss='modal' aria-label='Close'>Cancelar</button>" +
                "</div>";
        }

        document.getElementById("acceptTicketModalBody").innerHTML = message;
    }

    function validateObservations(ticket, length, type) {
        let observations = document.getElementById("observations").value;
        if (observations.length >= length) {
            message = "<p>¿Estás seguro que deseas " + (type === "accept" ? "aceptar" : "rechazar") + " este caso?</p>" +
                "<div class='d-flex justify-content-center gap-2'>" +
                "<a " +
                "class='btn " + (type === "accept" ? "btn-success" : "btn-danger") + " mr-2 text-white' " +
                "href='/jdc?action=" + (type === "accept" ? "accept_ticket" : "denny_ticket") + "'" +
                ">" +
                (type === "accept" ? "Confirmar" : "Rechazar") +
                "</a>" +
                "<button type='button' class='btn btn-secondary mr-2' data-bs-dismiss='modal' aria-label='Close'>Cancelar</button>" +
                "</div>";
            loadConfirmTicket(ticket, type, observations);
        } else {
            loadConfirmTicket(null, "invalid", null);
        }
    }
</script>
</html>
