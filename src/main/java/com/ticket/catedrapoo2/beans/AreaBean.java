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