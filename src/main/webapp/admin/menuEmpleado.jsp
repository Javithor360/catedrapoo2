<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ticket.catedrapoo2.beans.Users" %>
<%@ page import="com.ticket.catedrapoo2.models.AdminUsers" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Listado de Ventas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
</head>
<body>l
<div class="container mt-3">
    <center>
        <h1>Listado de Empleados</h1>
    </center>
</div>
<div class="container mt-5">
    <a class="btn btn-info mb-3" href="empleados.jsp">Agregar Empleado</a>
    <table class="table table-bordered">
        <thead class="thead-dark">
        <tr>
            <th>Nombre</th>
            <th>Correo</th>
            <th>Género</th>
            <th>Rol</th>
            <th>Creado</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>
        <%
            AdminUsers users = new AdminUsers();
            List<Users> user = users.obtenerUsers();
            if (user.isEmpty()) {
        %>
        <tr>
            <td colspan="6" class="text-center">No hay empleados registrados.</td>
        </tr>
        <% } else {
            for (Users user1 : user) {
        %>
        <tr>
            <td><%= user1.getName() %></td>
            <td><%= user1.getEmail() %></td>
            <td><%= user1.getGender() %></td>
            <td><%= user1.getRole_id() %></td>
            <td><%= user1.getCreated_at() %></td>
            <td>
                <button class="btn btn-danger" onclick="alerta(<%= user1.getId() %>)">Eliminar</button>
                <button class="btn btn-primary" onclick="modif(<%= user1.getId() %>)">Modificar</button>
            </td>
        </tr>
        <% }
        } %>
        </tbody>
    </table>
    <c:if test="${not empty requestScope.mensaje}">
        <div class="alert alert-success mt-5">
            <strong>Operación: </strong><c:out value="${requestScope.mensaje}"/>
        </div>
    </c:if>

    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-danger mt-5">
            <strong>Error!: </strong><c:out value="${requestScope.error}"/>
        </div>
    </c:if>
    <script>
        function alerta(id) {
            var opcion = confirm("¿Está seguro de eliminar este registro?");
            if (opcion) {

                var form = document.createElement("form");
                form.method = "POST";
                form.action = "../adminController";

                var inputOperacion = document.createElement("input");
                inputOperacion.type = "hidden";
                inputOperacion.name = "operacion";
                inputOperacion.value = "eliminar";

                var inputId = document.createElement("input");
                inputId.type = "hidden";
                inputId.name = "id";
                inputId.value = id;

                form.appendChild(inputOperacion);
                form.appendChild(inputId);

                document.body.appendChild(form);

                form.submit();
            }
        }

        function modif(id) {
            var opcion = confirm("Esta seguro de modificar este registro?");
            if (opcion == true) {
                location.href ="empleados.jsp?id="+id;
            }
        }
    </script>
</div>
</body>
</html>
