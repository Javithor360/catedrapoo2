<%@ page import="com.ticket.catedrapoo2.beans.Users" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.ticket.catedrapoo2.models.Area" %>
<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>
<%@ page import="com.ticket.catedrapoo2.models.Grupo" %><%--
  Created by IntelliJ IDEA.
  User: oscar
  Date: 5/10/2024
  Time: 5:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Válidar si el usuario tiene permisos para acceder a la página
    HttpSession currentSession = request.getSession(false);
    UserSession user = (UserSession) currentSession.getAttribute("user");

    if (user == null || user.getRole_id() != 0) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

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

    <form action="../adminController" method="POST" id="createArea">
        <input type="hidden" name="operacion" value="crearAreaFuncional">
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
                    <option selected disabled value="0">-- Seleccione un Jefe de Área --</option>
                    <%
                        List<Users> jefesArea = null;
                        int numGrupoEmpleados = (Grupo.countGrupos() + 1);
                        int numGrupoDev = (Grupo.countGrupos() + 2);

                        try {
                            jefesArea = Users.listarUsuariosPorRol("3");
                            for (Users jefeArea : jefesArea) {
                    %>
                    <option value="<%= jefeArea.getId() %>"><%= jefeArea.getName() %>
                    </option>
                    <%
                            }
                        } catch (SQLException throwables) {
                            throwables.printStackTrace();
                        }
                    %>
                </select>
            </div>
            <div class="col-md-6 mb-3">
                <label for="jefeDesarrollo" class="form-label">Jefe de Desarrollo:</label>
                <select class="form-select" id="jefeDesarrollo" name="jefeDesarrollo">
                    <option selected disabled value="0">-- Seleccione un Jefe de Desarrollo --</option>
                    <%
                        List<Users> jefesDesarrollo = null;
                        try {
                            jefesDesarrollo = Users.listarUsuariosPorRol("1");
                            for (Users jefeDev : jefesDesarrollo) {
                    %>
                    <option value="<%= jefeDev.getId() %>"><%= jefeDev.getName() %>
                    </option>
                    <%
                            }
                        } catch (SQLException throwables) {
                            throwables.printStackTrace();
                        }
                    %>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="numGrupoEmpleados" class="form-label">ID Grupo Empleados:</label>
                <input type="number" class="form-control" id="numGrupoEmpleados"
                       step="0" name="numGrupoEmpleados" disabled value="<%= numGrupoEmpleados%>">
            </div>
            <div class="col-md-6 mb-3">
                <label for="numGrupoProgramadores" class="form-label">ID Grupo Programadores:</label>
                <input type="number" class="form-control" id="numGrupoProgramadores"
                       step="0" name="numGrupoProgramadores" disabled value="<%= numGrupoDev%>">
            </div>
        </div>

        <div>
            <a href="/admin/main.jsp" class="btn btn-secondary">Volver</a>
            <button type="submit" class="btn btn-primary" disabled>Crear</button>
        </div>
    </form>
</main>
<script>
    (() => {
        const form = document.querySelector('#createArea');
        const inputs = form.querySelectorAll('input, select');
        const inputPrefix = form.querySelector('#prefijo');
        const submitButton = form.querySelector('button[type="submit"]');

        // Función para validar campos generales
        function validateForm() {
            let camposCompletos = true;
            inputs.forEach(input => {
                if (input.value.trim() === '' && !input.disabled) {
                    camposCompletos = false;
                }
            });

            // Validar que los select tengan un value diferente de 0
            const selects = form.querySelectorAll('select');
            selects.forEach(select => {
                if (select.value === '0') {
                    camposCompletos = false;
                }
            });

            submitButton.disabled = !camposCompletos || !validarPrefijo();
        }

        // Función para validar el prefijo con retorno de estado
        function validarPrefijo() {
            const regex = /^[a-zA-Z]{3}$/;
            if (!regex.test(inputPrefix.value)) {
                inputPrefix.setCustomValidity('El prefijo debe tener 3 letras.');
                inputPrefix.reportValidity();
                return false;
            } else {
                inputPrefix.setCustomValidity('');
                return true;
            }
        }

        // Añadir listeners para cada campo para validar en tiempo real
        inputs.forEach(input => {
            if (['select', 'text', 'email'].includes(input.tagName.toLowerCase()) || input.type === 'text' || input.type === 'email') {
                input.addEventListener('input', validateForm);
            }
        });

        // Añadir listener específico para la validación del prefijo
        inputPrefix.addEventListener('input', () => {
            validarPrefijo();
            validateForm();
        });

        // Añadir listener al formulario para validar antes del envío
        form.addEventListener('submit', function(event) {
            if (submitButton.disabled) {
                event.preventDefault(); // Detener el envío si hay algún problema
                alert('Por favor, completa todos los campos correctamente antes de enviar.');
            }
        });
    })();

</script>
</body>
</html>
