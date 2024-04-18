package com.ticket.catedrapoo2.beans;

import com.ticket.catedrapoo2.utils.Conexion;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

public class JefeArea extends UserSession {

    public JefeArea(int id, String name, String email, String gender, Date birthday, Integer role_id, Date created_at) {
        super(id, name, email, gender, birthday, role_id, created_at);
    }

    public static String getPrefix_area_code(int user_id) throws SQLException {
        Conexion conexion = new Conexion();

        try{
            String query = "SELECT a.prefix_code " +
                    "FROM users u " +
                    "JOIN assignments_map am ON u.id = am.boss_id " +
                    "JOIN areas a ON am.area_id = a.id " +
                    "WHERE u.id = "+user_id+";";

            conexion.setRs(query);
            ResultSet rs = conexion.getRs();

            while(rs.next()){
                return rs.getString("prefix_code");
            }
        } finally {
            if (conexion != null) {
                conexion.closeConnection();
            }
        }
        return "NULL";
    }
}
