package com.ticket.catedrapoo2.beans;

import java.util.Date;
import java.util.HashMap;

public class JefeDesarrollo extends UserSession {

    private static HashMap<String, Ticket> tickets_request;
    private static HashMap<String, Ticket> all_tickets;
    private static HashMap<Integer, String> programmers_names;
    private static HashMap<Integer, String> testers_names;
    private static HashMap<Integer, JefeDesarrollo> available_dev_bosses;

    public JefeDesarrollo(int id, String name, String email, String gender, Date birthday, Integer role_id, Date created_at) {
        super(id, name, email, gender, birthday, role_id, created_at);
    }

    public static HashMap<String, Ticket> getTickets_request() {
        return tickets_request;
    }

    public static void setTickets_request(HashMap<String, Ticket> new_tickets_request) {
        tickets_request = new_tickets_request;
    }

    public static HashMap<Integer, String> getProgrammers_names() {
        return programmers_names;
    }

    public static void setProgrammers_names(HashMap<Integer, String> programmers_names) {
        JefeDesarrollo.programmers_names = programmers_names;
    }

    public static HashMap<Integer, String> getTesters_names() {
        return testers_names;
    }

    public static void setTesters_names(HashMap<Integer, String> testers_names) {
        JefeDesarrollo.testers_names = testers_names;
    }

    public static HashMap<String, Ticket> getAll_tickets() {
        return all_tickets;
    }

    public static void setAll_tickets(HashMap<String, Ticket> all_tickets) {
        JefeDesarrollo.all_tickets = all_tickets;
    }

    public static HashMap<Integer, JefeDesarrollo> getAvailables_dev_bosses() {
        return available_dev_bosses;
    }

    public static void setAvailables_dev_bosses(HashMap<Integer, JefeDesarrollo> available_dev_bosses) {
        JefeDesarrollo.available_dev_bosses = available_dev_bosses;
    }
}
