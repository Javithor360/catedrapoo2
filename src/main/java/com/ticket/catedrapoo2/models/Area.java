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
            conn.setAutoCommit(false); // Inicia la transacción

            // Insertar en la tabla de areas
            String queryArea = "INSERT INTO areas (name, prefix_code, boss_id, dev_boss_id) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(queryArea, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, newArea.getName());
            stmt.setString(2, newArea.getPrefix_code());
            stmt.setInt(3, newArea.getId_boss());
            stmt.setInt(4, newArea.getId_dev_boss());
            stmt.executeUpdate();

            generatedKeys = stmt.getGeneratedKeys();
            int newAreaId = 0;
            if (generatedKeys.next()) {
                newAreaId = generatedKeys.getInt(1);
            }

            // Insertar en la tabla de Grupos y recuperar ID de grupos
            String[] groupNames = {"Empleados " + newArea.getName(), "Programadores para " + newArea.getPrefix_code()};
            int[] groupIDs = new int[2];

            for (int i = 0; i < groupNames.length; i++) {
                String queryGroup = "INSERT INTO `groups` (name) VALUES (?)";
                stmt = conn.prepareStatement(queryGroup, Statement.RETURN_GENERATED_KEYS);
                stmt.setString(1, groupNames[i]);
                stmt.executeUpdate();
                generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    groupIDs[i] = generatedKeys.getInt(1);
                }
            }

            // Insertar en la tabla de asignaciones usando los nuevos IDs de área y grupo
            String queryAssign = "INSERT INTO assignments_map (boss_id, area_id, users_group_id) VALUES (?, ?, ?), (?, ?, ?)";
            stmt = conn.prepareStatement(queryAssign);
            stmt.setInt(1, newArea.getId_boss());
            stmt.setInt(2, newAreaId);
            stmt.setInt(3, groupIDs[0]);  // ID del grupo de empleados
            stmt.setInt(4, newArea.getId_dev_boss());
            stmt.setInt(5, newAreaId);
            stmt.setInt(6, groupIDs[1]);  // ID del grupo de programadores
            stmt.executeUpdate();

            conn.commit(); // Confirma toda la transacción
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // En caso de error, realiza un rollback
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
