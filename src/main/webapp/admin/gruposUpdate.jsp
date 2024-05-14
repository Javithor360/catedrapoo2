<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>
<%--
  Created by IntelliJ IDEA.
  User: oscar
  Date: 5/10/2024
  Time: 5:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%
    // Validar si el usuario tiene permisos para acceder a esta página
    HttpSession currentSesion = request.getSession(false);
    UserSession user = (UserSession) currentSesion.getAttribute("user");

    if (user == null || user.getRole_id() != 0) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String groupId = request.getParameter("id");

    // Validar que el id del grupo sea un número
    if (groupId == null || groupId.isEmpty() || !groupId.matches("\\d+")) {
        response.sendRedirect("./grupos.jsp");
        return;
    }

    response.sendRedirect("/adminController?model=usergroup&action=update&id=" + groupId);
    return;
%>