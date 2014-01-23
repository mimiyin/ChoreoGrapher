import ddf.minim.*;

Minim minim;
AudioPlayer player;

int counter;
int divider = 60;
boolean on;

int mode = 0;
int modes = 1;

void setup() {
  size(400, 400);
  load();
}

void draw() {
  counter++;

  if (counter % divider == 0) {
    on = !on;
  }

  if (on) {
    background(0);
    player.play();
  }
  else {
    background(255);
    player.pause();
  }
}

void load() {

  minim = new Minim(this);
  player = minim.loadFile(mode + ".mp3");

  background(0);
}

void keyPressed() {

  if (key == 32) {
    mode++;
    mode%=modes;
    player.pause();
    load();
  }

  switch(keyCode) {
  case UP:
    divider++;
    break;
  case DOWN:
    divider--;
    break;
  }

  if (divider < 1) {
    divider = 0;
  }
}

