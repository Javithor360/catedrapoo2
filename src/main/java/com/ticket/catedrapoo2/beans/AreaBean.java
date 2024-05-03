package com.ticket.catedrapoo2.beans;

import java.awt.geom.Area;
import java.sql.*;
import java.util.HashMap;

public class AreaBean {
    // Atributos ==============================================================
    private int id;
    private String prefix_code;
    private String name;
    private int id_boss;
    private String boss_name;
    private int id_dev_boss;
    private String dev_boss_name;
    private Timestamp created_at;
    // private static HashMap<Integer, Area> all_areas;

    // Constructores ===========================================================
    public AreaBean(int id, String prefix_code, String name, String boss_name, String dev_boss_name, Timestamp created_at) {
        this.id = id;
        this.prefix_code = prefix_code;
        this.name = name;
        this.boss_name = boss_name;
        this.dev_boss_name = dev_boss_name;
        this.created_at = created_at;
    }

    public AreaBean(String name, String prefix_code, int id_boss, int id_dev_boss) {
        this.name = name;
        this.prefix_code = prefix_code;
        this.id_boss = id_boss;
        this.id_dev_boss = id_dev_boss;
    }

    // Métodos propios del BEAN ================================================

    public HashMap<String, Area> fetchAllAreas() throws SQLException {
        HashMap<String, Area> areasList = new HashMap<String, Area>();
        Conexion con = null;

        try{
            con = new Conexion();
            String query = "SELECT a.id as ID, a.prefix_code as PREFIX_CODE, a.name as NAME, a.boss_name as BOSS_NAME, a.dev_boss_name as DEV_BOSS_NAME, a.created_at as CREATED_AT FROM areas a;";


            Statement stmt = conn.createStatement();
            while (rs.next()) {
                Area area = new Area(
                    rs.getInt("id"),
                    rs.getString("prefix_code"),
                    rs.getString("name"),
                    rs.getString("boss_name"),
                    rs.getString("dev_boss_name"),
                    rs.getTimestamp("created_at")
                );
                areasList.put(area.getPrefix_code(), area);
            }
        } catch (SQLException e) {
            throw new SQLException(e);
        } finally {
            if (con != null) {
                con.close();
            }
        }

        return new HashMap<String, Area>();
    }


    // Getters =================================================================
    public int getId() { return id; }

    public String getPrefix_code() { return prefix_code; }

    public String getName() { return name; }

    public int getId_boss() { return id_boss; }

    public String getBoss_name() { return boss_name; }

    public Timestamp getCreated_at() { return created_at; }

    public String getDev_boss_name() { return dev_boss_name; }

    public int getId_dev_boss() { return id_dev_boss; }

}