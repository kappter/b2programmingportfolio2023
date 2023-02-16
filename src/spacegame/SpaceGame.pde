// Mr Kapptie | 29 Nov 2022 | SpaceGame
import processing.sound.*;
SoundFile laser;
SpaceShip s1;
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<PowerUp> powerups = new ArrayList<PowerUp>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
Timer rockTimer, puTimer;
Star[] stars = new Star[100];
int score, level;
boolean play;

void setup() {
  size(800, 800);
  laser = new SoundFile(this, "laser.wav");
  s1 = new SpaceShip();
  rockTimer = new Timer(500);
  rockTimer.start();
  puTimer = new Timer(5000);
  puTimer.start();
  for (int i=0; i<stars.length; i++) {
    stars[i] = new Star();
  }
  score = 0;
  level = 1;
  play = false;
}

void draw() {
  if (!play) {
    startScreen();
  } else {
    background(0);

    // Render Stars
    for (int i=0; i<stars.length; i++) {
      stars[i].display();
      stars[i].move();
    }
    noCursor();

    // Adding PowerUps
    if (puTimer.isFinished()) {
      powerups.add(new PowerUp());
      puTimer.start();
    }

    // Render PowerUps
    for (int i = 0; i < powerups.size(); i++) {
      PowerUp pu = powerups.get(i);
      if (pu.intersect(s1)) {
        if (pu.type == 'H') {
          s1.health+=100;
        } else if (pu.type == 'A') {
          s1.ammo+=100;
        } else if (pu.type == 'T') {
          s1.turretCount++;
        }
        powerups.remove(pu);
      }
      if (pu.reachedBottom()) {
        powerups.remove(pu);
      } else {
        pu.display();
        pu.move();
        println(powerups.size());
      }
    }

    // Adding Rocks
    if (rockTimer.isFinished()) {
      rocks.add(new Rock());
      rockTimer.start();
    }

    // Render Rocks
    for (int i = 0; i < rocks.size(); i++) {
      Rock r = rocks.get(i);
      if (s1.intersect(r)) {
        s1.health-=r.diam;
        score+=r.diam;
        // todo: add health to rock
        // todo: make and explosion sound
        // todo: make and explosion animation
        rocks.remove(r);
      }
      if (r.reachedBottom()) {
        rocks.remove(r);
      } else {
        r.display();
        r.move();
        println(rocks.size());
      }
    }

    // Render Lasers and detect collision
    for (int i = 0; i < lasers.size(); i++) {
      Laser l = lasers.get(i);
      for (int j = 0; j< rocks.size(); j++) {
        Rock r = rocks.get(j);
        if (l.intersect(r)) {
          score+=r.diam;
          // does something happen to level?
          // add explode sound
          // add an animation
          lasers.remove(l);
          //r.health-=50;
          rocks.remove(r);
        }
      }
      // for loop for rocks
      if (l.reachedTop()) {
        lasers.remove(l);
      } else {
        l.display();
        l.move();
      }
    }

    s1.display();
    s1.move(mouseX, mouseY);
    //if (mousePressed) {
    //  //l1.display(s1.x, s1.y);
    //}
    ////l1.move();
    //r1.display();
    //r1.move();
    infoPanel();

    if (s1.health<1) {
      gameOver();
    }
  }
}

void mousePressed() {
  //laser.play();
  if (s1.fire() && s1.turretCount == 1) {
    lasers.add(new Laser(s1.x, s1.y));
    println(lasers.size());
  } else if (s1.fire() && s1.turretCount == 2) {
    lasers.add(new Laser(s1.x-20, s1.y));
    lasers.add(new Laser(s1.x+20, s1.y));
    println(lasers.size());
  } else if (s1.fire() && s1.turretCount == 3) {
    lasers.add(new Laser(s1.x, s1.y));
    lasers.add(new Laser(s1.x-20, s1.y));
    lasers.add(new Laser(s1.x+20, s1.y));
    println(lasers.size());
  }
}
void keyPressed() {
}

void infoPanel() {
  fill(128, 128);
  rectMode(CENTER);
  rect(width/2, 25, width, 50);
  fill(255);
  textSize(35);
  textAlign(CENTER);
  text("Score:" + score +
    " | Health:" + s1.health +
    " | Level:" + level +
    " Ammo:" + s1.ammo, width/2, 40);
}

void startScreen() {
  background(0);
  fill(255);
  textAlign(CENTER);
  text("Press any key to begin...", width/2, height/2 );
  if (keyPressed) {
    play = true;
  }
}

void gameOver() {
  background(0);
  fill(255);
  textAlign(CENTER);
  text("Game Over!", width/2, height/2 );
  //play = false;
  noLoop();
}
