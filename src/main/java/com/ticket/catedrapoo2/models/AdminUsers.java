package com.ticket.catedrapoo2.models;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.ticket.catedrapoo2.beans.Conexion;
import com.ticket.catedrapoo2.beans.Users;

public class AdminUsers {

    public boolean agregarUsuario(Users usuario) {
        Conexion conexion = null;
        PreparedStatement pstmt = null;
        boolean resultado = false;

        try {
            conexion = new Conexion();
            String sql = "INSERT INTO users (name, email, password, gender, birthday, role_id, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conexion.setQuery(sql);
            pstmt.setString(1, usuario.getName());
            pstmt.setString(2, usuario.getEmail());
            pstmt.setString(3, usuario.getPassword());
            pstmt.setString(4, usuario.getGender());
            pstmt.setDate(5, new java.sql.Date(usuario.getBirthday().getTime()));
            pstmt.setString(6, usuario.getRole_id());
            pstmt.setDate(7, new java.sql.Date(usuario.getCreated_at().getTime()));

            int filasAfectadas = pstmt.executeUpdate();
            if (filasAfectadas > 0) {
                resultado = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conexion != null) {
                    conexion.closeConnection();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return resultado;
    }

    public List<Users> obtenerUsers() {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Users> usuarios = new ArrayList<>();
        try {
            cn = new Conexion().getConnection();
            String tsql = "SELECT u.id, u.name, u.email, u.gender, r.name as role_id, u.created_at FROM users u INNER JOIN roles r ON u.role_id = r.id";

            ps = cn.prepareStatement(tsql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Users usuario = new Users(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("gender"),
                        rs.getString("role_id"),
                        rs.getDate("created_at")
                );
                usuarios.add(usuario);


            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        System.out.println("AQUI VAN LOS USUARIOS" + usuarios);
        return usuarios;
    }

    public boolean eliminarEmpleado(int idEmpleado) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean eliminado = false;
        try {
            cn = new Conexion().getConnection();
            String sql = "DELETE FROM users WHERE id = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idEmpleado);

            int filasAfectadas = ps.executeUpdate();

            eliminado = (filasAfectadas > 0);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return eliminado;
    }

}
