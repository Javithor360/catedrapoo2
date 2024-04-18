package com.ticket.catedrapoo2.beans;

public class Bitacora {
    private int id;
    private String code;
    private String name;
    private String description;
    private double percent;
    private String programmer_name;
    private String created_at;

    public Bitacora(int id, String code, String name, String description, double percent, String programmer_name, String created_at) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.description = description;
        this.percent = percent;
        this.programmer_name = programmer_name;
        this.created_at = created_at;
    }

    public Bitacora(String code, String name, String description, double percent, String programmer_name, String created_at) {
        this.code = code;
        this.name = name;
        this.description = description;
        this.percent = percent;
        this.programmer_name = programmer_name;
        this.created_at = created_at;
    }

    public int getId() {
        return id;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public double getPercent() {
        return percent;
    }

    public String getProgrammer_name() {
        return programmer_name;
    }

    public String getCreated_at() {
        return created_at;
    }

}
