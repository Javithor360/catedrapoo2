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
    <title>Admin - Asigna o Remueve Integrantes </title>
</head>
<body>

<%--<jsp:include page="../navbar.jsp"/>--%>

<main class="container mt-3">

    <h1 class="text-center mb-4">Grupo N° * Empleados - #</h1>
    <div class="text-center mb-2">Asigna o Remueve Integrantes del Grupo</div>

    <div class="row">
        <div class="col">
            <h4>Usuarios Disponibles</h4>
            <ul class="list-group" id="availableUsers">
                <!-- Dynamically filled by JavaScript -->
            </ul>
        </div>
        <div class="col-1 d-flex align-items-center flex-column">
            <button class="btn btn-primary mb-2" onclick="moveToGroup()">➡️</button>
            <button class="btn btn-primary" onclick="removeFromGroup()">⬅️</button>
        </div>
        <div class="col">
            <h4>Pertenecientes al Grupo</h4>
            <ul class="list-group" id="groupMembers">
                <!-- Dynamically filled by JavaScript -->
            </ul>
        </div>
    </div>
    <button class="btn btn-secondary mt-3" onclick="window.location='/admin/main.jsp'">Salir</button>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Example data - fetch these from your server or define them here
            let availableUsers = [
                { id: '1', name: 'Usuario Uno', email: 'email1@correo.com' },
                { id: '3', name: 'Usuario Tres', email: 'email3@correo.com' }
            ];
            let groupMembers = [
                { id: '2', name: 'Helena Valladares', email: 'helena.valladares@correo.com' },
                { id: '6', name: 'Fernanda Murillo', email: 'fernanda.murillo@correo.com' }
            ];

            function populateList(list, data) {
                let html = data.map(user =>
                    `<li class="list-group-item" data-id="${user.id}">${user.name} - ${user.email}</li>`
                ).join('');
                document.getElementById(list).innerHTML = html;
            }

            populateList('availableUsers', availableUsers);
            populateList('groupMembers', groupMembers);

            window.moveToGroup = function() {
                let selected = document.querySelector('#availableUsers .list-group-item.active');
                if (selected) {
                    groupMembers.push({
                        id: selected.dataset.id,
                        name: selected.textContent.split(' - ')[0],
                        email: selected.textContent.split(' - ')[1]
                    });
                    availableUsers = availableUsers.filter(user => user.id !== selected.dataset.id);
                    populateList('availableUsers', availableUsers);
                    populateList('groupMembers', groupMembers);
                }
            };

            window.removeFromGroup = function() {
                let selected = document.querySelector('#groupMembers .list-group-item.active');
                if (selected) {
                    availableUsers.push({
                        id: selected.dataset.id,
                        name: selected.textContent.split(' - ')[0],
                        email: selected.textContent.split(' - ')[1]
                    });
                    groupMembers = groupMembers.filter(user => user.id !== selected.dataset.id);
                    populateList('availableUsers', availableUsers);
                    populateList('groupMembers', groupMembers);
                }
            };
        });
    </script>
</main>
</body>
</html>
