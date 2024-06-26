<%@ page import="com.ticket.catedrapoo2.beans.UserSession" %><%--
  Created by IntelliJ IDEA.
  User: flore
  Date: 9/4/2024
  Time: 22:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Comprobando si existe una sesión
    HttpSession currentSession = request.getSession(false);
    UserSession user = (UserSession) currentSession.getAttribute("user");

    // En caso de que haya un usuario definido, entonces según su rol redigirá a su panel correspondiente
    if(user != null) {

        if(user.getRole_id() == 1) {
            response.sendRedirect("dev_boss/main.jsp");
        } else if(user.getRole_id() == 2) {
            response.sendRedirect("developer/main.jsp");
        } else if(user.getRole_id() == 3) {
            response.sendRedirect("requester/main.jsp");
        } else if(user.getRole_id() == 4) {
            response.sendRedirect("tester/main.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }

        return;
    }
%>

<html>
<head>
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="assets/js/bootstrap.min.js"></script>
    <title>¡Bienvenido!</title>
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h3 class="text-center">Bienvenido</h3>
                </div>
                <div class="card-body">
                    <form action="session_handler" method="post" autocomplete="off">
                        <div class="form-group">
                            <label for="email">Correo</label>
                            <input type="text" class="form-control" value="admin" id="email" name="email" placeholder="Ingrese su usuario" autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label for="password">Contraseña</label>
                            <input type="password" class="form-control" value="superadmin" id="password" name="password" placeholder="Ingrese su contraseña" autocomplete="off">
                        </div>
                        <input type="hidden" name="operacion" value="login" />
                        <input type="submit" value="Iniciar sesión" class="btn btn-primary btn-block" />
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
