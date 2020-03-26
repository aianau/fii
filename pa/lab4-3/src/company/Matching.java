package company;

import javafx.util.Pair;

import java.util.List;
import java.util.Map;

public class Matching {
    private Problem problem;
    private Partition partition = new Partition();

    public Matching(Problem problem) throws CloneNotSupportedException {
        this.problem = (Problem) problem.clone();
    }

    public void solve() throws CloneNotSupportedException {
        Problem problem_solved = (Problem) this.problem.clone();
        Map<Offerer, List<Asker>> offererPrefferences = problem_solved.getOffererPrefferences();
        Map<Asker, List<Offerer>> askerPreferences = problem_solved.getAskerPreferences();

        for( Offerer offerer: offererPrefferences.keySet()){
            offererPrefferences.get(offerer).clear();
        }


        do {
            // Every single asker proposes to an offerer.
            for (Asker asker : askerPreferences.keySet())
                if (asker.isUnpaired())
                    if (!askerPreferences.get(asker).isEmpty()) {
                        Offerer pair =  askerPreferences.get(asker).remove(0);
                        offererPrefferences.get(pair).add(asker);
                    }

            // The offerers pick their favorite askers.
            for (Offerer offerer : offererPrefferences.keySet()){
                for (Asker mostDesired : offererPrefferences.get(offerer)) {
                    if (mostDesired == offerer.getPair() || offererPrefferences.get(offerer).contains(mostDesired)) {
                        offerer.setPair(mostDesired);
                        break;
                    }
                }
            }

            // End the process if everybody has a pair.
        } while (offererPrefferences.keySet().stream().anyMatch(Offerer::isUnpaired));

        offererPrefferences.keySet().forEach(w -> partition.addPair(new Pair<>(w, w.getPair())));
    }

    public Problem getProblem() {
        return problem;
    }

    public void setProblem(Problem problem) {
        this.problem = problem;
    }

    public Partition getPartition() {
        return partition;
    }

    public void setPartition(Partition partition) {
        this.partition = partition;
    }

    public boolean isStable(){
        this.partition.getPairs()
                .stream()
                .anyMatch(x->{
                    System.out.println(x.getKey());
                    System.out.println(x.getValue());
                    return false;
                });
        return true;
    }
}
