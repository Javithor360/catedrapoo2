package com.ticket.catedrapoo2.models;

import com.ticket.catedrapoo2.beans.Conexion;
import com.ticket.catedrapoo2.beans.GrupoBean;
import com.ticket.catedrapoo2.beans.UserGroupBean;
import com.ticket.catedrapoo2.beans.Users;

import java.sql.PreparedStatement;
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
        while (rs.next()) {
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

    public HashMap<Integer, Users> getUserFromGroup(int Id) throws SQLException {
        Conexion conexion = new Conexion();
        ResultSet rs = null;
        PreparedStatement stmt = null;
        HashMap<Integer, Users> userGroupList = new HashMap<>();

        try {
            String query = "SELECT u.id AS id, u.name AS `name`, r.name as role " +
                    "FROM users_groups ug " +
                    "LEFT JOIN users u ON ug.user_id = u.id " +
                    "LEFT JOIN roles r ON u.role_id = r.id " +
                    "WHERE ug.id = ? ";
            stmt = conexion.getConnection().prepareStatement(query);
            stmt.setInt(1, Id);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Users user = new Users(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("role")
                );

                userGroupList.put(user.getId(), user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) rs.close();
            conexion.closeConnection();
        }

        return userGroupList;
    }
}
