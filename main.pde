int windowSize = 640;
int rectSize;
int offset = 5;
int[][] map;
int[] current = {0, 0};
int state = 0;

int[] origin = {-1,-1};
int[] reset;
int[] target = {-1,-1};

int time;

//Robot robot;
Population population;
void setup() {
  size(650, 650);
  background(125);
  rectSize = windowSize/8;

  map = new int[8][8];
  for (int i = 0; i < 8; i++) {
    for (int k = 0; k < 8; k++) {
      map[i][k] = 0;
    }
  }
  
  time = 0;
  
  //robot = new Robot(20);
  population = new Population(10,30);
}

void draw() {
  maze();
  if (state ==3){
    if (population.canRobotRun()){
      origin = population.run();
      delay(time);
      if (population.didRobotGetTarget()){
        if (population.isThereRobot()){
          population.nextRobot();
          origin = population.getRobotPosition();
          
        } else {
          population.getFitness();
          origin = population.nextGeneration();
          
        } 
      }
      delay(time);
    } else{
      if (population.isThereRobot()){
        population.nextRobot();
        origin = population.getRobotPosition();
        delay(time);
        //println("nextRobot");
        //state = 4;
      }else{
        population.getFitness();
        origin = population.nextGeneration();
        delay(time);
        //state = 4;
      }
    }
  }
}

void maze() {
  for (int i = 0; i < 8; i++) {
    for (int k = 0; k < 8; k++) {
      int bx = i*rectSize;
      int by = k*rectSize;


      if (state == 0){
        if (overRect(bx, by) || map[i][k] == 1) {
          fill(0);
        } else {
          fill(255);
        }
      } else if (state == 1){
        if (map[i][k] == 1){
          fill(0);
        }else fill(255);
        
        if (overRect(bx,by)) fill(0,255,0);
        else if (origin[0] == i && origin[1] == k) fill(0,255,0);
        else fill(255 - 255*map[i][k]);
      } else if (state == 2){
        if (map[i][k] == 1) fill(0);
        else fill(255);
        
        if (origin[0] == i && origin[1] == k) fill(0,255,0);
        else fill(255 - 255*map[i][k]);
        
        if (overRect(bx,by)) fill(255,0,0);
        else if (origin[0] == i && origin[1] == k) fill(0,255,0);
        else if (target[0] == i && target[1] ==k) fill(255,0,0);
        else fill(255-255*map[i][k]);
      } else if (state >= 3){
        if (map[i][k] == 1) fill(0);
        else fill(255);
        
        fill(255 - 255*map[i][k]);
        if (target[0] == i && target[1] == k) fill(255,0,0);
        if (origin[0] == i && origin[1] == k) fill(0,255,0);
        
      }
      rect(bx+offset, by+offset, rectSize, rectSize);
    }
  }
}

boolean overRect(int bx, int by) {
  if (mouseX >= bx && mouseX <= bx+rectSize && mouseY >= by && mouseY <= by+rectSize) {
    current[0] = bx/rectSize;
    current[1] = by/rectSize;
    return true;
  }
  return false;
}

void mousePressed() {
  if (state == 0)
    map[current[0]][current[1]] = 1;
  else if (state == 1){
    if (map[current[0]][current[1]] == 1)
      return;
    origin[0] = current[0];
    origin[1] = current[1];
    reset = origin;
  }
  else if (state == 2){
    if (map[current[0]][current[1]] == 1)
      return;
    if (origin[0] == current[0] && origin[1] == current[1])
      return;
      
    target[0] = current[0];
    target[1] = current[1];
  }
}

void keyPressed() {
  if (keyCode == 82){
    origin = reset;
    println("ok");
  }
  else if (keyCode == 32) {
    switch (state) {
    case 0:
      state = 1;
      break;
    case 1:
      state = 2;
      break;
    case 2:
      state = 3;
      //robot.start(map,origin,target);
      population.prepare(map,origin,target);
      println("Generation: 1");
      break;
    default:
      time = 500;
    }
  }
}
