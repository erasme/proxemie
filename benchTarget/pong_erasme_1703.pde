import codeanticode.syphon.*; // Syphon
import oscP5.*; // OSC for controller

// Declare the syphon server
SyphonServer server;
// Graphics that will hold the syphon/spout texture to send
PGraphics canvas;

// OSC for controller
OscP5 oscReceiver;

// Declare a debug mode bool
boolean debug=false;

// PONG
PVector p1Pos, p2Pos, dir;
int pWidth, pHeight;
Balle[] balls;

// Obstacles
Obstacle[] obstacles;

// Malus
Malus[] malus;

// Bonus
Bonus[] bonus;


// Timer
int lastTime;
int timerLength;

// Score
int scoreL;//score left
int scoreR;//score right
PFont scoreFont;//score font


// Paramètres
int obstacles_number = 1;
int malus_number = 1;
int bonus_number = 1;


// Chargement images

PImage bg, bonusimg, malusimg;
color obstacle_color = color( 255, 205, 0);

// Niveaux
int lvl;
int scoreMax;


void settings(){
  // Set the initial frame size
  size(640, 400, P2D);
  PJOGL.profile=1; // Force OpenGL2 mode for Syphobn compatibility
}

void setup() {

  // Create the canvas that will be used to send the syphon output
  canvas = createGraphics(width, height, P2D);
  stroke(255);
  scoreFont = createFont ("Rostrot-BoldDynamisch.otf",42); 
  textAlign(CENTER);
  textFont(scoreFont); 
  
  //initial levels
  lvl = 1;
  scoreMax = 5;
  
  // Setup osc receiver for controls
  oscReceiver = new OscP5(this, 9000);
  
  // Create a syphon server to send frames out.
  if (platform == MACOSX) {
    server = new SyphonServer(this, "Processing Syphon");
  }
  
    //initial scores
  scoreL = 0;
  scoreR = 0;
  
  balls = new Balle[2];
  balls[0] = new Balle();
 
   // Crée le tableau d'obstacles
  obstacles = new Obstacle[obstacles_number];
  // Pour chaque case du tableau de bonus
  for(int i=0; i < obstacles.length; i++){
    // Crée un nouveau bonus
    obstacles[i] = new Obstacle();
  }
  
  
  // Crée le tableau de bonus
  bonus = new Bonus[bonus_number];
  // Pour chaque case du tableau de bonus
  for(int i=0; i < bonus.length; i++){
    // Crée un nouveau bonus
    bonus[i] = new Bonus();
  }
  
    // Crée le tableau de malus
  malus = new Malus[malus_number];
  // Pour chaque case du tableau de bonus
  for(int i=0; i < malus.length; i++){
    // Crée un nouveau bonus
    malus[i] = new Malus();
  }
  
  level1();
  initGame();
}


void level1() {
  
  // PONG
  
  bg = loadImage("img/niv1-fond.jpg");
  bonusimg = loadImage("img/niv1-bonus.png");
  malusimg = loadImage("img/niv1-malus.png");
  obstacle_color = color( 255, 205, 0);

  
  
// Paramètres
  obstacles_number = 1;
  malus_number = 1;
  bonus_number = 1;
  

}

void level2() {
  
  // PONG

  bg = loadImage("img/niv2-fond.jpg");
  bonusimg = loadImage("img/niv2-bonus.png");
  malusimg = loadImage("img/niv2-malus.png");
  obstacle_color = color( 240, 50, 0);
  
  
// Paramètres
  obstacles_number = 1;
  malus_number = 1;
  bonus_number = 1;
  

}


void level3() {
  
  // PONG

  bg = loadImage("img/niv3-fond.jpg");
  bonusimg = loadImage("img/niv3-bonus.png");
  malusimg = loadImage("img/niv3-malus.png");
  obstacle_color = color( 255, 30, 165);
  
  
// Paramètres
  obstacles_number = 1;
  malus_number = 1;
  bonus_number = 1;
  

}


