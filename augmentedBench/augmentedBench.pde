/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;
import codeanticode.syphon.*; // Syphon

OscP5 oscP5;
NetAddress myRemoteLocation;

// Declare the syphon server
SyphonServer server;

// Graphics that will hold the syphon/spout texture to send
PGraphics canvas;
PFont scoreFont1;//score font
PFont scoreFont2;//score font
PFont scoreFont3;//score font

boolean LeftPersonIsHere = false;
boolean RightPersonIsHere = false;
boolean PongNeedSetup = true;

PImage imgTarget1;
PImage imgTarget2;
PImage imgLueurLeft;
PImage imgLueurRight;
PImage imgMessageIntro;
PImage imgLogo;

float transparencyLeft = 255;
float transparencyRight = 255;
float transparencyMessage = 255;
float transparencyLogo = 255;

Pong pong;

// Timer
Timer timerLaunchGame;



void settings() {
  // Set the initial frame size
  //size(1920, 1080, P2D);
  fullScreen(P2D, 1);
  PJOGL.profile=1; // Force OpenGL2 mode for Syphobn compatibility
}

void setup() {
  //  size(1920,1080);
  frameRate(60);


  // Create the canvas that will be used to send the syphon output
  canvas = createGraphics(width, height, P2D);


  // Load images
  imgTarget1 = loadImage("img/cible1-1.png");
  imgTarget2 = loadImage("img/cible1-2.png");
  imgMessageIntro = loadImage("img/messageintro.png");
  imgLueurLeft = loadImage("img/lueurleft.png");
  imgLueurRight = loadImage("img/lueurright.png");
  imgLogo = loadImage("img/logocouleur.png");

  // Setup pong
  pong = new Pong();
  pong.setup();

  //new timerBonus
  timerLaunchGame = new Timer();


  // affichage score
  scoreFont1 = loadFont ("OCRAStd-48.vlw"); 
  scoreFont2 = loadFont ("Megatron-48.vlw"); 
  scoreFont3 = loadFont ("Rostrot-SemiboldDynamisch-48.vlw"); 


  // Create a syphon server to send frames out.
  if (platform == MACOSX) {
    server = new SyphonServer(this, "Processing Syphon");
  }

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 7000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}


