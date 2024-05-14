package com.ticket.catedrapoo2.models;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.ticket.catedrapoo2.beans.Conexion;
import com.ticket.catedrapoo2.beans.Roles;
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

    public Users buscarId(int id) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Users user = null;

        try {
            cn = new Conexion().getConnection();
            String tsql = "SELECT id, name, email, gender, birthday, role_id FROM users WHERE id = ?";
            ps = cn.prepareStatement(tsql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = new Users();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setGender(rs.getString("gender"));
                user.setBirthday(rs.getDate("birthday"));
                user.setRol(rs.getInt("role_id"));
            }
        } catch (SQLException e) {
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

        return user;
    }


    public List<Roles> listarRoles(){
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Roles> rolesList = new ArrayList<>();

        try {
            cn = new Conexion().getConnection();
            String tsql = "SELECT * FROM roles";
            ps = cn.prepareStatement(tsql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Roles roles = new Roles();
                roles.setId(rs.getInt("id"));
                roles.setName(rs.getString("name"));
                rolesList.add(roles);
            }

        } catch (SQLException e) {
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

        return rolesList;
    }


    public boolean buscarUserId(int id){
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean res = false;

        try {
            cn = new Conexion().getConnection();

            String sql = "SELECT * FROM users_groups WHERE user_id = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                res = true;
            } else {
                res = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return res;
    }
    public boolean buscarCorreo(String correo) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean res = false;

        try {
            cn = new Conexion().getConnection();

            String sql = "SELECT * FROM users WHERE email = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, correo);
            rs = ps.executeQuery();

            if (rs.next()) {
                res = true;
            } else {
                res = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return res;
    }


    public boolean actualizarEmpleado(Users user) {
        Connection cn = null;
        PreparedStatement ps = null;

        boolean res = false;

        try {
            cn = new Conexion().getConnection();

            String sql = "UPDATE users SET name = ?, email = ?, gender = ?, birthday = ?, role_id = ? WHERE id = ?";

            ps = cn.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getGender());
            ps.setDate(4, new java.sql.Date(user.getBirthday().getTime()));
            ps.setString(5, user.getRole_id());
            ps.setInt(6, user.getId());

            int filasActualizadas = ps.executeUpdate();

            if (filasActualizadas > 0) {
                res = true;
            } else {
                res = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return res;
    }

}
