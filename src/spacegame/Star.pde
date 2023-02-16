class Star {
  int x, y, diam, speed;

  // Constructor
  Star() {
    x = int(random(width));
    y = int(random(height));
    diam = int(random(1, 3));
    speed = int(random(2, 5));
  }

  void display() {
    fill(222, 255, 0);
    circle(x, y, diam);
  }

  void move() {
    if (y>height+5) {
      y= -10;
    } else {
      y += speed;
    }
  }

  boolean reachedBottom() {
    return true;
  }
}
