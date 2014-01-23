import ddf.minim.*;

Minim minim;
AudioPlayer player;
boolean play, mute, linear;


PImage img;
float volume, m, a;

int mode = 2;
int modes = 3;

float x, xspeed;

void setup() {
  size(displayWidth/2, displayHeight/2);
  minim = new Minim(this);
  load();
}

void draw() {
  background(0);
  tint(255, a);
  image(img, 0, -height/3);
  if (play) {
    wave();
  }
}

void wave() {
  float amp = 30;
  float newVolume = 0;
  for (int i = 0; i < player.bufferSize() - 1; i++) {
    newVolume += (abs(player.left.get(i)) + abs(player.right.get(i))); 
    stroke(255, 100);
    line(i, amp + player.left.get(i)*amp, i+1, amp + player.left.get(i+1)*amp);
    line(i, amp*2 + player.right.get(i)*amp, i+1, amp*2 + player.right.get(i+1)*amp);
  }

  if (linear) { 
    float progress = x/width;
    m = progress > .8 ? m*1.01 : 128;
    a = (x/width)*m;
    println("PROGRESS: " + progress + "\tMULT: " + m + "\tALPHA: " + a);
  }
  else {
    float delta = newVolume-volume;

    //If changing direction, reset multiplier
    if (delta < 0) {
      m = 0;
    }
    m += (delta > 0 ? delta : 1)*0.001;
    float aspeed = volume*m;
    a*=.95;
    a += aspeed + x*.1;
    if (a < 1)
      a = 1;
    println("MULT: " + m + "\tALPHA: " + a + "ASPEED: " + aspeed);
  }

  x+= play ? xspeed/frameRate : 0;
  fill(255);
  ellipse(x, (a/255)*height, 10, 10);


  noStroke();
  volume = newVolume;
}

void load() {

  x = 0;
  m = 0;
  a = 0;

  img = loadImage(mode + ".jpg");
  float ratio = img.width/img.height;
  img.resize(width, int(width*ratio));

  player = minim.loadFile(mode + ".mp3");

  if (play) {
    player.play();
  }

  float duration = player.length()/1000;
  xspeed = width/duration;

  background(0);
}

void keyPressed() {
  if (key == '32') {
    play = !play;
    if (play) {    
      player.play();
      a = 0;
    }
    else {
      player.pause();
    }
  }




  switch(keyCode) {
  case SHIFT:
    linear = !linear;
    break;
  case UP: 
    mode++;
    player.pause();
    load(); 
    break;
  case DOWN:
    mode--;
    player.pause();
    load(); 
    break;
  case RIGHT:
    a++;
    break;
  case LEFT:
    a--;
    break;  
  case TAB:
    mute = !mute;
    if (mute) {
      player.mute();
    }
    else {
      player.unmute();
    }
    break;
  }
  
  mode = constrain(mode, 0, modes);
  a = constrain(a, 0, 255);

}

