package com.ticket.catedrapoo2.models;

import com.ticket.catedrapoo2.beans.Conexion;
import com.ticket.catedrapoo2.beans.GrupoBean;
import com.ticket.catedrapoo2.beans.UserGroupBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

public class UserGroup {
    // Métodos propios del MODELO  ================================================

    public boolean agregarUserGroup() {
        return true;
    }

    public HashMap<Integer, UserGroup> getAllUserGroups() throws SQLException {
        HashMap<Integer, GrupoBean> userGroupList = new HashMap<>();

        Conexion conexion = new Conexion();
        String query = "SELECT ug.id AS id, u.name, g.name " +
                "FROM users_groups ug" +
                "LEFT JOIN users u ON ug.user_id = u.id " +
                "LEFT JOIN groups g ON ug.group_id = g.id";
        conexion.setRs(query);

        ResultSet rs = conexion.getRs();
        while (rs.next()){
//            UserGroupBean = new UserGroupBean(
//                    rs.getInt("id"),
//                    rs.getInt("user_id"),
//                    rs.getInt("group_id"),
//                    rs.getString("name"),
//                    rs.getString("name")
//            );
        }

        return new HashMap<Integer, UserGroup>();
    }
}
