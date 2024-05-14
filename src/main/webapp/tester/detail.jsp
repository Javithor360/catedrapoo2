<%@ page import="com.ticket.catedrapoo2.beans.Ticket" %>
<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.ticket.catedrapoo2.beans.Bitacora" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Obtener la sesión actual
    HttpSession currentSession = request.getSession(false);
    UserSession user = (UserSession) currentSession.getAttribute("user");
    Ticket ticket = (Ticket) request.getAttribute("ticket");

    // Si no hay sesión o el usuario no es un tester, redirigir al login
    if (user == null || user.getRole_id() != 4) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Si no hay ticket o el ticket no pertenece al tester, redirigir al dashboard
    if (request.getParameter("id") == null || (ticket != null && !ticket.getTester_name().equals(user.getName()))) {
        response.sendRedirect("/tester/main.jsp");
        return;
    }

    // Si no hay ticket, redirigir al dashboard
    String actionParam = request.getParameter("action");
    if (actionParam == null || !actionParam.equals("display_ticket")) {
        request.getRequestDispatcher("/pbc?action=display_ticket&ticket_id=" + request.getParameter("id")).forward(request, response);
        return;
    }

    // Mensajes de información recibidos de la petición
    if (request.getParameter("info") != null) {
        if (request.getParameter("info").equals("success_reject_log")) {
            request.setAttribute("info", "El caso ha sido rechazado con éxito");
        } else if (request.getParameter("info").equals("error_new_log")) {
            request.setAttribute("info", "Ha ocurrido un error al rechazar el caso");
        } else if (request.getParameter("info").equals("success_accept_ticket")) {
            request.setAttribute("info", "El caso ha sido aceptado con éxito");
        } else if (request.getParameter("info").equals("error_accept_ticket")) {
            request.setAttribute("info", "Ha ocurrido un error al aceptar el caso");
        }
    }

    // Obtener el progreso del ticket una vez el ticket esté definido
    double ticket_progress = ticket.get_latest_percent(ticket);
%>

<html>
<head>
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="../assets/js/bootstrap.min.js"></script>
    <title>Empleado de área funcional - Información</title>