void initGame() {
  
  // PONG
  p1Pos = new PVector(30, -100);
  p2Pos = new PVector(width-30, -100);
  pWidth = 20;
  pHeight = 100;
  
  balls[0].init(); 
  if(balls[1] != null){
    balls[1] = null;
  }

 
  startTimer(4000);
  
   // Obstacles
    for(int i=0; i < obstacles.length; i++){
      obstacles[i].init();
    }
    
    
    // Test superposition Malus / obstacles
     // ! signifie que l'on cherche à vérifier l'inverse que ce qu'on a déclaré
    
    for(int i=0; i < malus.length; i++){
      malus[i].init();
      for(int current_obstacle=0; current_obstacle < obstacles.length; current_obstacle++){
        if(obstacles[current_obstacle].isColliding(malus[i].position)){
          malus[i].init();
          current_obstacle = -1;
        }
      }
    } 
  /*  
      // Test superposition Bonus / Malus / obstacles
    for(int i=0; i < bonus.length; i++){
      bonus[i].init();
      while(bonus[i].isColliding(malusPos)){
        bonus[i].init();
      }
    }
*/

  for(int i=0; i < bonus.length; i++){
      bonus[i].init();
      for(int current_obstacle=0; current_obstacle < obstacles.length; current_obstacle++){
        if(obstacles[current_obstacle].isColliding(bonus[i].position)){
          bonus[i].init();
          current_obstacle = -1;
        }
      }
    } 

}




