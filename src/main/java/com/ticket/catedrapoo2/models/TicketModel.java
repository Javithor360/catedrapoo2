package com.ticket.catedrapoo2.models;

import com.ticket.catedrapoo2.beans.JefeArea;
import com.ticket.catedrapoo2.beans.UserSession;
import com.ticket.catedrapoo2.beans.Conexion;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Year;
import java.util.Random;

public class TicketModel {
    public static void checkTickets() {
        try {
            Conexion conexion = new Conexion();

            String sql = "SELECT id FROM tickets WHERE (state_id = 3 OR state_id = 6) AND due_date < CURDATE()";

            PreparedStatement pstmt = conexion.setQuery(sql);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                int ticketId = rs.getInt("id");
                updateTicketState(conexion, ticketId);
            }

            rs.close();
            pstmt.close();
            conexion.closeConnection();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    private static void updateTicketState (Conexion conexion, int ticketId) throws SQLException {
        String updateSql = "UPDATE tickets SET state_id = 5 WHERE id = ?";
        PreparedStatement updateStmt = conexion.setQuery(updateSql);

        System.out.println("---------- Ticket #" + ticketId + " ha sido categorizado como Vencido. --------------");

        updateStmt.setInt(1, ticketId);
        updateStmt.executeUpdate();
        updateStmt.close();
    }

    public static void createTicket(UserSession boss, String name, String description) throws SQLException{
        int devBossId=0;
        Conexion conexion = new Conexion();

        try{
            String query = "SELECT dev_boss_id FROM areas WHERE boss_id = "+boss.getId()+";";

            conexion.setRs(query);
            ResultSet rs = conexion.getRs();

            while(rs.next()){
                devBossId = rs.getInt("dev_boss_id");
            }

            PreparedStatement stmt;

            String queryInsert = "INSERT INTO tickets (code, name, description, state_id, boss_id, dev_boss_id, created_at) VALUES " +
                    "('" + generateNewCode(boss.getId()) + "', '" + name + "', '" + description + "', 1, '" + boss.getId() + "', '" + devBossId + "', CURRENT_TIMESTAMP)";

            stmt = conexion.setQuery(queryInsert);
            stmt.executeUpdate();
            stmt.close();

        }finally {
            if (conexion != null) {
                conexion.closeConnection();
            }
        }
    }

    public static String generateNewCode(int user_id) throws SQLException{
        Random ran = new Random();
        String prefix =  JefeArea.getPrefix_area_code(user_id);
        String year = String.valueOf(Year.now());
        String num = String.valueOf(ran.nextInt(999 - 100 + 1) + 100);

        return prefix+year+num;
    }
}
