class Obstacle {
  
  PVector position;
  int width, height;
 
  // Contructor
  Obstacle() {
    init();
  }
  
  void init(){
    position = new PVector( random(200,400) , random(50,350) );
    height = 100;
    width = 10;
  }
  
  boolean isColliding(PVector other_position){
    if(other_position.x >= position.x - width/2  && other_position.x <= position.x + width/2 && other_position.y >= position.y - height/2  && other_position.y <= position.y + height/2 ){
       return true;
    }
    return false;
  }
  
  boolean isCollidingWithObstacle(Obstacle other_obstacle){
    if(other_obstacle.position.x - other_obstacle.width/2 > position.x + width/2
       || other_obstacle.position.x + other_obstacle.width/2 < position.x - width/2
       || other_obstacle.position.y - other_obstacle.height/2 > position.y + height/2
       || other_obstacle.position.y + other_obstacle.height/2 < position.y - height/2 ){
       return false;
    }
    return true;
  }
 
}