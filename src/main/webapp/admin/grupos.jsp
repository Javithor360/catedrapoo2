<%--
  Created by IntelliJ IDEA.
  User: oscar
  Date: 03/05/2024
  Time: 12:16 a. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <h1 class="text-center mb-4">Gestionando Grupos</h1>
    <div class="text-center mb-2">Administra y visualiza el mapeo de integrantes de los distintos grupos de las Áreas Funcionales.</div>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Área</th>
            <th>Nombre Grupo</th>
            <th>Jefe</th>
            <th>Acción</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>1</td>
            <td>Finanzas</td>
            <td>Empleados Finanz...</td>
            <td>José Aguilar</td>
            <td><button class="btn btn-primary">Editar</button></td>
        </tr>
        <tr>
            <td>2</td>
            <td>Comunicaciones</td>
            <td>Programadores pa...</td>
            <td>Rodrigo Carrasco</td>
            <td><button class="btn btn-primary">Editar</button></td>
        </tr>
        <tr>
            <td>3</td>
            <td>Finanzas</td>
            <td>Empleados Comu...</td>
            <td>María Alcano</td>
            <td><button class="btn btn-primary">Editar</button></td>
        </tr>
        <tr>
            <td>4</td>
            <td>Comunicaciones</td>
            <td>Programadores pa...</td>
            <td>Jotaro Gutierrez</td>
            <td><button class="btn btn-primary">Editar</button></td>
        </tr>
        </tbody>
    </table>
    <div class="d-flex justify-content-center">
        <button class="btn btn-secondary">Volver</button>
    </div>
</main>
</body>
</html>
