<%--
  Created by IntelliJ IDEA.
  User: flore
  Date: 10/4/2024
  Time: 00:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    HttpSession currentSession = request.getSession(false);
    UserSession user = (UserSession) currentSession.getAttribute("user");

    if(user == null || user.getRole_id() != 3) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Title</title>
</head>
<body>
<h1>Bienvenido jefe de area funcional</h1>
<h2>Tú eres <%= user.getName() %></h2>
<a href="../session_handler?operacion=logout"><button>Salir</button></a>
</body>
</html>