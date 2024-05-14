<%--
  Created by IntelliJ IDEA.
  User: flore
  Date: 10/4/2024
  Time: 00:30
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>
<%@ page import="com.ticket.catedrapoo2.beans.Ticket" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Verificar si el usuario tiene una sesión activa
    HttpSession currentSession = request.getSession(false);
    UserSession user = (UserSession) currentSession.getAttribute("user");

    // Si no hay sesión activa o el usuario no es un tester, redirigir al login
    if (user == null || user.getRole_id() != 3) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Verificar si el parámetro "action" ya está presente en la URL
    String actionParam = request.getParameter("action");
    if (actionParam == null || !actionParam.equals("display_tickets")) {
        // Redirigir al servlet con el parámetro "action"
        request.getRequestDispatcher("/rqc?action=display_tickets").forward(request, response);
        return;
    }

    // Mensajes de información recibidos de la petición
    if (request.getParameter("info") != null) {
        if (request.getParameter("info").equals("success_create_ticket")) {
            request.setAttribute("info", "El caso ha sido creado con éxito");
        } else if (request.getParameter("info").equals("error_create_ticket")) {
            request.setAttribute("info", "Ha ocurrido un error al crear el caso");
        }
    }
%>

<html>
<head>
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="../assets/js/bootstrap.min.js"></script>
    <title>Jefe de área funcional - Main</title>
</head>
<body>
    <!-- Importación del navbar -->
    <jsp:include page="../navbar.jsp" />

    <main class="container mt-3">
        <%
            // Mostrar mensajes de información recibidos de la petición
            if (request.getAttribute("info") != null) {
        %>
        <div class="alert my-5 <%= request.getParameter("info").startsWith("error") ? "alert-danger" : "alert-success" %>"
             role="alert">
            <%= request.getAttribute("info") %>
        </div>
        <%
            }
        %>

        <div class="d-flex justify-content-between">
            <div>
                <h1>Bienvenido <%= user.getName() %></h1>
                <p class="small"> Jefe de área funcional</p>
            </div>

            <input type="button" class="btn btn-primary text-white h-50" data-bs-toggle="modal" data-bs-target="#createTicketModal"
                   value="Solicitar un nuevo caso" onclick="loadLogForm()"
            />
        </div>

        <div>
            <h3>Tus casos asignados</h3>
            <div class="table-container">
                <table class="table table-striped table-bordered text-center">
                    <thead>
                    <tr>
                        <th>Código</th>
                        <th>Título</th>
                        <th>Fecha de entrega</th>
                        <th>Acción</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        // Obtener los tickets asignados al empleado de área
                        HashMap<String, Ticket> tickets = (HashMap<String, Ticket>) request.getAttribute("tickets");
                        if(tickets == null || tickets.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="4">No hay casos asignados</td>
                    </tr>
                    <%
                    } else {
                        // Iterar sobre los tickets y mostrarlos en la tabla
                        for (Ticket ticket : tickets.values()) {
                    %>
                    <tr>
                        <td><%= ticket.getCode() %></td>
                        <td><%= ticket.getName() %></td>
                        <td><%= ticket.getDue_date() != null ? ticket.getDue_date() : "Por definir..." %></td>
                        <td>
                            <!-- Botón para ver el detalle del ticket -->
                            <a href="/requester/detail.jsp?&id=<%= ticket.getId() %>" class="btn btn-primary">Ver</a>
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

    <!-- Modal: Rechazar un caso -->
    <div class="modal fade" id="createTicketModal" tabindex="-1" aria-labelledby="createTicketModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createTicketModalLabel">Solicitar un nuevo caso</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">X</button>
                </div>
                <div class="modal-body" id="createTicketModalBody">
                    <!-- Contenido del modal -->
                </div>
            </div>
        </div>
    </div>

    <!-- Modal: Manejo de errores -->
    <div class="modal fade" id="extraModal" tabindex="-1" aria-labelledby="extraModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="extraModalLabel">Atención</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">X</button>
                </div>
                <div class="modal-body" id="extraModalBody">
                    <!-- Contenido del modal -->
                </div>
            </div>
        </div>
    </div>

    <script>
        // Funciones para cargar contenido en los modales
        function loadLogForm() { // Cargar formulario de nuevo registro de bitácora que recibe información del ticket en un Object
            document.getElementById("createTicketModalBody").innerHTML = "<p>Completa todos los campos para crear el registro</p>" +
                "<form onsubmit='return validateForm()' action='/rqc' method='post'>" + // Formulario de nuevo caso donde el evento onsubmit valida los campos y si to.do está correcto, envía la petición al servlet
                "<div class='form-group'>" +
                "<label for='titleTicket'><strong>Título del proyecto:</strong></label>" +
                "<input type='text' id='titleTicket' name='title' class='form-control'>" +
                "</div>" +
                "<div class='form-group'>" +
                "<label for='descTicket'><strong>Descripción del proyecto:</strong></label>" +
                "<textarea type='text' id='descTicket' name='description' class='form-control'> </textarea>" +
                "</div>" +
                "<div class='d-flex justify-content-center px-3'>" +
                "<input type='hidden' name='action' value='create_ticket' />" +
                "<input type='submit' class='btn btn-success mr-4' value='Guardar' />" +
                "<button type='button' class='btn btn-info' data-bs-dismiss='modal' aria-label='Close'>Salir</button>" +
                "</div>" +
                "</form>";
        }

        function validateForm() {
            // Validar campos del formulario de nuevo registro de bitácora para rechazar el proyecto
            let title = document.getElementById("titleTicket").value;
            let description = document.getElementById("descTicket").value;

            // Mostrar mensaje de error si los campos no están completos o no cumplen con las condiciones
            if (description === "" || title === "") {
                showErrorModal("Por favor, completa todos los campos.");
                return false;
            } else if (description.length < 50 || title.length < 10) {
                showErrorModal("El título debe tener al menos 10 caracteres y la descripción 50.");
                return false;
            }

            // Si to.do está correcto, retornar true
            return true;
        }

        function showErrorModal(mensaje) {
            // Mostrar modal de error con el mensaje recibido
            let errorModalBody = document.getElementById('extraModalBody');
            errorModalBody.innerHTML = "<p>" + mensaje + "</p>";

            // Ocultar modal actual y mostrar modal de error
            let currentModal = bootstrap.Modal.getInstance(document.getElementById('createTicketModal'));
            currentModal.hide();

            // Mostrar modal de error
            let errorModal = new bootstrap.Modal(document.getElementById('extraModal'));
            errorModal.show();
        }
    </script>
</body>
</html>