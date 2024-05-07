<%--
  Created by IntelliJ IDEA.
  User: oscar
  Date: 02/05/2024
  Time: 10:06 p. m.
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Verificar si el admin tiene una sesión activa
    HttpSession currentSession = request.getSession(false);
    UserSession user = (UserSession) currentSession.getAttribute("user");

    if (user == null || user.getRole_id() != 0) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Verificar si el parámetro "action" ya está presente en la URL
    // String action = request.getParameter("action");
    // if (actionParam == null || !actionParam.equals("admin") {
    //    response.sendRedirect("admin.jsp");
    //    return;
    // }

%>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="../assets/js/bootstrap.min.js"></script>
    <title>Admin - Main</title>
</head>

<body>

<jsp:include page="../navbar.jsp"/>

<main class="container mt-3">
    <div>
        <h1>Bienvenido <%= user.getName() %>
        </h1>
        <p class="small"> Admin</p>
    </div>

    <div class="my-4">
        <ul class="list-group">
            <li class="list-group-item text-center">
                <a href="menuEmpleado.jsp">Nuevo Empleado</a>
            </li>
            <li class="list-group-item text-center">
                <a href="areas.jsp?action=index">Gestión de Áreas Funcionales</a>
            </li>
            <li class="list-group-item text-center">
                <a href="grupos.jsp?action=index">Distribución de Grupos</a>
            </li>
        </ul>
    </div>

</main>

</body>
</html>