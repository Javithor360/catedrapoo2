package com.ticket.catedrapoo2.models;

import com.ticket.catedrapoo2.beans.Conexion;
import com.ticket.catedrapoo2.beans.GrupoBean;
import com.ticket.catedrapoo2.beans.UserGroupBean;
import com.ticket.catedrapoo2.beans.Users;

import java.sql.Connection;
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
                    "WHERE ug.group_id = ? ";
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

    public HashMap<Integer, Users> getUsersWithoutGroup(String type) throws SQLException {
        Conexion conexion = new Conexion();
        ResultSet rs = null;
        PreparedStatement stmt = null;

        HashMap<Integer, Users> usersWithoutGroup = new HashMap<>();
        String idUsuarios = "0";

        if (type.equals("Empleados")) idUsuarios = "4";
        else if (type.equals("Programadores")) {
            idUsuarios = "2";
        }

        try {
            String query = "SELECT u.id, u.name, r.name AS role FROM users u " +
                    "LEFT JOIN users_groups ug ON u.id = ug.user_id " +
                    "LEFT JOIN roles r ON u.role_id = r.id " +
                    "WHERE ug.user_id IS NULL " +
                    "AND u.role_id NOT IN (1, 3) " +
                    "AND u.role_id = " + idUsuarios + " ;";

            stmt = conexion.getConnection().prepareStatement(query);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Users user = new Users(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("role")
                );
                usersWithoutGroup.put(user.getId(), user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            conexion.closeConnection();
        }

        return usersWithoutGroup;
    }

    public boolean addUserToGroup(UserGroupBean userGroup) throws SQLException {
        Conexion conexion = new Conexion();
        Connection conn = null;
        PreparedStatement stmt = null;
        Boolean success = false;

        try {
            conn = conexion.getConnection();
            conn.setAutoCommit(false);

            // Insertar en la tabla usersgroup
            String query = "INSERT INTO users_groups (user_id, group_id) VALUES (?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, userGroup.getId_user());
            stmt.setInt(2, userGroup.getId());
            int affectedRows = stmt.executeUpdate();

            if(affectedRows == 0) {
                throw new SQLException("No se pudo insertar el usuario en el grupo");
            }

            success = true;
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
            conexion.closeConnection();
        }

        return success;
    }

    public boolean deleteUserFromGroup(UserGroupBean userGroup) throws SQLException {
        Conexion conexion = new Conexion();
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        try {
            conn = conexion.getConnection();
            conn.setAutoCommit(false);

            String query = "DELETE FROM users_groups WHERE user_id = ? AND group_id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, userGroup.getId_user());
            stmt.setInt(2, userGroup.getId());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("No se pudo eliminar el usuario del grupo, no se encontró la asociación.");
            }

            conn.commit();
            success = true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
            conexion.closeConnection();
        }

        return success;
    }


}
