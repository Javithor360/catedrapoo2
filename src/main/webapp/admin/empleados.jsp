<%@ page import="com.ticket.catedrapoo2.models.AdminUsers" %>
<%@ page import="com.ticket.catedrapoo2.beans.Users" %>
<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>
<%@ page import="com.ticket.catedrapoo2.beans.Roles" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<html>
<head>
    <title>Formulario</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
</head>
<body>

<%
    // Validar si el usuario tiene permisos para acceder a esta página
    HttpSession currentSesion = request.getSession(false);
    UserSession userSession = (UserSession) currentSesion.getAttribute("user");

    if (userSession == null || userSession.getRole_id() != 0) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<jsp:include page="../navbar.jsp"/>

<c:choose>
    <c:when test="${not empty param.id}">
        <sql:setDataSource driver="com.mysql.cj.jdbc.Driver"
                           url="jdbc:mysql://localhost/catedrapoo"
                           user="root"
                           password=""/>
        <%
            int id = Integer.parseInt(request.getParameter("id"));
            AdminUsers operaciones = new AdminUsers();

            Users user = operaciones.buscarId(id);

        %>

        <div class="container">

            <h2 class="d-flex justify-content-center align-items-center mt-3">Modificar Empleado</h2>

            <form action="../adminController" method="POST">
                <div class="row">
                    <input type="hidden" value="modificarEmpleado" name="operacion">
                    <input type="hidden" value="<%= user.getId() %>" name="id">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Nombres:</label>
                            <input type="text" class="form-control" value="<%= user.getName() %>" name="name"
                                   placeholder="Ingrese su nombre" required>
                        </div>
                        <div class="form-group">
                            <label>Correo electrónico:</label>
                            <input type="email" class="form-control" name="email" value="<%= user.getEmail() %>"
                                   placeholder="Ingrese su correo electrónico" required>
                        </div>
                    </div>

                    <div class="col-md-6">

                        <div class="form-group">
                            <label>Género:</label>
                            <select class="form-control" name="gender" required>
                                <option value="M" <%= user.getGender().equals("M") ? "selected" : "" %>>Masculino</option>
                                <option value="F" <%= user.getGender().equals("F") ? "selected" : "" %>>Femenino</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Seleccione el Rol:</label>
                            <select name="rol" class="form-control" required>
                                <%
                                    AdminUsers oper = new AdminUsers();
                                    List<Roles> rolList = oper.listarRoles();
                                    int roluser = user.getRol();
                                      for (Roles rol : rolList) {
                                %>
                                <option value="<%= rol.getId() %>" <%= rol.getId() == roluser ? "selected" : "" %>><%= rol.getName() %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="form-group">
                            <label>Fecha de nacimiento:</label>
                            <input type="date" class="form-control" value="<%= user.getBirthday() %>" name="birthday" required>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-center align-items-center mt-3">
                    <button type="submit" class="btn btn-primary m-3">Enviar</button>
                    <a href="menuEmpleado.jsp" class="btn btn-info m-3">Volver</a>
                </div>
            </form>
        </div>
    </c:when>

    <c:otherwise>
        <div class="container">

            <h2 class="d-flex justify-content-center align-items-center mt-3">Crear Empleado</h2>

            <form action="../adminController" method="POST">
                <div class="row">
                    <input type="hidden" value="nuevoEmpleado" name="operacion">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Nombres:</label>
                            <input type="text" class="form-control" name="name" placeholder="Ingrese su nombre"
                                   required>
                        </div>
                        <div class="form-group">
                            <label>Correo electrónico:</label>
                            <input type="email" class="form-control" name="email"
                                   placeholder="Ingrese su correo electrónico" required>
                        </div>
                        <div class="form-group">
                            <label>Fecha de nacimiento:</label>
                            <input type="date" class="form-control" name="birthday" required>
                        </div>
                    </div>


                    <div class="col-md-6">

                        <div class="form-group">
                            <label>Género:</label>
                            <select class="form-control" name="gender" required>
                                <option value="M">Masculino</option>
                                <option value="F">Femenino</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Contraseña:</label>
                            <input type="password" class="form-control" name="password"
                                   placeholder="Ingrese su contraseña" required>
                        </div>

                        <div class="form-group">
                            <label>Seleccione el Rol:</label>
                            <select name="rol" class="form-control" required>
                                <%
                                    AdminUsers operacion = new AdminUsers();
                                    List<Roles> rolesList = operacion.listarRoles();
                                    for (Roles rol : rolesList) {
                                %>
                                <option value="<%= rol.getId() %>"><%= rol.getName() %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-center align-items-center mt-3">

                    <button type="submit" class="btn btn-primary m-3">Enviar</button>

                    <a href="menuEmpleado.jsp" class="btn btn-info m-3">Volver</a>
                </div>

            </form>
        </div>
    </c:otherwise>
</c:choose>
</body>
</html>
