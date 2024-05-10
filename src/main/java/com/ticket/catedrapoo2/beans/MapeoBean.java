package com.ticket.catedrapoo2.beans;

public class MapeoBean {
    // Atributos ==============================================================
    private int id;
    private int boss_id;
    private String name_boss;
    private int area_id;
    private String name_area;
    private int users_group_id;
    private String name_group;
    private int total_users;

    // Constructores ===========================================================
    public MapeoBean(int id, int boss_id, String name_boss, int area_id, String name_area, int users_group_id, String name_group, int total_users) {
        this.id = id;
        this.boss_id = boss_id;
        this.name_boss = name_boss;
        this.area_id = area_id;
        this.name_area = name_area;
        this.users_group_id = users_group_id;
        this.name_group = name_group;
        this.total_users = total_users;
    }

    public MapeoBean(int boss_id, int area_id, int users_group_id) {
        this.boss_id = boss_id;
        this.area_id = area_id;
        this.users_group_id = users_group_id;
    }

    // Getters =================================================================
    public int getId() { return id; }

    public int getBoss_id() {
        return boss_id;
    }

    public String getName_boss() {
        return name_boss;
    }

    public int getArea_id() {
        return area_id;
    }

    public String getName_area() {
        return name_area;
    }

    public int getUsers_group_id() {
        return users_group_id;
    }

    public String getName_group() {
        return name_group;
    }

    public int getTotal_users() {
        return total_users;
    }

}
