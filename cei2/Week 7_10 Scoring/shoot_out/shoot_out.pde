Protagonist p = new Protagonist("Bobbi", );
Caracter [] caracters = new Caracter [3];
int clock = 300;
boolean hasStopped;


// Environmental factors
Curve curve = new Curve();

void setup() {
  size(400, 400);
}


void draw() {
  if (hasStopped) clock--;
  if (clock < 0) allDie();

  for (Caracter c : caracters) {
    c.run();
    if (c.hasDrawn() || p.hasDrawn()) {
      float delta = c.timeSinceDrawing - p.timeSinceDrawing;
      // somebody won
      if (abs(delta) > .5) {
        c.holdup = delta > 0 ? 1 : -1;
        p.holdup = delta > 0 ? 1 : -1;
      }
      // shoot out!
      else {
        p.takeHit(c.shoot());
        c.takeHit(p.shoot());
      }
    }
  }
}

void allDie() {
  background(255, 0, 0);
  textSize(128);
  textAlign(CENTER, CENTER);
  text("GAME OVER!", width/2, height/2);
}

void keyPressed() {
  hasStopped = true;


  switch(key) {
  case 1 :
  } 


  for (Caracter c : caracters) {
    c.react(key);
  }
}

