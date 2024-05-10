<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.ticket.catedrapoo2.beans.AreaBean" %>
<%@ page import="com.ticket.catedrapoo2.models.Area" %><%--
  Created by IntelliJ IDEA.
  User: oscar
  Date: 03/05/2024
  Time: 12:15 a. m.
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Validar si el usuario tiene permisos para acceder a esta página
    HttpSession currentSesion = request.getSession(false);
    UserSession user = (UserSession) currentSesion.getAttribute("user");

    if (user == null || user.getRole_id() != 0) {
        response.sendRedirect("login.jsp");
    }

    String actionParam = request.getParameter("action");

    if (actionParam == null || !actionParam.equals("index")) {
        request.getRequestDispatcher("/admin/areas?action=index").forward(request, response);
        return;
    }
%>
<html lang="es">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="../assets/js/bootstrap.min.js"></script>
    <title>Admin - Áreas Funcionales</title>
</head>
<body>

<jsp:include page="../navbar.jsp"/>

<main class="container mt-3">
    <h1 class="text-center mb-4">Gestionando Áreas Funcionales</h1>
    <div class="text-center mb-2">Administra y visualiza las distintas áreas funcionales disponibles.</div>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>Préfijo</th>
            <th>Nombre</th>
            <th>Jefe de Área</th>
            <th>Jefe de Desarrollo</th>
        </tr>
        </thead>
        <tbody>
        <%
            HashMap<Integer, AreaBean> areas = (HashMap<Integer, AreaBean>) request.getAttribute("areas");

            System.out.println(request.getAttribute("areas"));

            if (areas.size() > 0 && !areas.isEmpty()) {
                for (AreaBean area : areas.values()) {
        %>
        <tr>
            <td>
                <%= area.getPrefix_code() %>
            </td>
            <td>
                <%= area.getName() %>
            </td>
            <td>
                <%= area.getBoss_name() %>
            </td>
            <td>
                <%= area.getDev_boss_name() %>
            </td>
        </tr>
        <%
            }

        } else {
        %>
        <tr>
            <td colspan="4">Sin Areas Disponibles</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <div class="d-flex justify-content-center">
        <a href="/admin/areasCreate.jsp" class="btn btn-primary">
            Crear
        </a>
    </div>

</main>
</body>
</html>
