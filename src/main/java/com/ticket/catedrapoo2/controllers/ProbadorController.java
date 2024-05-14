package com.ticket.catedrapoo2.controllers;


import com.ticket.catedrapoo2.beans.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet(name = "ProbadorController", urlPatterns = {"/pbc"})

public class ProbadorController extends HttpServlet {
    ProbadorBean pbc = new ProbadorBean();

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
                case "reject_ticket":
                    rejectTicketLog(request, response, Integer.parseInt(request.getParameter("ticket_id")));
                    break;
                case "accept_ticket":
                    acceptTicket(request, response, user.getId(), Integer.parseInt(request.getParameter("id")));
                    break;
            }
        }
    }

    private void displayTickets(final HttpServletRequest request, final HttpServletResponse response, final int tester_id) throws ServletException, IOException {
        try {
            request.setAttribute("tickets", pbc.fetchTickets(tester_id)); // Se obtienen los tickets asignados al probador y se guardan en un atributo de la petición
            request.getRequestDispatcher("/tester/main.jsp").forward(request, response); // Se redirige a la vista principal del probador
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void displayTicketById(final HttpServletRequest request, final HttpServletResponse response, final int ticket_id) throws ServletException, IOException {
        try {
            request.setAttribute("ticket", pbc.fetchTicketById(ticket_id)); // Se obtiene el ticket por su id y se guarda en un atributo de la petición
            request.getRequestDispatcher("/tester/detail.jsp?id=" + ticket_id).forward(request, response); // Se redirige a la vista de detalle del ticket
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void rejectTicketLog(final HttpServletRequest request, final HttpServletResponse response, final int ticket_id) throws IOException {
        try {
            // Se obtienen los datos del formulario
            String ticket_code = request.getParameter("code");
            String log_desc = request.getParameter("description");
            int tester_id = Integer.parseInt(request.getParameter("tester_id"));

            String newDate = request.getParameter("newDate");

            pbc.rejectLog(ticket_code, "PROYECTO RECHAZADO", log_desc, 0.0F, tester_id); // Se crea un nuevo log desde el Bean
            pbc.updateStateTicket(6 ,ticket_id, tester_id); // Se envía el ticket al Bean para que lo marque como devuelto con observaciones
            pbc.updateDateTicket(newDate, ticket_id); // Se actualiza la fecha de entrega al ticket
            response.sendRedirect("/tester/detail.jsp?id=" + ticket_id + "&info=success_reject_log"); // Se redirige a la vista de detalle del ticket con un mensaje de éxito
        } catch (SQLException e) {
            response.sendRedirect("/tester/detail.jsp?id=" + ticket_id + "&info=error_reject_log"); // Se redirige a la vista de detalle del ticket con un mensaje de error
        }
    }

    private void acceptTicket(final HttpServletRequest request, final HttpServletResponse response, final int tester_id, final int ticket_id) throws IOException {
        try {
            pbc.updateStateTicket(7,ticket_id, tester_id); // Se envía el ticket al Bean para que lo marque como finalizado
            response.sendRedirect("/tester/detail.jsp?id=" + ticket_id + "&info=success_accept_ticket"); // Se redirige a la vista de detalle del ticket con un mensaje de éxito
        } catch (SQLException e) {
            response.sendRedirect("/tester/detail.jsp?id=" + request.getParameter("id") + "&info=error_accept_ticket"); // Se redirige a la vista de detalle del ticket con un mensaje de error
        }
    }
}
