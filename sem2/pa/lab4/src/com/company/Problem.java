package com.company;


import java.util.*;

public class Problem implements Cloneable{
    private Map<Offerer, List<Asker>> offererPrefferences;
    private Map<Asker, List<Offerer>> askerPreferences;

    public Problem(Map<Offerer, List<Asker>> offererPrefferences, Map<Asker, List<Offerer>> askerPreferences) {
        this.offererPrefferences = offererPrefferences;
        this.askerPreferences = askerPreferences;
    }

    public Map<Offerer, List<Asker>> getOffererPrefferences() {
        return offererPrefferences;
    }

    public void setOffererPrefferences(Map<Offerer, List<Asker>> offererPrefferences) {
        this.offererPrefferences = offererPrefferences;
    }

    public Map<Asker, List<Offerer>> getAskerPreferences() {
        return askerPreferences;
    }

    public void setAskerPreferences(Map<Asker, List<Offerer>> askerPreferences) {
        this.askerPreferences = askerPreferences;
    }

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }

}