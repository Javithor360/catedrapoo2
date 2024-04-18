package com.ticket.catedrapoo2.controllers;

import com.ticket.catedrapoo2.beans.UserSession;
import com.ticket.catedrapoo2.models.JefeDesarrolloModel;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet(name = "JefeDesarrolloController", urlPatterns = {"/jdc"})
public class JefeDesarrolloController extends HttpServlet {
    JefeDesarrolloModel jdm = new JefeDesarrolloModel();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
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
                    displayNewTickets(request, response, user.getId());
                    break;
                case "display_new_ticket_info":
                    break;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void displayNewTickets(final HttpServletRequest request, final HttpServletResponse response, final int dev_boss_id) throws SQLException {
        try {
            // Creando un atributo donde su contenido será el resultado devuelto por el modelo
            request.setAttribute("new_tickets", jdm.fetchNewTickets(dev_boss_id));
            // Redirigiendo a la vista correspondiente para mostrar los datos en pantalla
            request.getRequestDispatcher("/dev_boss/main.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            throw new RuntimeException(e);
        }
    }
}