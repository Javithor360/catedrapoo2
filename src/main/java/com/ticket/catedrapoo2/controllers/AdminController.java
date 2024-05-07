package com.ticket.catedrapoo2.controllers;

import com.ticket.catedrapoo2.beans.AreaBean;
import com.ticket.catedrapoo2.beans.UserSession;
import com.ticket.catedrapoo2.models.Area;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;

@WebServlet(name = "AdminController", urlPatterns = {"/admin"})
public class AdminController extends HttpServlet {

    // Instancia al Modelo
    Area area = new Area();

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
