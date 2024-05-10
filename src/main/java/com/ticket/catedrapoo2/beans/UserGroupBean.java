package com.ticket.catedrapoo2.beans;

public class UserGroupBean {
    // Atributos ==============================================================
    private int id;
    private String gupo_name;
    private int id_user;
    private String user_name;

    // Constructores ===========================================================
    public UserGroupBean(int id, int id_grupo, String gupo_name, int id_user, String user_name) {
        this.id = id;
        this.gupo_name = gupo_name;
        this.id_user = id_user;
        this.user_name = user_name;
    }

    // Getters =================================================================
    public String getGupo_name() { return gupo_name; }

    public String getUser_name() { return user_name; }

    public int getId_user() { return id_user; }

    public int getId() { return id; }
}
