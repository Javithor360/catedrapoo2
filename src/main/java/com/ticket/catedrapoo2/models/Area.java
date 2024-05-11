package com.ticket.catedrapoo2.models;

import com.ticket.catedrapoo2.beans.AreaBean;
import com.ticket.catedrapoo2.beans.Conexion;

import java.sql.Connection;
import java.util.HashMap;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;

public class Area {
    // Métodos propios del MODELO  ================================================
    public void addArea(AreaBean newArea) throws SQLException {
        Conexion conexion = new Conexion();
        PreparedStatement stmt = null;

        try {
            String query = "INSERT INTO areas (name, prefix_code, boss_id, dev_boss_id) VALUES (?, ?, ?, ?)";
            stmt.setString(1, newArea.getName());
            stmt.setString(2, newArea.getPrefix_code());
            stmt.setInt(3, newArea.getId_boss());
            stmt.setInt(4, newArea.getId_dev_boss());

            // Ejecutar la sentencia
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (stmt != null) stmt.close();
            conexion.closeConnection();
        }
    }

    public HashMap<Integer, AreaBean> getAllAreas() throws SQLException {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        HashMap<Integer, AreaBean> areasList = new HashMap<Integer, AreaBean>(); // Definición del HashMap Local

        try {
            // Conexion a la BD
            cn = new Conexion().getConnection();
            String query = "SELECT a.id, a.prefix_code, a.name, b.name AS boss_name, d.name AS dev_boss_name, a.created_at " +
                    "FROM areas a " +
                    "LEFT JOIN users b ON a.boss_id = b.id " +
                    "LEFT JOIN users d ON a.dev_boss_id = d.id ";
            ps = cn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                // Crear un objeto AreaBean
                AreaBean area = new AreaBean(
                        rs.getInt("id"),
                        rs.getString("prefix_code"),
                        rs.getString("name"),
                        rs.getString("boss_name"),
                        rs.getString("dev_boss_name"),
                        rs.getTimestamp("created_at")
                );
                // Agregar el objeto AreaBean al HashMap
                areasList.put(area.getId(), area);
            }
            return areasList;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
