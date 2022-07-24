package com.company;

import javax.print.DocFlavor;
import java.beans.VetoableChangeListenerProxy;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * https://profs.info.uaic.ro/~acf/java/labs/lab_02.html
 * An instance of MDVSP consists of depots, vehicles and clients (trips).
 * <p>
 * Each vehicle belongs to a single depot. It starts from there and it may return there at any time.
 * Each client has a name and a visiting time (a number of order, starting with 1).
 * Each vehicle will perform a single tour, consisting of one or more trips with strictly ascending visiting times, starting from its depot and ending in it.
 * Each trip in the timetable must be covered by a single vehicle.
 * A vehicle cannot be assigned to more than one trip at any point in time.
 * We consider the problem of allocating trips to vehicles such that all constraints are satisfied.
 * <p>
 * Consider the following example. There are 2 depots (D1,D2), D1 has 2 vehicles (V1,V2) and D2 has one vehicle (V3). There are 5 clients C1(1),C2(1),C3(2),C4(2),C5(3) (in parenthesis are the visiting times).
 * A solution for this example might contain the following tours: V1: D1 -> C1 -> C3 -> C5 -> D1, V2: D1 -> C2 -> D1, V3: D2 -> C4 -> D3.
 * <p>
 * The main specifications of the application are:
 * * Compulsory (1p)
 * <p>
 * Create an object-oriented model of the problem. You should have (at least) the following classes: Depot, Vehicle, Client, Tour, Problem.
 * All depots and vechicles have names. Vehicles have the property type. The available types will be implemented as an enum . For example:
 * public enum VehicleType {
 * CAR, TRUCK, DRONE;
 * }
 * Each class should have appropriate constructors, getters and setters.
 * Use the IDE features for code generation, such as generating getters and setters.
 * The toString method form the Object class must be properly overridden for all the classes.
 * Use the IDE features for code generation, for example (in NetBeans) press Alt+Ins or invoke the context menu, select "Insert Code" and then "toString()" (or simply start typing "toString" and then press Ctrl+Space).
 * Create and print on the screen the instance of the problem described in the example.
 * <p>
 * * Optional (1p)
 * Override the equals method form the Object class for the Depot, Vehicle, Client classes. The problem should not allow adding the same depot or client twice. The depot should not allow duplicate vehicles.
 * Instead of using an enum, create dedicated classes for cars, trucks and drones. Vehicle will become abstract.
 * Implement the method getVehicles in the Problem class, returning an array of all the vehicles, form all depots.
 * Implement a simple algorithm for allocating trips to vehicles. Create a class to describe the solution.
 * Write doc comments in your source code and generate the class documentation using javadoc.
 */


public class Lab2 {
    Lab2(){
        comp();
    }
    void comp(){
        Problem problem = new Problem();
        List<Vehicle> vehicles = new ArrayList<>();
        Tour tour1 = new Tour();
        Vehicle vehicle1 = new Car("car1", tour1);
        Vehicle vehicle2 = new Car("car2", tour1);
        Vehicle vehicle3 = new Car("car3", tour1);

        vehicles.add(vehicle1);
        vehicles.add(vehicle2);
        vehicles.add(vehicle3);

        Client client1 = new Client("client1", 1, false);
        Client client2 = new Client("client2", 2, false);
        Client client3 = new Client("client3", 3, false);


        Depot depot1 = new Depot("depot1", vehicles);


        problem.addDepot(depot1);
        problem.addClient(client1);
        problem.addClient(client2);
        problem.addClient(client3);

        Solution solution = new Solution(problem);

        solution.solveInstance();
    }
}



