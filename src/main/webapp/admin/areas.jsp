<%--
  Created by IntelliJ IDEA.
  User: oscar
  Date: 03/05/2024
  Time: 12:15 a. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <tr>
            <td>FIN</td>
            <td>Finanzas</td>
            <td>María Alcano</td>
            <td>José Aguilar</td>
        </tr>
        <tr>
            <td>CMC</td>
            <td>Comunicaciones</td>
            <td>Jotaro Gutierrez</td>
            <td>Rodrigo Carrasco</td>
        </tr>
        </tbody>
    </table>

    <div class="d-flex justify-content-center">
        <button class="btn btn-primary">Agregar</button>
        <button class="btn btn-secondary">Salir</button>
    </div>

</main>
</body>
</html>
