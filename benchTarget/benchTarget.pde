/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

boolean LeftPersonIsHere = false;
boolean RightPersonIsHere = false;

PImage imgLeft;
PImage imgRight;
PImage imgMessage;

float transparencyLeft = 255;
float transparencyRight = 255;
float transparencyMessage = 255;

void setup() {
  size(1280,800);
  frameRate(25);
  
  imgLeft = loadImage("img/cible_j1.png");
  imgRight = loadImage("img/cible_j2.png");
  imgMessage = loadImage("img/message.png");
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,7000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
}


void draw() {
  background(0);

  
if (LeftPersonIsHere == true) { 
  if (transparencyLeft < 255) { transparencyLeft += 5; }
  
}
  
else { 
  if (transparencyLeft > 0) { transparencyLeft -= 5; }
  tint(255, transparencyLeft);  
  }
  
if (RightPersonIsHere == true) { 
  if (transparencyRight < 255) { transparencyRight += 5; }
  tint(255, transparencyRight);

  } 
else { 
  if (transparencyRight > 0) { transparencyRight -= 5; }
  tint(255, transparencyRight);
  
  }
  
if (LeftPersonIsHere == true || RightPersonIsHere == true){ 
  if (transparencyMessage < 255) { transparencyMessage += 5; }
  tint(255, transparencyMessage);

  } 
else { 
  if (transparencyMessage > 0) { transparencyMessage -= 5; }
  tint(255, transparencyMessage);
  
  }  
  
  tint(255, transparencyMessage);  
  image(imgMessage, 300, 320);
  
  tint(255, transparencyLeft);
  image(imgLeft, 150, 0);
  
  tint(255, transparencyRight);
  image(imgRight, 820, 0);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/benchLeft/personEntered")) {
    LeftPersonIsHere = true;
  } else if (theOscMessage.checkAddrPattern("/benchLeft/personWillLeave")) {
    LeftPersonIsHere = false;
  }
  
  else if (theOscMessage.checkAddrPattern("/benchRight/personEntered")) {
    RightPersonIsHere = true;
  } else if (theOscMessage.checkAddrPattern("/benchRight/personWillLeave")) {
    RightPersonIsHere = false;
  }
}