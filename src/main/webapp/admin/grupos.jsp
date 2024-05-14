<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>
<%@ page import="com.ticket.catedrapoo2.beans.MapeoBean" %>
<%@ page import="java.util.HashMap" %><%--
  Created by IntelliJ IDEA.
  User: oscar
  Date: 03/05/2024
  Time: 12:16 a. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Válidar si el usuario tiene permisos para acceder a la página
    HttpSession currentSession = request.getSession(false);
    UserSession user = (UserSession) currentSession.getAttribute("user");

    if (user == null || user.getRole_id() != 0) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String actionParam = request.getParameter("action");

    if (actionParam == null || !actionParam.equals("index")) {
        request.getRequestDispatcher("/adminController?model=usergroup&action=index").forward(request, response);
        return;
    }

%>
<html lang="es">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="../assets/js/bootstrap.min.js"></script>
    <title>Admin - Grupos</title>
</head>
<body>

<jsp:include page="../navbar.jsp"/>

<main class="container mt-3">
    <h1 class="text-center mb-4">Creando Nueva Área Funcional</h1>
    <div class="text-center mb-2">Administra y visualiza el mapeo de integrantes de los distintos grupos de las Áreas
        Funcionales.
    </div>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Área</th>
            <th>Nombre Grupo</th>
            <th>Jefe</th>
            <th>Empleados/Programadores</th>
            <th>Acción</th>
        </tr>
        </thead>
        <tbody>
        <%
            HashMap<Integer, MapeoBean> grupos = (HashMap<Integer, MapeoBean>) request.getAttribute("grupos");

            System.out.println(request.getAttribute("areas"));

            if (grupos.size() > 0 && !grupos.isEmpty()) {
                for (MapeoBean grupo : grupos.values()) {
        %>
        <tr>
            <td>
                <%= grupo.getId() %>
            </td>
            <td>
                <%= grupo.getName_area() %>
            </td>
            <td>
                <%= grupo.getName_group() %>
            </td>
            <td>
                <%= grupo.getName_boss() %>
            </td>
            <td>
                <%= grupo.getTotal_users() %>
            </td>
            <td>
                <a href="gruposUpdate.jsp?id=<%= grupo.getId() %>" class="btn btn-primary">Editar</a>
<%--                <a href="/adminController?model=usergroup&action=update&id=<%= grupo.getId() %>" class="btn btn-primary">Editar</a>--%>
            </td>
        </tr>
        <%
            }

        } else {
        %>
        <tr>
            <td colspan="4">Sin Grupos Disponibles</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <div class="d-flex justify-content-center">
        <a href="/admin/main.jsp" class="btn btn-primary">
            Volver
        </a>
    </div>
</main>
</body>
</html>
