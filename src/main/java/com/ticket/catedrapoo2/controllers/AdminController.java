package com.ticket.catedrapoo2.controllers;

import com.ticket.catedrapoo2.beans.UserGroupBean;
import com.ticket.catedrapoo2.beans.Users;
import com.ticket.catedrapoo2.models.AdminUsers;
import com.ticket.catedrapoo2.models.Area;
import com.ticket.catedrapoo2.models.Mapeo;
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

@WebServlet(name = "AdminController", value = "/adminController")
public class AdminController extends HttpServlet {

    // Instancia al Modelo
    Area area = new Area();
    Mapeo map = new Mapeo();
//    UserGroupBean = new UserGroups();
    // Grupo grupo = new Grupo();

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

        if ("nuevoEmpleado".equals(operacion)) {
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

        } else if ("eliminar".equals(operacion)) {
            int id = Integer.parseInt(request.getParameter("id"));

            AdminUsers operaciones = new AdminUsers();

            boolean res = operaciones.eliminarEmpleado(id);

            if (res) {
                request.setAttribute("mensaje", "Eliminado correctamente");
            } else {
                request.setAttribute("Error!", "Error al eliminar");
            }

            response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp");

        } else if ("modificarEmpleado".equals(operacion)) {
            int id = Integer.parseInt(request.getParameter("id"));
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
            String gender = request.getParameter("gender");
            String rol = request.getParameter("rol");

            Users user = new Users(id, name, email, gender, birthday, rol);

            AdminUsers operaciones = new AdminUsers();

            boolean res = operaciones.actualizarEmpleado(user);

            if (res) {
                request.setAttribute("mensaje", "Modificado correctamente");
            } else {
                request.setAttribute("Error", "Error al modificar");
            }

            response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp");
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
                // updateGrupo(request, response);
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

}
