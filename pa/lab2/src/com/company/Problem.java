package com.company;

import java.util.ArrayList;
import java.util.List;


public class Problem {
    private List<Depot> depots;
    private List<Client> clients;
    private List<Vehicle> vehicles;

    public Problem() {
        this.depots = new ArrayList<>();
        this.clients = new ArrayList<>();
    }

    public List<Client> getClients() {
        return clients;
    }

    public void setClients(List<Client> clients) {
        this.clients = clients;
    }

    public List<Depot> getDepots() {
        return depots;
    }

    public void setDepots(List<Depot> depots) {
        this.depots = depots;
    }

    public boolean addDepot(Depot dep){
        if (depots.contains(dep)){
            return false;
        }

        depots.add(dep);
        return true;
    }

    public boolean addClient(Client client){
        if (clients.contains(client)){
            return false;
        }

        clients.add(client);
        return true;
    }


}