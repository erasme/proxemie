class Balle {
  
  PVector position, initDir, dir;
  int size;
 
  // Contructor
  Balle() {
    
  }
  
  void init(int _width, int _height){
    position = new PVector(_width/2, _height/2);
    initDir = new PVector(random(5,9), random(2,6));
    dir = initDir;
    size = 20;
 }
 
}