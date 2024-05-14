package com.ticket.catedrapoo2.controllers;

import com.ticket.catedrapoo2.beans.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import static com.ticket.catedrapoo2.beans.TicketModel.createTicket;

@WebServlet(name = "JefeAreaController", urlPatterns = {"/rqc"})
public class JefeAreaController extends HttpServlet {
    JefeAreaBean rqc = new JefeAreaBean();

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
                case "display_tickets":
                    displayTickets(request, response, user.getId());
                    break;
                case "display_ticket":
                    displayTicketById(request, response, Integer.parseInt(request.getParameter("id")));
                    break;
                case "create_ticket":
                    createNewTicket(request, response, user.getId());
                    break;
            }
        }
    }

    private void displayTickets(final HttpServletRequest request, final HttpServletResponse response, final int tester_id) throws ServletException, IOException {
        try {
            request.setAttribute("tickets", rqc.fetchTickets(tester_id)); // Se obtienen los tickets asignados del área y se guardan en un atributo de la petición
            request.getRequestDispatcher("/requester/main.jsp").forward(request, response); // Se redirige a la vista principal del jefe de área
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void displayTicketById(final HttpServletRequest request, final HttpServletResponse response, final int ticket_id) throws ServletException, IOException {
        try {
            request.setAttribute("ticket", rqc.fetchTicketById(ticket_id)); // Se obtiene el ticket por su id y se guarda en un atributo de la petición
            request.getRequestDispatcher("/requester/detail.jsp?id=" + ticket_id).forward(request, response); // Se redirige a la vista de detalle del ticket
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void createNewTicket(final HttpServletRequest request, final HttpServletResponse response, final int user_id) throws ServletException, IOException {
        try {
            // Se obtienen los datos del formulario
            String ticket_title = request.getParameter("title");
            String ticket_desc = request.getParameter("description");

            createTicket(user_id, ticket_title, ticket_desc); // Creación de un nuevo ticket

            response.sendRedirect("/requester/main.jsp?info=success_create_ticket"); // Se redirige a la vista principal con un mensaje de éxito si logra guardar el dato
        } catch (SQLException e) {
            response.sendRedirect("/requester/main.jsp?info=error_create_ticket"); // Ha ocurrido un error al crear el nuevo ticket
        }
    }
}
