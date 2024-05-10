<%@ page import="com.ticket.catedrapoo2.models.AdminUsers" %>
<%@ page import="com.ticket.catedrapoo2.beans.Users" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<html>
<head>
    <title>Formulario</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
</head>
<body>


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
                            <label >Nombres:</label>
                            <input type="text" class="form-control" value="<%= user.getName() %>"  name="name" placeholder="Ingrese su nombre" required>
                        </div>
                        <div class="form-group">
                            <label>Correo electrónico:</label>
                            <input type="email" class="form-control" name="email"  value="<%= user.getEmail() %>" placeholder="Ingrese su correo electrónico" required>
                        </div>
                    </div>

                    <div class="col-md-6">

                        <div class="form-group">
                            <label >Género:</label>
                            <select class="form-control" name="gender" required>
                                <option value="M" ${user.getGender() eq 'M' ? 'selected' : ''}>Masculino</option>
                                <option value="F" ${user.getGender() eq 'F' ? 'selected' : ''}>Femenino</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label >Seleccione el Rol:</label>
                            <select name="rol" class="form-control" required>
                                <sql:setDataSource driver="com.mysql.cj.jdbc.Driver"
                                                   url="jdbc:mysql://localhost/catedrapoo"
                                                   user="root"
                                                   password=""/>
                                <sql:query var="q1">
                                    SELECT * FROM roles
                                </sql:query>
                                <c:forEach var="query" items="${q1.rows}">
                                    <option value="${query.id}" selected>${query.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="form-group">
                            <label >Fecha de nacimiento:</label>
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
                                <label >Nombres:</label>
                                <input type="text" class="form-control" name="name" placeholder="Ingrese su nombre" required>
                            </div>
                            <div class="form-group">
                                <label>Correo electrónico:</label>
                                <input type="email" class="form-control" name="email" placeholder="Ingrese su correo electrónico" required>
                            </div>
                            <div class="form-group">
                                <label >Fecha de nacimiento:</label>
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
                                <input type="password" class="form-control" name="password" placeholder="Ingrese su contraseña" required>
                            </div>

                            <div class="form-group">
                                <label>Seleccione el Rol:</label>
                                <select name="rol" class="form-control" required>
                                    <sql:setDataSource driver="com.mysql.cj.jdbc.Driver"
                                                       url="jdbc:mysql://localhost/catedrapoo"
                                                       user="root"
                                                       password=""/>
                                    <sql:query var="q1">
                                        SELECT * FROM roles
                                    </sql:query>
                                    <c:forEach var="query" items="${q1.rows}">
                                        <option value="${query.id}" selected>${query.name}</option>
                                    </c:forEach>
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
