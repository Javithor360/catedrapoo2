<%--
  Created by IntelliJ IDEA.
  User: oscar
  Date: 5/10/2024
  Time: 5:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="../assets/js/bootstrap.min.js"></script>
    <title>Admin - Crear Nueva Área Funcional </title>
    <style>
        .form-select {
            display: block;
            width: 100%;
            padding: 0.375rem 2.25rem 0.375rem 0.75rem;
            font-size: 1rem;
            font-weight: 400;
            line-height: 1.5;
            color: #212529;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #ced4da;
            appearance: none;
            border-radius: 0.375rem;
            transition: border-color .15s ease-in-out, box-shadow .15s ease-in-out;
        }
    </style>
</head>
<body>

<jsp:include page="../navbar.jsp"/>

<main class="container mt-3">
    <h1 class="text-center mb-4">Creando Nueva Área Funcional</h1>
    <div class="text-center mb-2">Administra y visualiza el mapeo de integrantes de los distintos grupos de las Áreas
        Funcionales.
    </div>
    <form action="../adminController" method="POST">
        <input type="hidden" name="action" value="crearAreaFuncional">
        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="nombre" class="form-label">Nombre:</label>
                <input type="text" class="form-control" id="nombre" name="nombre">
            </div>
            <div class="col-md-6 mb-3">
                <label for="prefijo" class="form-label">Prefijo:</label>
                <input type="text" class="form-control" id="prefijo" name="prefijo">
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="jefeArea" class="form-label">Jefe de Área:</label>
                <select class="form-select" id="jefeArea" name="jefeArea">
                    <option selected>Sin jefes de área disponibles</option>
                </select>
            </div>
            <div class="col-md-6 mb-3">
                <label for="jefeDesarrollo" class="form-label">Jefe de Desarrollo:</label>
                <select class="form-select" id="jefeDesarrollo" name="jefeDesarrollo">
                    <option selected>Sin jefes de desarrollo disponibles</option>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="numGrupoEmpleados" class="form-label">Número de Grupo Empleados:</label>
                <input type="number" class="form-control" id="numGrupoEmpleados"
                       step="0" name="numGrupoEmpleados"  disabled value="5">
            </div>
            <div class="col-md-6 mb-3">
                <label for="numGrupoProgramadores" class="form-label">Número de Grupo Programadores:</label>
                <input type="number" class="form-control" id="numGrupoProgramadores"
                       step="0" disabled name="numGrupoProgramadores" value="6">
            </div>
        </div>

        <div class="">
            <a href="/admin/main.jsp" class="btn btn-secondary">Volver</a>
            <button type="submit" class="btn btn-primary">Crear</button>
        </div>
    </form>
</main>
</body>
</html>
