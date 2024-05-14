package com.ticket.catedrapoo2.controllers;

import com.ticket.catedrapoo2.beans.AreaBean;
import com.ticket.catedrapoo2.beans.GrupoBean;
import com.ticket.catedrapoo2.beans.UserGroupBean;
import com.ticket.catedrapoo2.beans.Users;
import com.ticket.catedrapoo2.models.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

@WebServlet(name = "AdminController", urlPatterns = {"/adminController"})
public class AdminController extends HttpServlet {

    // Instancia al Modelo
    Area area = new Area();
    Mapeo map = new Mapeo();
    UserGroup userGroup = new UserGroup();
    Grupo grupo = new Grupo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Determinar el tipo de contenido de la petición
        String contentType = request.getContentType();

        if (contentType != null && contentType.contains("application/json")) {
            handleJsonRequest(request, response);
        } else {
            handleFormRequest(request, response);
        }
    }

    private void handleJsonRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        StringBuilder jsonBuffer = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                jsonBuffer.append(line);
            }
        }

        JSONObject jsonObj = new JSONObject(jsonBuffer.toString());
        String action = jsonObj.getString("action");
        int userId = jsonObj.getInt("userId");
        int groupId = jsonObj.getInt("groupId");

        try {
            switch (action) {
                case "addToGroup":
                    addUserToGroup(userId, groupId, response);
                    break;
                case "deleteFromGroup":
                    deleteUserFromGroup(userId, groupId, response);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Operación no válida\"}");
                    break;
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error de base de datos: " + e.getMessage() + "\"}");
        }
    }

    private void addUserToGroup(int userId, int groupId, HttpServletResponse response) throws SQLException, IOException {
        // Aquí va la lógica para añadir el usuario al grupo
        // Suponemos que retorna un boolean
        boolean result = userGroup.addUserToGroup(new UserGroupBean(groupId, userId));
        response.setContentType("application/json");
        if (result) {
            response.getWriter().write("{\"success\": true, \"message\": \"Usuario añadido al grupo correctamente.\"}");
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"No se pudo añadir el usuario al grupo.\"}");
        }
    }

    private void deleteUserFromGroup(int userId, int groupId, HttpServletResponse response) throws SQLException, IOException {
        // Aquí va la lógica para eliminar el usuario del grupo
        boolean result = userGroup.deleteUserFromGroup(new UserGroupBean(groupId, userId));
        response.setContentType("application/json");
        if (result) {
            response.getWriter().write("{\"success\": true, \"message\": \"Usuario eliminado del grupo correctamente.\"}");
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"No se pudo eliminar el usuario del grupo.\"}");
        }
    }


    private void handleFormRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String operacion = request.getParameter("operacion");

        System.out.println("Operación: " + operacion);

        switch (operacion) {
            case "nuevoEmpleado":
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String birthdayString = request.getParameter("birthday");
                Date birthday = null;

                try {
                    //Dar formato a la fecha para guardar
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    birthday = dateFormat.parse(birthdayString);

                    //Se crea una instancia de Calendar y se establece con la fechaNac que llega
                    Calendar dob = Calendar.getInstance();
                    dob.setTime(birthday);

                    //Se establece otro objeto pero con la fecha del momento y se resta 18 años de la fecha actual
                    // para obtener la fecha que indica que una persona debe tener al menos 18 años.
                    Calendar today = Calendar.getInstance();
                    today.add(Calendar.YEAR, -18);
                    if (dob.after(today)) {
                        response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp?error=Error:+La+persona+debe+ser+mayor+de+edad");
                    }

                } catch (ParseException e) {
                    e.printStackTrace();
                }

                String password = request.getParameter("password");
                String gender = request.getParameter("gender");
                String rol = request.getParameter("rol");
                Date created = new Date(Calendar.getInstance().getTime().getTime());

                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                String createdString = dateFormat.format(created);

                AdminUsers operaciones = new AdminUsers();

                boolean res = operaciones.buscarCorreo(email);


                if (res){
                    response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp?error=Error:+el+correo+ya+esta+registrado");
                }else{
                    Users user = new Users(name, email, password, gender, birthday, rol, created);

                    boolean resultado = operaciones.agregarUsuario(user);

                    if (resultado) {
                        response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp?mensaje=Agregado+Correctamente");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp?error=Error+al+Crear");
                    }
                }

            break;

            case "eliminar":
                int id = Integer.parseInt(request.getParameter("id"));
                AdminUsers operacionesEliminar = new AdminUsers();
                boolean resp = operacionesEliminar.buscarUserId(id);
                if (resp){
                    response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp?error=Error:+El+empleado+esta+en+un+grupo");
                }else{
                    boolean resEliminar = operacionesEliminar.eliminarEmpleado(id);

                    if (resEliminar) {
                        response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp?mensaje=Exito:+Eliminado+correctamente");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp?error=Error:+Error+al+eliminar");
                    }
                }
                break;

            case "modificarEmpleado":
                int idModificar = Integer.parseInt(request.getParameter("id"));
                String nameModificar = request.getParameter("name");
                String emailModificar = request.getParameter("email");
                String birthdayStringModificar = request.getParameter("birthday");
                Date birthdayModificar = null;

                try {
                    SimpleDateFormat dateFormatModificar = new SimpleDateFormat("yyyy-MM-dd");
                    birthdayModificar = dateFormatModificar.parse(birthdayStringModificar);
                } catch (ParseException e) {
                    e.printStackTrace();
                }

                String genderModificar = request.getParameter("gender");
                String rolModificar = request.getParameter("rol");

                Users userModificar = new Users(idModificar, nameModificar, emailModificar, genderModificar,
                        birthdayModificar, rolModificar);
                AdminUsers operacionesModificar = new AdminUsers();

                boolean resModificar = operacionesModificar.actualizarEmpleado(userModificar);

                if (resModificar) {
                    response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp?mensaje=Exito:+Modificado+correctamente");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp?error=Error:+Error+al+modificar");
                }
                break;

            // Acciones de Areas ==================================================================================
            case "crearAreaFuncional":
                addArea(request, response);
                break;

            default:
                // Manejar la posibilidad de que no se pase una operación válida
                response.sendRedirect("errorPage.jsp");
                break;
        }
    }

    private void processRequest(final HttpServletRequest request, final HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");

        // Corroborando si se envió una acción y el modelo a utilizar
        String model = request.getParameter("model");
        String action = request.getParameter("action");

        if (model == null || action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Modelo o acción no especificados");
            return;
        }

        switch (model) {
            case "area":
                handleAreaActions(request, response, action);
                break;
            case "usergroup":
                handleGrupoActions(request, response, action);
                break;
        }
    }

    private void handleAreaActions(final HttpServletRequest request, final HttpServletResponse response, final String action)
            throws ServletException, IOException {
        switch (action) {
            case "index":
                displayAreas(request, response);
                break;
            case "create":
                // createArea(request, response);
                break;
            case "update":
                // updateArea(request, response);
                break;
            case "delete":
                // deleteArea(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
                break;
        }
    }

    private void handleGrupoActions(final HttpServletRequest request, final HttpServletResponse response, final String action)
            throws ServletException, IOException, SQLException {
        switch (action) {
            case "index":
                displayUsersGroups(request, response);
                break;
            case "create":
                // createGrupo(request, response);
                break;
            case "update":
                updateDetailsUsersGroup(request, response);
                break;
            case "delete":
                // deleteGrupo(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
                break;

        }
    }

    // Acciones de Áreas ==========================================================================================

    private void displayAreas(final HttpServletRequest request, final HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("areas", area.getAllAreas());
            request.getRequestDispatcher("/admin/areas.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void addArea(final HttpServletRequest request, final HttpServletResponse response) {
        // Obtener los datos del formulario enviado en la petición
        String name = request.getParameter("nombre");
        String prefix_code = request.getParameter("prefijo");
        int id_boss = Integer.parseInt(request.getParameter("jefeArea"));
        int id_dev_boss = Integer.parseInt(request.getParameter("jefeDesarrollo"));

        // Crear un nuevo objeto de Área con los datos obtenidos
        AreaBean newArea = new AreaBean(name, prefix_code, id_boss, id_dev_boss);

        try {
            // Se envía el nuevo objeto al modelo para ser insertado en la base de datos
            area.addArea(newArea);
            // Se redirige a la ruta del Controlador de Áreas, con su respectivo mensaje
            response.sendRedirect(request.getContextPath() + "/adminController?model=area&action=index");
        } catch (IOException | SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // Acciones de Grupos ==========================================================================================
    private void displayUsersGroups(final HttpServletRequest request, final HttpServletResponse response)
            throws SQLException {

        try {
            request.setAttribute("grupos", map.getAllMapeos());
            request.getRequestDispatcher("/admin/grupos.jsp").forward(request, response);

        } catch (ServletException | IOException e) {
            throw new RuntimeException(e);
        }
    }

    private void updateDetailsUsersGroup(final HttpServletRequest request, final HttpServletResponse response) throws SQLException {
        // Obtener el ID del grupo a modificar
        int id = Integer.parseInt(request.getParameter("id"));

        try {

            GrupoBean grupoObtenido = grupo.getGrupoById(id);

            // Verificar si el grupo existe
            if (grupoObtenido == null) {
                response.sendRedirect(request.getContextPath() + "/grupos.jsp");
                return;
            }

            // Obtener el tipo de grupo
            String type = grupoObtenido.getName().split(" ")[0];

            request.setAttribute("grupo", grupoObtenido);
            request.setAttribute("miembros", userGroup.getUserFromGroup(id));
            request.setAttribute("usuarios", userGroup.getUsersWithoutGroup(type));

            for (Users miembro : userGroup.getUserFromGroup(id).values()) {
                System.out.println("Miembro: " + miembro.getName());
            }

            request.getRequestDispatcher("/admin/grupo.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            throw new RuntimeException(e);
        }

    }

}
