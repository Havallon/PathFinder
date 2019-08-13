import java.util.Random;


public class Robot implements Comparable{
  private int[][] map;
  private int[] me;
  private int[] target;
  private int[][] collisionMap;
  private int amountStep;
  private int currentStep;
  private ArrayList<Integer> genome;
  private int id;
  private boolean alive;
  
  public Robot(int amountStep, int id){
    this.amountStep = amountStep;
    this.currentStep = 0;
    this.id = id;
    this.alive = true;
  }
  
  public void newGenome(ArrayList<Integer> genome){
    this.genome = new ArrayList<Integer>();
    for (Integer i : genome)
      this.genome.add(i);
  }
  
  public int getId(){
    return this.id;
  }
  
  private void createGenome(){
    this.genome = new ArrayList<Integer>();
    for (int i = 0; i < amountStep; i++) 
      this.genome.add(new Random().nextInt(4));
      
    //println("Amount gene: "+ this.genome.size());
  }
  
  public void start(int[][] map, int[] me, int[] target){
    
    this.createGenome();
    
    this.map = new int[8][8];
    this.me = new int[2];
    this.target = new int[2];
    this.collisionMap = new int[8][8];
    
    this.me[0] = me[0];
    this.me[1] = me[1];
    
    this.target[0] = target[0];
    this.target[1] = target[1];
    
    for (int i = 0; i < 8; i++){
      for (int k = 0; k < 8; k++){
        this.map[i][k] = map[i][k];
      }
    }
    
    for (int i = 0; i < 8; i++){
      for (int k = 0; k < 8; k++){
        this.collisionMap[i][k] = -1;
      }
    }
    
    this.collisionMap[target[0]][target[1]] = 0; //<>//
    
    int j = 0;
    boolean keepGoing;
    while(true){
      keepGoing = false;
      for (int i = 0; i < 8; i++){
        for (int k = 0; k < 8; k++){
          if (this.collisionMap[i][k] == j){
            if (i > 0){
              if (this.map[i-1][k] == 0 && this.collisionMap[i-1][k] == -1){
                this.collisionMap[i-1][k] = j+1;
                keepGoing = true;
              }
            }
            if (i < 7){
              if (this.map[i+1][k] == 0 && this.collisionMap[i+1][k] == -1){
                this.collisionMap[i+1][k] = j+1;
                keepGoing = true;
              }
            }
            if (k > 0){
              if (this.map[i][k-1] == 0 && this.collisionMap[i][k-1] == -1){
                this.collisionMap[i][k-1] = j+1;
                keepGoing = true;
              }
            }
            if (k < 7){
              if (this.map[i][k+1] == 0 && this.collisionMap[i][k+1] == -1){
                this.collisionMap[i][k+1] = j+1;
                keepGoing = true;
              }
            }
          }
        }
      }
      j++;
     
      if (!keepGoing)
         break;
    }
    
    
    
  }
  
  public double getFitness(){
    double fitness = (this.getSteps()+1.0)/(this.getDistance() + 1.0);
    //fitness = 1-(1/(1+Math.exp(fitness)));   
    return fitness;
  }
  
  public int getDistance(){
    return this.collisionMap[this.me[0]][this.me[1]];  
  }
  
  public int[] getPosition(){
    return this.me;
  }
  
  public boolean canRun(){
    return (this.currentStep < this.amountStep && alive);
  }
  
  public int getSteps(){
    return (this.amountStep - this.currentStep);
  }
  
  public boolean getTarget(){
    return (me[0] == target[0] && me[1] == target[1]);
  }
  
  //0 - down
  //1 - right
  //2 - up
  //3 - left
  public int[] run(){
    
    if (currentStep < amountStep){
      int step = this.genome.get(currentStep);
      //println(currentStep+":"+step);
      currentStep++;
      if (step == 0){
        if (this.me[1] == 7){
          this.alive = false;
          return this.me;
        }
        if (this.map[this.me[0]][this.me[1]+1] == 1){
          this.alive = false;
          return this.me;
        }
        this.me[1]++;
        return this.me;
      }
      
      else if (step == 1){
        if (this.me[0] == 7){
          this.alive = false;
          return this.me;
        }
        if (this.map[this.me[0]+1][this.me[1]] == 1){
          this.alive = false;
          return this.me;
        }
        this.me[0]++;
        return this.me;
      }
      else if (step == 2){
        if (this.me[1] == 0) {
          this.alive = false;
          return this.me;
        }
        if (this.map[this.me[0]][this.me[1]-1] == 1){
          this.alive = false;
          return this.me;
        }
        this.me[1]--;
        return this.me;
      }
      else if (step == 3){
        if (this.me[0] == 0) {
          this.alive = false;
          return this.me;
        }
        if (this.map[this.me[0]-1][this.me[1]] == 1){
          this.alive = false;
          return this.me;
        }
        this.me[0]--;
        return this.me;
      }
    }
    return this.me;
   
  }
  
  public void restart(int[] origin){
    this.me = new int[2];
    this.me[0] = origin[0];
    this.me[1] = origin[1];
    this.currentStep = 0;
    this.alive = true;
  }
  
  public ArrayList<Integer> getGenome(){
    return this.genome;
  }
  
  
  
  @Override
  public int compareTo(Object o){
    if (o instanceof Robot){
      Robot aux = (Robot) o;
      if (this.getFitness() > aux.getFitness()){
        return -1;
      }else{
        return 1;
      }
    }else{
      return 1;
    }
  }
  
}
