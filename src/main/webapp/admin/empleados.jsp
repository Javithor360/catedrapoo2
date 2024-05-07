<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<html>
<head>
    <title>Formulario</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container">
    <h2 class="d-flex justify-content-center align-items-center mt-3">Crear Usuario</h2>

    <form action="../adminController" method="POST">
        <div class="row">
            <input type="hidden" value="nuevoEmpleado" name="operacion">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="name">Nombres:</label>
                        <input type="text" class="form-control" id="name" name="name" placeholder="Ingrese su nombre" required>
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
                        <label for="gender">Género:</label>
                        <select class="form-control" id="gender" name="gender" required>
                            <option value="M">Masculino</option>
                            <option value="F">Femenino</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="password">Contraseña:</label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="Ingrese su contraseña" required>
                    </div>

                    <div class="form-group">
                        <label >Seleccione el Rol:</label>
                        <select name="rol" id="rol" class="form-control" required>
                            <sql:setDataSource driver="com.mysql.cj.jdbc.Driver"
                                               url="jdbc:mysql://localhost/catedrapoo"
                                               user="root"
                                               password=""/>
                            <sql:query var="q1">
                                SELECT * FROM roles
                            </sql:query>
                            <c:forEach var="query" items="${q1.rows}">
                                <option value="${query.id}">${query.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
        </div>

        <div class="d-flex justify-content-center align-items-center mt-3">
            <button type="submit" class="btn btn-primary ">Enviar</button>
        </div>
    </form>
</div>
</body>
</html>
