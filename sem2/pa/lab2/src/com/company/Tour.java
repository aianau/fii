package com.company;

import java.util.ArrayList;
import java.util.List;


public class Tour {
    private List<Client> clients;

    public Tour() {
        this.clients = new ArrayList<>();
    }

    public boolean addClient(Client client){
        if (client.isAssigned()){
            return false;
        }

        if(clients.contains(client)){
            return false;
        }


        if(clients.size() > 0 && clients.get(clients.size()-1).getTime() > client.getTime()){
            return false;
        }

        clients.add(client);
        return true;
    }
}
