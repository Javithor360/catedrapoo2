package com.ticket.catedrapoo2.models;

import com.ticket.catedrapoo2.beans.AreaBean;
import com.ticket.catedrapoo2.beans.Conexion;

import java.sql.*;
import java.util.HashMap;

public class Area {
    // Métodos propios del MODELO  ================================================
    public void addArea(AreaBean newArea) throws SQLException {
        Conexion conexion = new Conexion();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet generatedKeys = null;

        try {
            conn = conexion.getConnection();
            conn.setAutoCommit(false);

            // Insertar en la tabla de areas
            String query = "INSERT INTO areas (name, prefix_code, boss_id, dev_boss_id) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, newArea.getName());
            stmt.setString(2, newArea.getPrefix_code());
            stmt.setInt(3, newArea.getId_boss());
            stmt.setInt(4, newArea.getId_dev_boss());
            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating area failed, no rows affected.");
            }

            generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                int newAreaId = generatedKeys.getInt(1);

                // Insertar en la tabla de Grupos
                String query1 = "INSERT INTO `groups` (name) VALUES (?), (?)";
                stmt = conn.prepareStatement(query1);
                stmt.setString(1, "Empleados " + newArea.getName());
                stmt.setString(2, "Programadores para " + newArea.getPrefix_code());
                stmt.executeUpdate();

                // Insertar en la tabla de asignaciones usando el nuevo ID
                String query2 = "INSERT INTO assignments_map (boss_id, area_id, users_group_id) VALUES (?, ?, ?), (?, ?, ?)";
                stmt = conn.prepareStatement(query2);
                stmt.setInt(1, newArea.getId_boss());
                stmt.setInt(2, newAreaId);
                stmt.setInt(3, Grupo.countGrupos() + 1);
                stmt.setInt(4, newArea.getId_dev_boss());
                stmt.setInt(5, newAreaId);
                stmt.setInt(6, Grupo.countGrupos() + 2);
                stmt.executeUpdate();
            }

            conn.commit();  // Commit the transaction
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();  // En caso de error, hacer rollback
                } catch (SQLException ex) {
                    e.printStackTrace();
                }
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (generatedKeys != null) generatedKeys.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
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
