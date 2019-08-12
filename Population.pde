import java.util.*;
public class Population{
  
  private ArrayList<Robot> robots;
  private int currentRobot;
  private int generation;
  private int[] origin;
  private int mutationRate;
  
  public Population(int size, int amountStep){
    this.mutationRate = 30;
    this.robots = new ArrayList<Robot>();
    this.currentRobot = 0;
    this.generation = 1;
    for(int i = 0; i < size; i++)
      this.robots.add(new Robot(amountStep,i));
  }
  
  public void prepare(int[][] map, int[] origin, int[] target){
    this.origin = new int[2];
    
    this.origin[0] = origin[0];
    this.origin[1] = origin[1];
    
    for(Robot r : this.robots){
      r.start(map,origin,target);
    }
  }
  
  public boolean canRobotRun(){
    return this.robots.get(this.currentRobot).canRun();
  }
  
  public int[] getRobotPosition(){
    return this.robots.get(this.currentRobot).getPosition();
  }
  
  public int[] run(){
    return this.robots.get(this.currentRobot).run();
  }
  
  public boolean isThereRobot(){
    return (this.currentRobot < this.robots.size()-1);
  }
  
  public void getFitness(){
    Collections.sort(robots);
    for(Robot r: robots){
      println("Fitness from " + r.getId()+" = "+ r.getFitness());
    }
  }
  
  public int[] nextGeneration(){
    this.generation++; 
    println("Generation: "+this.generation);
    this.currentRobot = 0;
    this.crossOver();
    for (Robot r : robots)
      r.restart(origin);
    return this.origin;
  }
  
  public void crossOver(){
    ArrayList<Integer> r1 = this.robots.get(0).getGenome();
    ArrayList<Integer> r2 = this.robots.get(1).getGenome();
    
    int split = new Random().nextInt(r1.size()-1);
    
    for(int k = 2; k < this.robots.size(); k++){
      ArrayList<Integer> son = new ArrayList<Integer>();
      for (int i = 0; i <= split; i++){
        son.add(r1.get(i));
      }
      for(int i = split+1; i < r1.size(); i++){
        son.add(r2.get(i));
      }
      
      int rate = new Random().nextInt(100);
      if (rate < this.mutationRate){
        println("Mutation has been done");
        int where = new Random().nextInt(son.size());
        int step = new Random().nextInt(4);
        son.set(where,step);
        where = new Random().nextInt(son.size());
        step = new Random().nextInt(4);
        son.set(where,step);
      }
      
      this.robots.get(k).newGenome(son);
    }
    
  }
  
  
  public void nextRobot(){
    this.currentRobot++;
  }
  
}
