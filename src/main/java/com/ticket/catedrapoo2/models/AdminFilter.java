package com.ticket.catedrapoo2.models;

import com.ticket.catedrapoo2.beans.Bitacora;
import com.ticket.catedrapoo2.beans.Conexion;
import com.ticket.catedrapoo2.beans.Ticket;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

public class AdminFilter {

    public HashMap<String, Ticket> filtered_tickets(int status, String start_date, String finish_date) {
        HashMap<String, Ticket> tickets = new HashMap<>();
        Conexion conexion = null;

        try {
            conexion = new Conexion();

            String sql = "SELECT " +
                    "t.id AS ticket_id, " +
                    "t.code AS ticket_code, " +
                    "t.name AS ticket_name, " +
                    "t.description AS ticket_description, " +
                    "t.pdf AS ticket_pdf, " +
                    "s.name AS state, " +
                    "t.state_id, " +
                    "o.description AS observations, " +
                    "a.name AS area_name, " +
                    "boss.name AS boss_name, " +
                    "dev_boss.name AS dev_boss_name, " +
                    "tester.name AS tester_name, " +
                    "programmer.name AS programmer_name, " +
                    "t.due_date AS ticket_due_date, " +
                    "t.created_at AS ticket_created_at " +
                    "FROM tickets t " +
                    "LEFT JOIN states s ON t.state_id = s.id " +
                    "LEFT JOIN areas a ON t.boss_id = a.boss_id " +
                    "LEFT JOIN users boss ON t.boss_id = boss.id " +
                    "LEFT JOIN users dev_boss ON t.dev_boss_id = dev_boss.id " +
                    "LEFT JOIN users tester ON t.tester_id = tester.id " +
                    "LEFT JOIN users programmer ON t.programmer_id = programmer.id " +
                    "LEFT JOIN observations o ON t.id = o.ticket_id " +
                    "WHERE t.state_id = ? " +
                    "AND t.created_at BETWEEN ? AND ?";

            PreparedStatement statement = conexion.setQuery(sql);
            statement.setInt(1, status);
            statement.setString(2, start_date);
            statement.setString(3, finish_date);

            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                HashMap<Integer, Bitacora> ticketLogs = new HashMap<>();
                Ticket ticket = new Ticket(
                        rs.getInt("ticket_id"),
                        rs.getString("ticket_code"),
                        rs.getString("ticket_name"),
                        rs.getString("ticket_description"),
                        rs.getString("ticket_pdf"),
                        rs.getString("state"),
                        rs.getInt("state_id"),
                        rs.getString("observations"),
                        rs.getString("area_name"),
                        rs.getString("boss_name"),
                        rs.getString("dev_boss_name"),
                        rs.getString("tester_name"),
                        rs.getString("programmer_name"),
                        rs.getString("ticket_due_date"),
                        rs.getString("ticket_created_at")
                );

                Conexion conexionLogs = new Conexion();
                String logsQuery = "SELECT " +
                        "tl.id AS log_id, " +
                        "tl.code_ticket AS ticket_code, " +
                        "tl.name AS log_name, " +
                        "tl.description AS log_description, " +
                        "tl.percent AS log_percent, " +
                        "u.name AS programmer_name, " +
                        "tl.created_at AS log_created_at " +
                        "FROM ticket_logs tl " +
                        "INNER JOIN users u ON tl.programmer_id = u.id " +
                        "WHERE tl.code_ticket = ?";

                PreparedStatement logsStatement = conexionLogs.setQuery(logsQuery);
                logsStatement.setString(1, ticket.getCode());

                ResultSet rs2 = logsStatement.executeQuery();
                while (rs2.next()) {
                    Bitacora logs = new Bitacora(
                            rs2.getInt("log_id"),
                            rs2.getString("ticket_code"),
                            rs2.getString("log_name"),
                            rs2.getString("log_description"),
                            rs2.getDouble("log_percent"),
                            rs2.getString("programmer_name"),
                            rs2.getString("log_created_at")
                    );
                    ticketLogs.put(logs.getId(), logs);
                }
                ticket.setLogs(ticketLogs);
                tickets.put(ticket.getCode(), ticket);
                conexionLogs.closeConnection(); // Cerrar conexión de logs
            }
            conexion.closeConnection(); // Cerrar conexión principal
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return tickets;
    }
}