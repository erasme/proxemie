class Balle {
  
  PVector position, initDir, dir;
  int size;
 
  // Contructor
  Balle() {
    init();
  }
  
  void init(){
    position = new PVector(width/2, height/2);
    initDir = new PVector(random(5,9), random(2,6));
    dir = initDir;
    size = 20;
 }
 
}