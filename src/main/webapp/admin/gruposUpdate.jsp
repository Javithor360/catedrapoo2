<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %>
<%@ page import="com.ticket.catedrapoo2.beans.Users" %>
<%@ page import="java.util.HashMap" %><%--
  Created by IntelliJ IDEA.
  User: oscar
  Date: 5/10/2024
  Time: 5:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Validar si el usuario tiene permisos para acceder a esta página
    HttpSession currentSesion = request.getSession(false);
    UserSession user = (UserSession) currentSesion.getAttribute("user");

    if (user == null || user.getRole_id() != 0) {
        response.sendRedirect("/login.jsp");
        return;
    }

    String groupId = request.getParameter("id");

    // Validar que el id del grupo sea un número
    if (groupId == null || groupId.isEmpty() || !groupId.matches("\\d+")) {
        response.sendRedirect("./grupos.jsp");
        return;
    }
%>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="../assets/js/bootstrap.min.js"></script>
    <title>Admin - Asigna o Remueve Integrantes</title>
</head>
<body>

<jsp:include page="../navbar.jsp"/>

<main class="container mt-3">

    <h1 class="text-center mb-4">Grupo N°
        <%=
        groupId
        %>
        Empleados - #
    </h1>
    <div class="text-center mb-2">Asigna o Remueve Integrantes del Grupo</div>

    <div class="row">

        <div class="col">
            <h4 class="">Pertenecientes al Grupo</h4>
            <ul class="list-group" id="groupMembers">
                <li class="list-group-item" data-id="1">1</li>
                <li class="list-group-item" data-id="2">2</li>
            </ul>
        </div>

        <div class=" d-flex align-items-center flex-column justify-content-center">
            <span>➡️</span>
            <span>⬅️</span>
        </div>

        <div class="col">
            <h4 class="">Usuarios Disponibles</h4>
            <ul class="list-group" id="availableUsers">

                <li class="list-group-item" data-id="4">4</li>
                <%
                    HashMap<Integer, Users> usuarios = (HashMap<Integer, Users>) request.getAttribute("usuarios");

                    for (Users usuario : usuarios.values()) {
                %>
                <li class="list-group-item" data-id="<%= usuario.getId()%>">
                    <%= usuario.getName() %>
                </li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>

    <button class="btn btn-secondary mt-3" onclick="window.location='/admin/grupos.jsp'">
        Volver
    </button>

    <script>
        (() => {
            // Elementos de la lista de usuarios disponibles del DOM
            const availablesList = document.getElementById('availableUsers');
            const groupMembersList = document.getElementById('groupMembers');

            // Objetos Globales
            let groupMembers = [1, 2];
            let availableGroup = [3, 4];

            availablesList.addEventListener('click', e => {
                handleListClick(e, availableGroup, groupMembers, availablesList, groupMembersList);
            })

            groupMembersList.addEventListener('click', e => {
                handleListClick(e, groupMembers, availableGroup, groupMembersList, availablesList);
            })

            function handleListClick(e, fromList, toList, fromElement, toElement) {
                let {id} = e.target.dataset;

                if (id) {

                    // Válidar que el grupo de miembros no esté vacío
                    if (fromList === groupMembers && fromList.length === 1) {
                        alert('El Grupo debe mantener al menos un integrante');
                        return;
                    }
                    ;

                    moveItem(+id, fromList, toList);
                    clearAndReprintList(fromList, fromElement);
                    clearAndReprintList(toList, toElement);
                }
            }

            function moveItem(id, fromList, toList) {
                let index = fromList.indexOf(id);

                if (index !== -1) {
                    fromList.splice(index, 1);
                    toList.push(id);
                }
            }

            // Limpiar y reimprimir una lista en el HTML
            function clearAndReprintList(list, element) {
                clearHTML(element);

                if (list.length === 0 && element === availableUsers) {
                    let li = document.createElement('li');
                    li.classList.add('list-group-item');
                    li.textContent = 'No hay usuarios disponibles';
                    element.appendChild(li);
                } else {
                    list.forEach(id => printListItem(id, element));
                }
            }

            // Limpiar elementos del HTML
            function clearHTML(element) {
                while (element.firstChild) {
                    element.removeChild(element.firstChild);
                }
            }

            // Imprimir un item en la lista del HTML
            function printListItem(id, element) {
                const item = document.createElement('li');
                item.classList.add('list-group-item');
                item.dataset.id = id;
                item.innerText = id;
                element.appendChild(item);
            }
        })()
    </script>
</main>
</body>
</html>
