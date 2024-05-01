<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>
<%@ page import="com.ticket.catedrapoo2.beans.Ticket" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.ticket.catedrapoo2.beans.Bitacora" %>
<%--
  Created by IntelliJ IDEA.
  User: flore
  Date: 28/4/2024
  Time: 01:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Obtener la sesión actual
    HttpSession currentSession = request.getSession(false);
    UserSession user = (UserSession) currentSession.getAttribute("user");

    if (user == null || user.getRole_id() != 1) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Verificar si el parámetro "action" ya está presente en la URL
    String actionParam = request.getParameter("action");
    if (actionParam == null || !actionParam.equals("display_all_tickets")) {
        // Redirigir al servlet con el parámetro "action"
        request.getRequestDispatcher("/jdc?action=display_all_tickets").forward(request, response);
        return;
    }
%>

<html>
<head>
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="../assets/js/bootstrap.min.js"></script>
    <title>Jefe de Desarrollo - Supervisar</title>
</head>
<body>

<jsp:include page="../navbar.jsp"/>

<main class="container mt-3">
    <div>
        <h1>Bienvenido <%= user.getName() %>
        </h1>
        <p class="small"> Jefe de Desarrollo</p>
    </div>
    <div>
        <h3>Registro de casos aperturados</h3>
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
                    HashMap<String, Ticket> all_tickets = (HashMap<String, Ticket>) request.getAttribute("all_tickets");
                    if (all_tickets == null || all_tickets.isEmpty()) {
                %>
                <tr>
                    <td colspan="5">No hay registro casos aperturados</td>
                </tr>
                <%
                } else {
                    for (Ticket ticket : all_tickets.values()) {
                        // Convertir el HashMap a un array de objetos en JavaScript
                        StringBuilder logsArray = new StringBuilder("[");
                        for (Map.Entry<Integer, Bitacora> log : ticket.getLogs().entrySet()) {
                            logsArray.append("{")
                                    .append("\"id\": \"").append(log.getValue().getId()).append("\",")
                                    .append("\"code_ticket\": \"").append(log.getValue().getCode()).append("\",")
                                    .append("\"name\": \"").append(log.getValue().getName()).append("\",")
                                    .append("\"description\": \"").append(log.getValue().getDescription().replace("\r\n", "\\n")).append("\",")
                                    .append("\"percent\": \"").append(log.getValue().getPercent()).append("\",")
                                    .append("\"programmer_name\": \"").append(log.getValue().getProgrammer_name()).append("\",")
                                    .append("\"created_at\": \"").append(log.getValue().getCreated_at()).append("\"")
                                    .append("},");
                        }
                        if (logsArray.charAt(logsArray.length() - 1) == ',') {
                            logsArray.deleteCharAt(logsArray.length() - 1); // Eliminar la última coma
                        }
                        logsArray.append("]");
                        String description = ticket.getDescription().replace("\r\n", "\\n");
                        String observations = ticket.getObservations().replace("\r\n", "\\n");
                %>
                <tr>
                    <td><%= ticket.getCode() %>
                    </td>
                    <td><%= ticket.getBoss_name() %>
                    </td>
                    <td><%= ticket.getName() %>
                    </td>
                    <td><%= ticket.getCreated_at() %>
                    </td>
                    <td>
                        <button
                                class="btn btn-primary justify-content-center"
                                data-bs-toggle="modal"
                                data-bs-target="#ticketModal"
                                onclick='loadTicketInfo({
                                        id: <%= ticket.getId() %>,
                                        code: "<%= ticket.getCode() %>",
                                        state: "<%= ticket.getState() %>",
                                        title: "<%= ticket.getName() %>",
                                        description: "<%= description %>",
                                        logs: <%= logsArray.toString() %>,
                                        observations: "<%= observations %>",
                                        requester_name: "<%= ticket.getBoss_name() %>",
                                        requester_area_name: "<%= ticket.getRequester_area_name() %>",
                                        dev_boss_name: "<%= ticket.getDev_boss_name() %>",
                                        programmer_name: "<%= ticket.getProgrammer_name() %>",
                                        tester_name: "<%= ticket.getTester_name() %>",
                                        created_at: "<%= ticket.getCreated_at() %>",
                                        due_date: "<%= ticket.getDue_date() %>",
                                        })'
                        >
                            Ver detalles
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

<!-- Modal: Mostrar información del ticket -->
<div class="modal fade" id="ticketModal" tabindex="-1" aria-labelledby="ticketModalLabel" aria-hidden="true">
    <div class="modal-dialog" style="max-width: 800px;">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="ticketModalLabel">Detalles del caso</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">X</button>
            </div>
            <div class="modal-body" id="ticketModalBody">
                <!-- Aquí se mostrará la información del ticket -->
            </div>
        </div>
    </div>
