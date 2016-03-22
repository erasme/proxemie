class Bonus {
  
  PVector position;
  int radius;
 
  // Contructor
  Bonus() {
    init();
  }
  
  void init(){
    position = new PVector( random(200,400) , random(50,350) );
    radius = 21;
  }
  
  boolean isColliding(PVector other_position){
    float d = position.dist(other_position);
    if(d <= radius){
       return true;
    }
    return false;
  }
 
}