void draw() {

  // Update the pong
  if (LeftPersonIsHere == true && RightPersonIsHere == true) {
    if (PongNeedSetup == true) {
      pong.setup(); 
      PongNeedSetup = false;
      timerLaunchGame.startTimer(5000);
    }
    if ( timerLaunchGame.isTimerEnded() ) {
      pong.update();
    }
  } else {
    PongNeedSetup = true;
  }

  // Begin drawing the canvas
  canvas.beginDraw();

  background(0);


  if (LeftPersonIsHere == true) { 
    if (transparencyLeft > 0) { 
      transparencyLeft -= 5;
    }
  } else { 
    if (transparencyLeft < 255) { 
      transparencyLeft += 5;
    }
  }

  if (RightPersonIsHere == true) { 
    if (transparencyRight > 0) { 
      transparencyRight -= 5;
    }
  } else { 
    if (transparencyRight < 255) { 
      transparencyRight += 5;
    }
  }

  if (LeftPersonIsHere == true || RightPersonIsHere == true) { 
    if (transparencyMessage < 255) { 
      transparencyMessage += 5;
    }
  } else { 
    if (transparencyMessage > 0) { 
      transparencyMessage -= 5;
    }
  }  

  if (LeftPersonIsHere == true && RightPersonIsHere == true) { 
    if (transparencyLogo < 255) { 
      transparencyLogo += 5;
    }
  } else { 
    if (transparencyLogo > 0) { 
      transparencyLogo -= 5;
    }
  }  

  canvas.imageMode(CENTER);
  if (! timerLaunchGame.isTimerEnded() ) {
  canvas.tint(255, transparencyMessage);  
  canvas.image(imgMessageIntro, width/2, height/2, imgMessageIntro.width/2, imgMessageIntro.height/2);
  }

  canvas.tint(255, transparencyLeft * (sin(millis() * 0.001)+1)/2*0.8);
  canvas.image(imgLueurLeft, width*0.3, height*0.5, imgLueurLeft.width*0.6, imgLueurLeft.height*0.6);

  canvas.tint(255, transparencyRight * (sin(millis() * 0.001)+1)/2*0.8);
  canvas.image(imgLueurLeft, width*0.7, height*0.5, imgLueurLeft.width*0.6, imgLueurLeft.height*0.6);


  canvas.pushMatrix();
  canvas.translate(width*0.3, height*0.5); // Move away from the center
  canvas.rotate(millis() * 0.0001 * PI);    // One revolution every second
  canvas.tint(255, transparencyLeft);
  canvas.image(imgTarget1, 0, 0, imgTarget1.width*0.6, imgTarget1.height*0.6);
  canvas.popMatrix();

  canvas.pushMatrix();
  canvas.translate(width*0.3, height*0.5); // Move away from the center
  canvas.rotate(millis() * -0.0001 * PI);    // One revolution every second
  canvas.tint(255, transparencyLeft);
  canvas.image(imgTarget2, 0, 0, imgTarget2.width*0.6, imgTarget2.height*0.6);
  canvas.popMatrix();

  canvas.pushMatrix();
  canvas.translate(width*0.7, height*0.5); // Move away from the center
  canvas.rotate(millis() * 0.0001 * PI);    // One revolution every second
  canvas.tint(255, transparencyRight);
  canvas.image(imgTarget1, 0, 0, imgTarget1.width*0.6, imgTarget1.height*0.6);
  canvas.popMatrix();

  canvas.pushMatrix();
  canvas.translate(width*0.7, height*0.5); // Move away from the center
  canvas.rotate(millis() * -0.0001 * PI);    // One revolution every second
  canvas.tint(255, transparencyRight);
  canvas.image(imgTarget2, 0, 0, imgTarget2.width*0.6, imgTarget2.height*0.6);
  canvas.popMatrix();



  // Draw the pong
  canvas.tint(255);
  if (LeftPersonIsHere == true && RightPersonIsHere == true) {
    canvas.image(pong.canvas, width/2, height/2, pong.canvas.width*0.8, pong.canvas.height*0.8);

    if ( timerLaunchGame.isTimerEnded() ) {
      // Affichage du logo
      // Endroit
      canvas.pushMatrix();
      canvas.translate(width*0.15, height*0.55);
      canvas.rotate(PI/2);
      canvas.image(imgLogo, 0, 0, imgLogo.width*0.3, imgLogo.height*0.3);
      canvas.popMatrix();

      // Envers
      canvas.pushMatrix();
      canvas.translate(width*0.87, height*0.55);
      canvas.rotate(PI/-2);
      canvas.image(imgLogo, 0, 0, imgLogo.width*0.3, imgLogo.height*0.3);
      canvas.popMatrix();

      // Affichage du score endroit
      canvas.textSize(48);
      canvas.text (pong.scoreL, width*0.35, height*0.9);
      canvas.text (pong.scoreR, width*0.65, height*0.9);
      canvas.textSize(32);
      canvas.text ("niveau "+pong.lvl, width*0.5, height*0.9);
      canvas.translate(width*0.35, height*0.2);

      // Affichage du score envers
      canvas.rotate(PI);
      canvas.textSize(48);
      canvas.text (pong.scoreL, 0, 0);
      canvas.text (pong.scoreR, width*-0.3, 0);
      canvas.textSize(32);
      canvas.text ("niveau "+pong.lvl, width*-0.15, 0);
      canvas.rotate(PI);
    }
  }





  //score position
  canvas.textSize (62);
  canvas.textAlign(CENTER);


  switch(pong.lvl) {
  case 1: 
    canvas.textFont(scoreFont1);
    break;

  case 2: 
    canvas.textFont(scoreFont2);
    break;

  case 3: 
    canvas.textFont(scoreFont3);
    break;
  }




  canvas.endDraw();

  // Syphon output
  if (platform == MACOSX) {
    server.sendImage(canvas);
  }

  // Draw the canvas in the window
  image(canvas, 0, 0, width, height);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/benchLeft/personEntered")) {
    LeftPersonIsHere = true;
  } else if (theOscMessage.checkAddrPattern("/benchLeft/personWillLeave")) {
    LeftPersonIsHere = false;
  } else if (theOscMessage.checkAddrPattern("/benchRight/personEntered")) {
    RightPersonIsHere = true;
  } else if (theOscMessage.checkAddrPattern("/benchRight/personWillLeave")) {
    RightPersonIsHere = false;
  }
}