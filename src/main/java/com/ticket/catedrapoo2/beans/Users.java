package com.ticket.catedrapoo2.beans;

import java.util.Date;

public class Users {
    private int id;
    private String name;
    private String email;
    private String password;
    private String gender;
    private Date birthday;
    private String role_id;

    private Date created_at;

    //solo para inicializar
    public Users() {
    }


    //para guardar valores sin id
    public Users(String name, String email, String password, String gender, Date birthday, String role_id, Date created_at) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.gender = gender;
        this.birthday = birthday;
        this.role_id = role_id;
        this.created_at = created_at;
    }

    // este se ocupará para listar todo el registro junto al id
    public Users(int id, String name, String email, String password, String gender, Date birthday, String role_id, Date created_at) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.gender = gender;
        this.birthday = birthday;
        this.role_id = role_id;
        this.created_at = created_at;
    }


    //ocupo para listar una parte de todo el registro
    public Users(int id, String name, String email, String gender, String role_id, Date created_at) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.gender = gender;
        this.role_id = role_id;
        this.created_at = created_at;
    }

    public Users (int id, String name, String email, String gender, Date birthday, String role_id ){
        this.id = id;
        this.name = name;
        this.email = email;
        this.gender = gender;
        this.role_id = role_id;
        this.birthday = birthday;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // Getter y Setter para 'name'
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // Getter y Setter para 'email'
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    // Getter y Setter para 'password'
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    // Getter y Setter para 'gender'
    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    // Getter y Setter para 'birthday'
    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    // Getter y Setter para 'role_id'
    public String getRole_id() {
        return role_id;
    }

    public void setRole_id(String role_id) {
        this.role_id = role_id;
    }


    // Getter y Setter para 'created_at'
    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }
}