</head>
<body>
    <!-- Navbar -->
    <jsp:include page="../navbar.jsp"/>

    <main class="container mx-auto my-5 w-50">
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
        <h1 class="text-center">Información del ticket</h1>
        <hr class="mb-3"/>
        <form action="#"> <!-- Formulario de información del ticket -->
            <div class="row g-2">
                <div class='form-group col-md-4'>
                    <label for='id'><strong>ID:</strong></label>
                    <input type='text' id='id' class='form-control' value='<%= ticket.getId() %>' readonly> <!-- Campos solo de lectura -->
                </div>
                <div class='form-group col-md-4'>
                    <label for='code'><strong>Código:</strong></label>
                    <input type='text' id='code' class='form-control' value='<%= ticket.getCode() %>' readonly>
                </div>
                <div class='form-group col-md-4'>
                    <label for='state'><strong>Estado:</strong></label>
                    <input type='text' id='state' class='form-control' value='<%= ticket.getState() %>' readonly>
                </div>
            </div>

            <div class='row g-2'>
                <div class='form-group col-md-6'>
                    <label for='requester'><strong>Solicitante:</strong></label>
                    <input type='text' id='requester' class='form-control'
                           value='<%= ticket.getBoss_name() %> (Depto de. <%= ticket.getRequester_area_name() %>)' readonly>
                </div>
                <div class='form-group col-md-6'>
                    <label for='tester'><strong>Probador:</strong></label>
                    <input type='text' id='tester' class='form-control' value='<%= ticket.getTester_name() %>' readonly>
                </div>
                <div class='form-group col-md-6'>
                    <label for='programmer'><strong>Programador:</strong></label>
                    <input type='text' id='programmer' class='form-control' value='<%= ticket.getProgrammer_name() %>'
                           readonly>
                </div>
                <div class='form-group col-md-6'>
                    <label for='boss'><strong>Jefe de desarrollo:</strong></label>
                    <input type='text' id='boss' class='form-control' value='<%= ticket.getDev_boss_name() %>' readonly>
                </div>
            </div>

            <div class='row g-2'>
                <div class='form-group col-md-12'>
                    <label for='title'><strong>Título:</strong></label>
                    <input type='text' id='title' class='form-control' value='<%= ticket.getName() %>' readonly>
                </div>
                <div class='form-group col-md-12'>
                    <label for='description'><strong>Descripción del caso:</strong></label>
                    <textarea id='description' class='form-control' rows='3'
                              readonly><%= ticket.getDescription() %></textarea>
                </div>
                <div class='form-group col-md-12'>
                    <label for='observations'><strong>Observaciones del jefe de desarrollo:</strong></label>
                    <textarea id='observations' class='form-control' rows='3'
                              readonly><%= ticket.getObservations() %></textarea>
                </div>
            </div>

            <div class='row g-2'>
                <div class='form-group col-md-6'>
                    <label for='created_at'><strong>Fecha de solicitud:</strong></label>
                    <input type='text' id='created_at' class='form-control' value='<%= ticket.getCreated_at() %>' readonly>
                </div>
                <div class='form-group col-md-6'>
                    <label for='updated_at'><strong>Fecha de entrega:</strong></label>
                    <input type='text' id='updated_at' class='form-control' value='<%= ticket.getDue_date() %>' readonly>
                </div>
            </div>

            <div class='form-group'>
                <label for='logs'><strong>Bitácora:</strong></label>
                <table class='table table-striped table-bordered text-center' id='logs'> <!-- Tabla de bitácora -->
                    <thead>
                    <tr>
                        <th>Título</th>
                        <th>Descripción</th>
                        <th>Avance</th>
                        <th>Autor</th>
                        <th>Fecha creación</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        // Si no hay registros en la bitácora, mostrar mensaje
                        if (ticket.getLogs().isEmpty()) {
                    %>
                    <tr>
                        <td colspan='5'>No hay registros en la bitácora</td>
                    </tr>
                    <%
                    } else {
                        // Mostrar registros de la bitácora
                        for (Map.Entry<Integer, Bitacora> logs : ticket.getLogs().entrySet()) {
                            Bitacora log = logs.getValue();
                    %>
                    <tr>
                        <td><%= log.getName() %>
                        </td>
                        <td><%= log.getDescription() %>
                        </td>
                        <td><%= log.getPercent() %> %
                        </td>
                        <td><%= log.getProgrammer_name() %>
                        </td>
                        <td><%= log.getCreated_at() %>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
                <div class="d-flex justify-content-between">
                    <%
                        // Deshabilitar botón de aceptar o negar caso si el ticket no esta a la espera de respuesta
                        boolean disableButton = (ticket_progress != 100 || ticket.getState_id() != 4);
                    %>

                    <input type="button" value="Aceptar caso" class="btn btn-primary ml-5"
                           data-bs-toggle="modal" data-bs-target="#extraModal"
                            <%= disableButton ? "disabled" : "" %>
                           onclick="loadAcceptTicket({
                                   ticket_id: <%= ticket.getId() %>,
                                   ticket_code: '<%= ticket.getCode() %>'
                                   })"
                    /> <!-- Botón de aceptar caso -->

                    <div class="text-center">
                        <input type="button" class="btn btn-danger mr-5" data-bs-toggle="modal" data-bs-target="#rejectCaseModal"
                               value="Rechazar caso" <%= disableButton ? "disabled" : "" %>
                               onclick="loadLogForm({
                                       ticket_id: <%= ticket.getId() %>,
                                       tester_id: <%= user.getId() %>,
                                       ticket_code: '<%= ticket.getCode() %>',
                                       programmer_name: '<%= user.getName() %>',
                                       due_date: '<%= ticket.getDue_date() %>'
                                       })"
                        /> <!-- Botón de rechazar caso -->

                    </div>
                </div>
                <div class="d-flex justify-content-center">
                    <!-- Botones de acción -->
                    <a href="/tester/main.jsp" class="btn btn-secondary">Volver a la página principal</a> <!-- Botón de volver -->
                </div>
            </div>
        </form>
    </main>

    <!-- Modal: Rechazar un caso -->
    <div class="modal fade" id="rejectCaseModal" tabindex="-1" aria-labelledby="rejectCaseModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="rejectCaseModalLabel">Rechazar caso - Caso <%= ticket.getCode() %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">X</button>
                </div>
                <div class="modal-body" id="rejectCaseModalBody">
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
        <%! // Función para formatear la fecha de entrega y sumar 1 semana
            public String returnFormattedDate(String due_date){
                // Formateador para la cadena de fecha
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

                // Convertir la cadena de fecha en un LocalDateTime
                LocalDateTime newDate = LocalDateTime.parse(due_date, formatter);
                newDate = newDate.plusWeeks(1);
                return newDate.format(formatter);
            }
        %>

        // Funciones para cargar contenido en los modales
        function loadLogForm(ticket_info) { // Cargar formulario de nuevo registro de bitácora que recibe información del ticket en un Object
            newDate = "<%= returnFormattedDate(ticket.getDue_date()) %>"

            document.getElementById("rejectCaseModalBody").innerHTML = "<p>Completa todos los campos para guardar el registro</p>" +
                "<form onsubmit='return validateForm()' action='/pbc' method='post'>" + // Formulario de nuevo registro de bitácora donde el evento onsubmit valida los campos y si to.do está correcto, envía la petición al servlet
                "<div class='row g-2'>" +
                "<div class='form-group col-md-6'>" +
                "<label for='ticket_code'><strong>Ticket:</strong></label>" +
                "<input type='text' id='ticket_code' class='form-control' value='" + ticket_info.ticket_code + "' readonly>" +
                "</div>" +
                "<div class='form-group col-md-6'>" +
                "<label for='author'><strong>Autor:</strong></label>" +
                "<input type='text' id='author' class='form-control' value='" + ticket_info.programmer_name + "' readonly>" +
                "</div>" +
                "</div>" +
                "<div class='form-group'>" +
                "<label for='name'><strong>Fecha de entrega original:</strong></label>" +
                "<input type='text' class='form-control' id='oldDate' name='oldDate' value='"+ticket_info.due_date+"' readonly>" +
                "</div>" +
                "<div class='form-group'>" +
                "<label for='name'><strong>Fecha de entrega actualizada:</strong></label>" +
                "<input type='text' class='form-control' id='newDate' name='newDate' value='"+newDate+"' readonly>" +
                "</div>" +
                "<div class='form-group'>" +
                "<label for='bdescription'><strong>Descripción</strong></label>" +
                "<textarea class='form-control' id='bdescription' name='description' placeholder='Ingresa la descripción...' required>" +
                "</textarea>" +
                "</div>" +
                "<div class='d-flex justify-content-center'>" +
                "<input type='hidden' name='ticket_id' value='" + ticket_info.ticket_id + "' />" + // Campos ocultos con información del ticket
                "<input type='hidden' name='code' value='" + ticket_info.ticket_code + "' />" +
                "<input type='hidden' name='tester_id' value='" + ticket_info.tester_id + "' />" +
                "<input type='hidden' name='action' value='reject_ticket' />" +
                "<input type='submit' class='btn btn-success mr-4' value='Guardar' />" +
                "<button type='button' class='btn btn-info' data-bs-dismiss='modal' aria-label='Close'>Salir</button>" +
                "</div>" +
                "</form>";
        }

        function validateForm() {
            // Validar campos del formulario de nuevo registro de bitácora para rechazar el proyecto
            let description = document.getElementById("bdescription").value;

            // Mostrar mensaje de error si los campos no están completos o no cumplen con las condiciones
            if (description === "") {
                showErrorModal("Por favor, completa todos los campos.");
                return false;
            } else if (description.length < 50) {
                showErrorModal("La descripción debe tener al menos 50 caracteres.");
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
            let currentModal = bootstrap.Modal.getInstance(document.getElementById('rejectCaseModal'));
            currentModal.hide();

            // Mostrar modal de error
            let errorModal = new bootstrap.Modal(document.getElementById('extraModal'));
            errorModal.show();
        }

        function loadAcceptTicket(ticket_info) {
            // Cargar modal de confirmación de entrega de caso
            document.getElementById("extraModalBody").innerHTML = "<p>¿Estás seguro que deseas aceptar y cerrar el caso <strong>" + ticket_info.ticket_code + "</strong>?</p>" +
                "<div class='d-flex justify-content-between'>" +
                "<a href='/pbc?action=accept_ticket&id=" + ticket_info.ticket_id + "' class='btn btn-success mr-3'>Aceptar</a>" + // Botón de entregar caso que redirige al servlet con la acción de entregar el caso
                "<button type='button' class='btn btn-secondary mr-3' data-bs-dismiss='modal' aria-label='Close'>Cancelar</button>"+
                "</div>";
        }
    </script>
</body>
</html>
