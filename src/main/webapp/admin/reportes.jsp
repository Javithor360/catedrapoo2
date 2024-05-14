<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>
<%@ page import="com.ticket.catedrapoo2.beans.Ticket" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Obtener la sesión actual
    HttpSession currentSession = request.getSession(false);
    UserSession user = (UserSession) currentSession.getAttribute("user");

    if (user == null || user.getRole_id() != 0) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Verificar si el parámetro "action" ya está presente en la URL
//    String actionParam = request.getParameter("action");
//    if (actionParam == null || !actionParam.equals("generar_reporte")) {
//        // Redirigir al servlet con el parámetro "action"
//        request.getRequestDispatcher("/adminController?action=generar_reporte").forward(request, response);
//        return;
//    }
%>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="../assets/js/bootstrap.min.js"></script>
    <title>Generación de reportes</title>
</head>
<body>
<jsp:include page="../navbar.jsp"/>

<main class="container mt-3">
    <h1 class="text-center mb-4">Generación de reportes</h1>
    <hr />
    <div class="container">
        <form class="d-flex gap-2" action="/adminController" method="POST">
            <div class="form-group d-flex mr-2">
                <label for="status"><strong>Estado</strong></label>
                <select class="form-control form-select" id="status" name="status">
                    <option value="1">En espera de respuesta</option>
                    <option value="2">Solicitud rechazada</option>
                    <option value="3">En desarrollo</option>
                    <option value="4">Esperando respuesta del área solicitante</option>
                    <option value="5">Vencido</option>
                    <option value="6">Devuelto con observaciones</option>
                    <option value="7">Finalizado</option>
                </select>
            </div>
            <div class="form-group d-flex mr-2">
                <label for="fecha_inicio"><strong>Desde</strong></label>
                <input type="date" class="form-control" id="fecha_inicio" name="fecha_inicio" />
            </div>
            <div class="form-group d-flex mr-2">
                <label for="fecha_fin"><strong>Hasta</strong></label>
                <input type="date" class="form-control" id="fecha_fin" name="fecha_fin" />
            </div>
            <div class="form-group d-flex mr-2">
                <input type="hidden" name="operacion" value="generar_reporte" />
                <button type="submit">Buscar</button>
            </div>
        </form>
    </div>
    <hr />
    <table class="table table-striped table-bordered text-center">
        <thead>
            <tr>
                <th>Código</th>
                <th>Estado</th>
                <th>Título</th>
                <th>Fecha de solicitud</th>
            </tr>
        </thead>
        <tbody>
        <%
            // Obtener los tickets asignados al programador de la respuesta a la petición inicial
            HashMap<String, Ticket> tickets = (HashMap<String, Ticket>) request.getAttribute("filtered_tickets");
            if(tickets == null || tickets.isEmpty()) {
        %>
            <tr>
                <td colspan="5">No hay resultados de búsqueda</td>
            </tr>
        <%
            } else {
                // Iterar sobre los tickets y mostrarlos en la tabla
                for (Ticket ticket : tickets.values()) {
        %>
            <tr>
                <td><%= ticket.getCode() %></td>
                <td><%= ticket.getState() %></td>
                <td><%= ticket.getName() %></td>
                <td><%= ticket.getCreated_at() %></td>
            </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>
</main>
</body>
</html>