void draw() {

  // Draw a background for the window
  //background(0);
  image(bg, 0, 0);
  // Begin drawing the canvas
  canvas.beginDraw();
  //canvas.background(0);
  
  
  
  //reset paddles out
  //p1Pos.y = -1000;
  //p2Pos.y = -1000;
  
  //p1Pos.y = mouseY;
  //p2Pos.y = mouseY;
  
  
  
 
 // évolution vitesse dans le temps 
 if(isTimerEnded() == true){
    pHeight = 100;
    } 
   
    for (int nety=0;nety<height+50;nety=nety+20) {
      rect(width/2, nety, 10, 10);
      
  
    
    }
  canvas.image(bg, 0, 0);
  canvas.fill(255);
  canvas.rect(p1Pos.x - pWidth/2, p1Pos.y - pHeight/2, pWidth, pHeight);
  canvas.rect(p2Pos.x - pWidth/2, p2Pos.y - pHeight/2, pWidth, pHeight);
  for(int i=0; i<malus.length; i++){
    canvas.image(malusimg, malus[i].position.x, malus[i].position.y);
  }
  for(int i=0; i<bonus.length; i++){
    canvas.image(bonusimg, bonus[i].position.x, bonus[i].position.y);
  }
  for(int i=0; i<obstacles.length; i++){
    canvas.fill(obstacle_color);
    canvas.rect( obstacles[i].position.x - obstacles[i].width/2, obstacles[i].position.y - obstacles[i].height/2, obstacles[i].width, obstacles[i].height);
    canvas.fill(255);
  }
  
  // For each balle
  for(int i=0; i < balls.length; i++){
    if(balls[i] != null){

      // Ball
      balls[i].position = new PVector(balls[i].position.x + balls[i].dir.x, balls[i].position.y + balls[i].dir.y);
      // Test collisions
      if(balls[i].position.y > height || balls[i].position.y < 0){  // || signifie "ou"
        balls[i].dir.y *=-1;  // renvoie en sens inverse
        balls[i].position = new PVector(balls[i].position.x + balls[i].dir.x, balls[i].position.y + balls[i].dir.y);
      }    
    
      // P2 conditions vérifient que la balle n'a pas passé le joueur 2
      if(balls[i].position.x >= p2Pos.x - pWidth/2 && (balls[i].position.y > p2Pos.y - pHeight/2 && balls[i].position.y < p2Pos.y + pHeight/2)){  // && signifie "et"
       balls[i].dir.x *=-1;
       balls[i].position = new PVector(balls[i].position.x +balls[i].dir.x, balls[i].position.y + balls[i].dir.y);
      }
      // P1 conditions vérifient que la balle n'a pas passé le joueur 2
      if(balls[i].position.x <= p1Pos.x + pWidth/2 && (balls[i].position.y > p1Pos.y - pHeight/2 && balls[i].position.y < p1Pos.y + pHeight/2)){
       balls[i].dir.x *=-1;
       balls[i].position = new PVector(balls[i].position.x + balls[i].dir.x, balls[i].position.y + balls[i].dir.y);
      }
      
      // Obstacle
      for(int current_obstacle=0; current_obstacle<obstacles.length; current_obstacle++){
        if(obstacles[current_obstacle].isColliding(balls[i].position)){
          balls[i].dir.x = balls[i].dir.x * -1; // idem que : balls[i].dir.x *=-1;
          balls[i].position = new PVector(balls[i].position.x + balls[i].dir.x, balls[i].position.y + balls[i].dir.y);
        }
      }
      
      //Malus
      for(int current_malus=0; current_malus<malus.length; current_malus++){
        if(malus[current_malus].isColliding(balls[i].position)){
          // Effet du malus
          println("Malus");
          balls[1] = new Balle();
          malus[current_malus].init();
        }
      }
  
      // Bonus
      for(int current_bonus=0; current_bonus<bonus.length; current_bonus++){
        if(bonus[current_bonus].isColliding(balls[i].position)){
          // Effet du bonus
          println("Bonus");
          pHeight = 180;
          startTimer(10000);
        }
      }
      
      // OUT = GAMEOVER
      if(balls[i].position.x > p2Pos.x || balls[i].position.x < p1Pos.x /*|| balls[i].position.y > height || balls[i].position.y < 0 */) {
        if(balls[i].position.x > p2Pos.x) {
        scoreL++; //score +1
        }
        else if(balls[i].position.x < p1Pos.x) {
        scoreR++; //score +1
        }
        if(scoreL == scoreMax * lvl || scoreR == scoreMax * lvl){
          lvl = lvl + 1;
          switch(lvl) {
            case 1: 
              level1();
              break;
            
            case 2: 
              level2();
              break;
             
             case 3: 
              level3();
              break;
          }
        }
        
        initGame();
      }
      
    } // fin du test si balls[i] != null
   
  }
  
  canvas.fill(255);
  
  // For each balle
  for(int i=0; i < balls.length; i++){
    if(balls[i] != null){
      canvas.ellipse(balls[i].position.x, balls[i].position.y, 10, 10);
    }
  }
  
  //score position
  textSize (42);
  canvas.text (scoreL, width/2-50, 50);
  canvas.text (scoreR, width/2+50, 50);
  
  canvas.endDraw();
  
  // Draw the augmenta canvas in the window
  image(canvas, 0, 0, width, height);
  
  // Syphon output
  if (platform == MACOSX) {
    server.sendImage(canvas);
  }
 
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/handTracker/hand0") || theOscMessage.checkAddrPattern("/handTracker/hand0/")) {
              
    if(theOscMessage.get(1).floatValue() < 0.5){
      p1Pos.y = theOscMessage.get(0).floatValue() * height;
    }
    else {
      p2Pos.y = theOscMessage.get(0).floatValue() * height;
    }
    
  } else if (theOscMessage.checkAddrPattern("/handTracker/hand1") || theOscMessage.checkAddrPattern("/handTracker/hand1/")) {

    if(theOscMessage.get(1).floatValue() < 0.5){
      p1Pos.y = theOscMessage.get(0).floatValue() * height;
    }
    else {
      p2Pos.y = theOscMessage.get(0).floatValue() * height;
    }
    
  }
}

void startTimer(int _timerLength) {
  lastTime = millis();
  timerLength = _timerLength;
}

boolean isTimerEnded(){
 if(millis() - lastTime >= timerLength){
   return true;
 } else {
   return false;
 }
 

}