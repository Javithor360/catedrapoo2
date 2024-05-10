package com.ticket.catedrapoo2.models;

import com.ticket.catedrapoo2.beans.Conexion;
import com.ticket.catedrapoo2.beans.MapeoBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

public class Mapeo {

    public HashMap<Integer, MapeoBean> getAllMapeos() throws SQLException {
        HashMap<Integer, MapeoBean> mapeoList = new HashMap<>();

        Conexion conexion = null;
        try {
            conexion = new Conexion();
            String query = "SELECT ma.id AS ID, " +
                    "ma.boss_id AS JefeID, " +
                    "u1.name AS NombreJefe, " +
                    "ma.area_id AS AreaID, " +
                    "a.name AS NombreArea, " +
                    "ma.users_group_id AS GrupoID, " +
                    "g.name AS NombreGrupo " +
                    "FROM assignments_map ma " +
                    "LEFT JOIN users u1 ON ma.boss_id = u1.id " +
                    "LEFT JOIN areas a ON ma.area_id = a.id " +
                    "LEFT JOIN `groups` g ON ma.users_group_id = g.id;";
            conexion.setRs(query);

            ResultSet rs = conexion.getRs();
            // ================================================
            Conexion conexionCount = new Conexion();
            String queryCount = "SELECT group_id, " +
                    "COUNT(*) AS total_integrantes " +
                    "FROM users_groups GROUP BY group_id";
            conexionCount.setRs(queryCount);
            ResultSet rsCount = conexionCount.getRs();

            // Verificar si rsCount tiene al menos un valor
            boolean hasNextCount = rsCount.next();

            while (rs.next()) {
                int totalIntegrantes = hasNextCount ? rsCount.getInt("total_integrantes") : 0;

                MapeoBean mapeo = new MapeoBean(
                        rs.getInt("ID"),
                        rs.getInt("JefeID"),
                        rs.getString("NombreJefe"),
                        rs.getInt("AreaID"),
                        rs.getString("NombreArea"),
                        rs.getInt("GrupoID"),
                        rs.getString("NombreGrupo"),
                        totalIntegrantes
                );

                mapeoList.put(rs.getInt("ID"), mapeo);

                hasNextCount = rsCount.next();
            }

            return mapeoList;
        } finally {
            if (conexion != null) {
                conexion.closeConnection();
            }
        }
    }
}
