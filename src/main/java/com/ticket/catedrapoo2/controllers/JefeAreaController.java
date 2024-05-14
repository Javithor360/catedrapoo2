package com.ticket.catedrapoo2.controllers;

import com.ticket.catedrapoo2.beans.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import static com.ticket.catedrapoo2.beans.TicketModel.createTicket;
import static com.ticket.catedrapoo2.beans.TicketModel.generateNewCode;

@WebServlet(name = "JefeAreaController", urlPatterns = {"/rqc"})
@MultipartConfig // Config necesaria para recibir los datos de un formulario enctype='multipart/form-data'
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
            String code = generateNewCode(user_id);

            // Manejando el archivo adjunto
            Part filePart = request.getPart("file"); // Solicitando el archivo a tratar
            String fileName = "";
            if (filePart != null && filePart.getSize() > 0) { // Verificando la existencia del archivo
                fileName = code+".pdf";
                String storagePath = getServletContext().getRealPath("/storage");

                // Verificar si el directorio "storage" existe
                File storageDir = new File(storagePath);
                if (!storageDir.exists()) {
                    // Si no existe, intenta crearlo
                    if (!storageDir.mkdir()) {
                        // Si no se puede crear el directorio, maneja el error
                        throw new IOException("No se pudo crear el directorio de almacenamiento");
                    }
                }

                // Construir la ruta completa para guardar el archivo
                String pathToSave = storagePath + File.separator + fileName;

                // Escribir el archivo en el disco
                filePart.write(pathToSave);
            }
            System.out.println("Salimos de todo chavales");
            createTicket(user_id, ticket_title, ticket_desc, code, fileName); // Creación de un nuevo ticket
            System.out.println("Hay ticket chavales");

            response.sendRedirect("/requester/main.jsp?info=success_create_ticket"); // Se redirige a la vista principal con un mensaje de éxito si logra guardar el dato
        } catch (SQLException e) {
            response.sendRedirect("/requester/main.jsp?info=error_create_ticket"); // Ha ocurrido un error al crear el nuevo ticket
        }
    }
}
