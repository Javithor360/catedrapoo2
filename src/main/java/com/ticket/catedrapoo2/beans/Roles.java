package com.ticket.catedrapoo2.beans;

public class Roles {
    private int id;
    private String name;

    public Roles(){
        
    }

    public Roles(int Id, String name){
        this.id = Id;
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }




}
