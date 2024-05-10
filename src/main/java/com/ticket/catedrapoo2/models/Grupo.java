package com.ticket.catedrapoo2.models;

import com.ticket.catedrapoo2.beans.Conexion;
import com.ticket.catedrapoo2.beans.GrupoBean;

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
}
