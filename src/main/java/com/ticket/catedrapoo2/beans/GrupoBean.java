package com.ticket.catedrapoo2.beans;

public class GrupoBean {
    // Atributos ==============================================================
    private int id;
    private String name;

    // Constructores ===========================================================
    public GrupoBean(int id, String name) {
        this.id = id;
        this.name = name;
    }

    // Getters =================================================================
    public int getId() { return id; }

    public String getName() { return name; }
}
