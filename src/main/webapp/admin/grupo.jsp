<%@ page import="com.ticket.catedrapoo2.beans.Users" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.ticket.catedrapoo2.beans.GrupoBean" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %><%--
  Created by IntelliJ IDEA.
  User: oscar
  Date: 5/12/2024
  Time: 12:31 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    GrupoBean group = (GrupoBean) request.getAttribute("grupo");

    if (group == null) {
        response.sendRedirect("/admin/grupos.jsp");
        return;
    }

    int groupId = group.getId();
    String groupName = group.getName();
    String typeGroup = group.getName().split(" ")[0];
    HashMap<Integer, Users> miembros = (HashMap<Integer, Users>) request.getAttribute("miembros");
    HashMap<Integer, Users> usuarios = (HashMap<Integer, Users>) request.getAttribute("usuarios");
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
        groupId + " " + groupName
        %>
    </h1>
    <h2>
        <%= typeGroup %>
    </h2>
    <div class="text-center mb-2">Asigna o Remueve Integrantes del Grupo</div>

    <div class="row">

        <div class="col">
            <h4 class="">Pertenecientes al Grupo</h4>
            <ul class="list-group" id="groupMembers">
                <%
                    for (Users miembro : miembros.values()) {
                %>
                <li class="list-group-item" data-id="<%= miembro.getId()%>">
                    <%= miembro.getName() %>
                </li>
                <%
                    }
                %>
            </ul>
        </div>

        <div class=" d-flex align-items-center flex-column justify-content-center">
            <span>➡️</span>
            <span>⬅️</span>
        </div>

        <div class="col">
            <h4 class="">Usuarios Disponibles</h4>
            <ul class="list-group" id="availableUsers">
                <%
                    if (usuarios.isEmpty()) {
                %>
                <li class="list-group-item">No hay usuarios disponibles</li>
                <%
                } else {
                    for (Users usuario : usuarios.values()) {
                %>
                <li class="list-group-item" data-id="<%= usuario.getId()%>">
                    <%= usuario.getName() %>
                </li>
                <%
                        }
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
            let groupMembers = [<% if (!miembros.isEmpty()) {
                int count = 0; // Para controlar la última coma en la iteración
                for (Users miembro : miembros.values()) {
                    if (count > 0){ %>
                ,// Imprimir una coma antes de cada objeto excepto el primero
                <%}
            %>
                {
                    id: <%= miembro.getId() %>,
                    name: "<%= miembro.getName() %>"
                }
                <% count++;
            }
        } %>
            ];

            let availableGroup = [<% if (!usuarios.isEmpty()) {
                int count = 0; // Para controlar la última coma en la iteración
                for (Users usuario : usuarios.values()) {
                    if (count > 0){ %>
                , // Imprimir una coma antes de cada objeto excepto el primero
                <%}
            %>
                {
                    id: <%= usuario.getId() %>,
                    name: "<%= usuario.getName() %>"
                }
                <% count++;
            }
        }
        %>
            ];

            console.log(groupMembers);
            console.log(availableGroup);

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

                    moveItem(+id, fromList, toList);
                    clearAndReprintList(fromList, fromElement);
                    clearAndReprintList(toList, toElement);
                }
            }

            function moveItem(id, fromList, toList) {
                const index = fromList.findIndex(item => item.id === id); // Encontrar el índice del objeto en la lista
                if (index !== -1) {
                    const [itemMoved] = fromList.splice(index, 1); // Extraer el elemento como objeto

                    // Determinar el tipo de acción según lista
                    const action = (fromList === groupMembers) ? 'deleteFromGroup' : 'addToGroup';
                    const groupId = <%= groupId %>;


                    updateUserGroup(itemMoved.id, groupId, action);
                    toList.push(itemMoved); // Añadir el objeto extraído
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
                    list.forEach(item => printListItem(item, element));
                }
            }

            // Limpiar elementos del HTML
            function clearHTML(element) {
                while (element.firstChild) {
                    element.removeChild(element.firstChild);
                }
            }

            // Imprimir un item en la lista del HTML
            function printListItem(item, element) {
                const listItem = document.createElement('li');
                listItem.classList.add('list-group-item');
                listItem.dataset.id = item.id; // Usar propiedad del objeto
                listItem.innerText = item.name; // Usar propiedad del objeto
                element.appendChild(listItem);
            }

            function updateUserGroup(userId, groupId, action) {
                fetch(`/adminController`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        userId: userId,
                        groupId: groupId,
                        action: action
                    })
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Usuario actualizado con éxito');
                        } else {
                            alert('Error al actualizar usuario: ' + data.error);
                        }
                    })
                    .catch(error => {
                        alert('Error al actualizar usuario: ' + error);
                    });
            }
        })()
    </script>
</main>
</body>
</html>