</div>

<script>
    function loadTicketInfo(ticket) {
        console.log(ticket.logs)
        let logs;

        if (ticket.logs.length === 0) {
            logs = "<tr><td colspan='5'>No hay bitácoras registradas</td></tr>";
        } else {
            logs = ticket.logs.map(log => {
                return "<tr>" +
                    "<td>" + log.name + "</td>" +
                    "<td>" + log.description + "</td>" +
                    "<td>" + log.percent + "%</td>" +
                    "<td>" + log.programmer_name + "</td>" +
                    "<td>" + log.created_at + "</td>" +
                    "</tr>";
            }).join("");
        }
        // Construir el HTML con la información del ticket
        document.getElementById("ticketModalBody").innerHTML = "<form>" +
            "<div class='row g-2'>" +
            "<div class='form-group col-md-4'>" +
            "<label for='id'><strong>ID:</strong></label>" +
            "<input type='text' id='id' class='form-control' value='" + ticket.id + "' readonly>" +
            "</div>" +
            "<div class='form-group col-md-4'>" +
            "<label for='code'><strong>Código:</strong></label>" +
            "<input type='text' id='code' class='form-control' value='" + ticket.code + "' readonly>" +
            "</div>" +
            "<div class='form-group col-md-4'>" +
            "<label for='state'><strong>Estado:</strong></label>" +
            "<input type='text' id='state' class='form-control' value='" + ticket.state + "' readonly>" +
            "</div>" +
            "</div>" +
            "<div class='row g-2'>" +
            "<div class='form-group col-md-6'>" +
            "<label for='requester'><strong>Solicitante:</strong></label>" +
            "<input type='text' id='requester' class='form-control' value='" + ticket.requester_name + " (Depto de. " + ticket.requester_area_name + ")' readonly>" +
            "</div>" +
            "<div class='form-group col-md-6'>" +
            "<label for='tester'><strong>Probador:</strong></label>" +
            "<input type='text' id='tester' class='form-control' value='" + ticket.tester_name + "' readonly>" +
            "</div>" +
            "<div class='form-group col-md-6'>" +
            "<label for='programmer'><strong>Programador:</strong></label>" +
            "<input type='text' id='programmer' class='form-control' value='" + ticket.programmer_name + "' readonly>" +
            "</div>" +
            "<div class='form-group col-md-6'>" +
            "<label for='boss'><strong>Jefe de desarrollo:</strong></label>" +
            "<input type='text' id='boss' class='form-control' value='" + ticket.dev_boss_name + "' readonly>" +
            "</div>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label for='title'><strong>Título:</strong></label>" +
            "<input type='text' id='title' class='form-control' value='" + ticket.title + "' readonly>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label for='description'><strong>Descripción del caso:</strong></label>" +
            "<textarea id='description' class='form-control' rows='3' readonly>" + ticket.description + "</textarea>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label for='observations'><strong>Observaciones del jefe de desarrollo:</strong></label>" +
            "<textarea id='observations' class='form-control' rows='3' readonly>" + ticket.observations + "</textarea>" +
            "</div>" +
            "<div class='row g-2'>" +
            "<div class='form-group col-md'>" +
            "<label for='created_at'><strong>Fecha de solicitud:</strong></label>" +
            "<input type='text' id='created_at' class='form-control' value='" + ticket.created_at + "' readonly>" +
            "</div>" +
            "<div class='form-group col-md'>" +
            "<label for='due_date'><strong>Fecha de entrega:</strong></label>" +
            "<input type='text' id='due_date' class='form-control' value='" + ticket.due_date + "' readonly>" +
            "</div>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label for='logs'><strong>Bitácora:</strong></label>" +
            "<table class='table table-striped table-bordered text-center' id='logs'>" +
            "<thead>" +
            "<tr>" +
            "<th>Título</th>" +
            "<th>Descripción</th>" +
            "<th>Avance</th>" +
            "<th>Autor</th>" +
            "<th>Fecha creación</th>" +
            "</tr>" +
            "</thead>" +
            "<tbody>" +
            logs +
            "</tbody>" +
            "</table>" +
            "</div>" +
            "</form>" +
            "<div class='d-flex justify-content-center gap-2'>" +
            "<button type='button' class='btn btn-info' data-bs-dismiss='modal' aria-label='Close'>Regresar</button>" +
            "</div>";
    }
</script>
</body>
</html>
