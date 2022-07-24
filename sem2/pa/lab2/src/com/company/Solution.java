package com.company;

import java.util.ArrayList;
import java.util.List;

public class Solution{
    private Problem problem;

    public Solution(Problem problem) {
        this.problem = problem;
    }

    public void solveInstance(){
        for (Depot depot :
                problem.getDepots()) {
            for (Vehicle vehicle :
                    depot.getVehicles())   {
                for (Client client :
                        problem.getClients()) {
                    if (vehicle.getTour().addClient(client)){
//                        System.out.println(client + " in " + vehicle);
                    }

                }
            }
        }

        for (Depot depot :
                problem.getDepots()) {
            for (Vehicle vehicle :
                    depot.getVehicles())   {
                for (Client client :
                        problem.getClients()) {
                    System.out.println(client + " in " + vehicle);

                }
            }
        }


    }
}
