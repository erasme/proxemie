class Balle {

  PVector position, initDir, dir;
  int size;

  // Contructor
  Balle() {
  }

  void init(int _width, int _height) {
    position = new PVector(_width/2, _height/2);
    initDir = new PVector(random(5, 9), random(2, 6));

    float x = random(0, 1);
    if (x > 0.5) {
      initDir.x = initDir.x * -1;
    }
    
    float y = random(0, 1);
    if (y > 0.5) {
      initDir.y = initDir.y * -1;
    }

    dir = initDir;
    size = 20;
  }
}