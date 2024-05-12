package com.ticket.catedrapoo2.controllers;

import com.ticket.catedrapoo2.beans.AreaBean;
import com.ticket.catedrapoo2.beans.UserGroupBean;
import com.ticket.catedrapoo2.beans.Users;
import com.ticket.catedrapoo2.models.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String operacion = request.getParameter("operacion");

        System.out.println("Operación: " + operacion);

        switch (operacion) {
            case "nuevoEmpleado":
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String birthdayString = request.getParameter("birthday");
                Date birthday = null;

                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    birthday = dateFormat.parse(birthdayString);
                } catch (ParseException e) {
                    e.printStackTrace();
                }

                String password = request.getParameter("password");
                String gender = request.getParameter("gender");
                String rol = request.getParameter("rol");
                Date created = new Date(Calendar.getInstance().getTime().getTime());

                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                String createdString = dateFormat.format(created);

                Users user = new Users(name, email, password, gender, birthday, rol, created);
                AdminUsers operaciones = new AdminUsers();
                boolean resultado = operaciones.agregarUsuario(user);

                if (resultado) {
                    request.setAttribute("mensaje", "Agregado correctamente");
                } else {
                    request.setAttribute("Error", "Error al Crear");
                }

                response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp");
                break;

            case "eliminar":
                int id = Integer.parseInt(request.getParameter("id"));
                AdminUsers operacionesEliminar = new AdminUsers();
                boolean resEliminar = operacionesEliminar.eliminarEmpleado(id);

                if (resEliminar) {
                    request.setAttribute("mensaje", "Eliminado correctamente");
                } else {
                    request.setAttribute("Error!", "Error al eliminar");
                }

                response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp");
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
                    request.setAttribute("mensaje", "Modificado correctamente");
                } else {
                    request.setAttribute("Error", "Error al modificar");
                }

                response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp");
                break;

            // Acciones de Areas ==================================================================================
            case "crearAreaFuncional":
                addArea(request, response);
                break;

            case "addToGroup":
                addUserToGroup(request, response);
                break;

            case "deleteFromGroup":
                deleteUserFromGroup(request, response);
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

        System.out.println("ID del grupo: " + id);

        try {
            // Verificar si el grupo existe
            if (grupo.getGrupoById(id) == null) {
                response.sendRedirect(request.getContextPath() + "/grupos.jsp");
                return;
            }

            request.setAttribute("grupo", grupo.getGrupoById(id));
            request.setAttribute("usuarios", userGroup.getUserFromGroup(id));

            // request.setAttribute("usuarios", map.getUsersFrom());
            request.getRequestDispatcher("/admin/gruposUpdate.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            throw new RuntimeException(e);
        }

    }

    private void addUserToGroup(final HttpServletRequest request, final HttpServletResponse response) {
        // Obtener los datos del formulario enviado en la petición
        int id_user = Integer.parseInt(request.getParameter("id_user"));
        int id_group = Integer.parseInt(request.getParameter("id_group"));

        // Crear un nuevo objeto de Mapeo con los datos obtenidos
//        UserGroupBean newUserGroup = new UserGroupBean(id_user, id_group);
//
//        try {
//            // Se envía el nuevo objeto al modelo para ser insertado en la base de datos
//            map.addUserToGroup(newUserGroup);
//            // Se redirige a la ruta del Controlador de Grupos, con su respectivo mensaje
//            response.sendRedirect(request.getContextPath() + "/adminController?model=usergroup&action=index");
//        } catch (IOException | SQLException e) {
//            throw new RuntimeException(e);
//        }
    }

    private void deleteUserFromGroup(final HttpServletRequest request, final HttpServletResponse response) {
        // Obtener los datos del formulario enviado en la petición
        int id_user = Integer.parseInt(request.getParameter("id_user"));
        int id_group = Integer.parseInt(request.getParameter("id_group"));

        // Crear un nuevo objeto de Mapeo con los datos obtenidos
//        UserGroupBean userGroup = new UserGroupBean(id_user, id_group);
//
//        try {
//            // Se envía el nuevo objeto al modelo para ser insertado en la base de datos
//            map.deleteUserFromGroup(userGroup);
//            // Se redirige a la ruta del Controlador de Grupos, con su respectivo mensaje
//            response.sendRedirect(request.getContextPath() + "/adminController?model=usergroup&action=index");
//        } catch (IOException | SQLException e) {
//            throw new RuntimeException(e);
//        }
    }

}
