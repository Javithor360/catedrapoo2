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
            String query = "SELECT g.id AS GrupoID, g.name AS NombreGrupo, " +
                    "a.id AS AreaID, a.name AS NombreArea, u.id AS JefeID, " +
                    "u.name AS NombreJefe, COUNT(ug.user_id) AS TotalIntegrantes " +
                    "FROM `groups` g " +
                    "LEFT JOIN assignments_map ma ON ma.users_group_id = g.id " +
                    "LEFT JOIN areas a ON ma.area_id = a.id " +
                    "LEFT JOIN users u ON ma.boss_id = u.id " +
                    "LEFT JOIN users_groups ug ON g.id = ug.group_id " +
                    "GROUP BY g.id, g.name, a.id, a.name, u.id, u.name;";
            conexion.setRs(query);

            ResultSet rs = conexion.getRs();
            while (rs.next()) {
                MapeoBean mapeo = new MapeoBean(
                        rs.getInt("GrupoID"),
                        rs.getInt("JefeID"),
                        rs.getString("NombreJefe"),
                        rs.getInt("AreaID"),
                        rs.getString("NombreArea"),
                        rs.getInt("GrupoID"),
                        rs.getString("NombreGrupo"),
                        rs.getInt("TotalIntegrantes")
                );

                mapeoList.put(rs.getInt("GrupoID"), mapeo);
            }

            return mapeoList;
        } finally {
            if (conexion != null) {
                conexion.closeConnection();
            }
        }
    }

}
