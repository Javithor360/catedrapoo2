package com.ticket.catedrapoo2.controllers;

import com.ticket.catedrapoo2.beans.AreaBean;
import com.ticket.catedrapoo2.beans.UserSession;
import com.ticket.catedrapoo2.beans.Users;
import com.ticket.catedrapoo2.models.AdminUsers;
import com.ticket.catedrapoo2.models.Area;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

@WebServlet(name = "AdminController", value = "/adminController")
public class AdminController extends HttpServlet {

    // Instancia al Modelo
    Area area = new Area();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
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

            Users user = new Users(name,email,password,gender,birthday,rol,created);

            AdminUsers operaciones = new AdminUsers();
            boolean resultado = operaciones.agregarUsuario(user);

            if (resultado) {
                request.setAttribute("mensaje", "Agregado correctamente");
            } else {
                request.setAttribute("Error", "Error al Crear");
            }

            response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp");

        }else if ("eliminar".equals(operacion)){
            int id = Integer.parseInt(request.getParameter("id"));

            AdminUsers operaciones = new AdminUsers();

            boolean res = operaciones.eliminarEmpleado(id);

            if (res) {
                request.setAttribute("mensaje", "Eliminado correctamente");
            } else {
                request.setAttribute("Error!", "Error al eliminar");
            }

            response.sendRedirect(request.getContextPath() + "/admin/menuEmpleado.jsp");

        }else if ("modificarEmpleado".equals(operacion)){
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

            Users user = new Users(id, name, email,gender, birthday,rol);

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

    private void processRequest(final HttpServletRequest request, final HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            // Corroborando si se envió una acción
            if(request.getParameter("action") == null) {
                return;
            }

            HttpSession currentSession = request.getSession(false);
            UserSession user = (UserSession) currentSession.getAttribute("user");

            // Capturando el valor de la acción
            String action = request.getParameter("action");

            // En base a la acción se ejecuta un método u otro
            switch (action) {
                case "display_new_tickets":
                    //displayNewTickets(request, response, user.getId());
                    break;
                case "display_all_tickets":
                    //displayAllTickets(request, response, user.getId());
                    break;
                case "accept_ticket":
                    //acceptTicket(request, response, user.getId());
                    break;
                case "deny_ticket":
                    //denyTicket(request, response, user.getId());
                    break;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // Obtener todas las areas funcionales
    public HashMap<String, AreaBean> fetchAreas() {
        return new HashMap<String, AreaBean>();
    }

}
