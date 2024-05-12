package com.ticket.catedrapoo2.models;

import com.ticket.catedrapoo2.beans.Conexion;
import com.ticket.catedrapoo2.beans.GrupoBean;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

public class Grupo {
    public HashMap<Integer, GrupoBean> getAllGrupos() throws SQLException {
        HashMap<Integer, GrupoBean> grupoList = new HashMap<>();

        Conexion conexion = new Conexion();
        String query = "SELECT * FROM grupos";

        conexion.setRs(query);
        ResultSet rs = conexion.getRs();

        while (rs.next()) {
            int id = rs.getInt("id");
            String nombre = rs.getString("nombre");

            GrupoBean grupo = new GrupoBean(id, nombre);
            grupoList.put(id, grupo);
        }

        conexion.closeConnection();

        return grupoList;
    }

    public GrupoBean getGrupoById(Integer id) throws SQLException {
        GrupoBean grupo = null;
        Conexion conexion = new Conexion();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            String query = "SELECT * FROM `groups` WHERE id = ?";
            stmt = conexion.getConnection().prepareStatement(query);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                grupo = new GrupoBean(
                        rs.getInt("id"),
                        rs.getString("name")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) rs.close();
            conexion.closeConnection();
        }

        System.out.println("Grupo: " + grupo.getName());

        return grupo;
    }

    public static Integer countGrupos() throws SQLException {
        Integer numGrupos = 0;
        Conexion conexion = new Conexion();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            String query = "SELECT COUNT(*) AS total FROM `groups`";
            stmt = conexion.getConnection().prepareStatement(query);
            rs = stmt.executeQuery();

            if (rs.next()) {
                numGrupos = rs.getInt("total");
                System.out.println("Número de grupos: " + numGrupos);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) rs.close();
            conexion.closeConnection();
        }

        return numGrupos;
    }
}
