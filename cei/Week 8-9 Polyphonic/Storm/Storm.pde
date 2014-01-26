float x, y;
int baseline;


float frequency = 0.005;
float amplitude;

int type;
String [] types = { 
  "SIN", "COS", "TAN", "SQU", "SAW"
};

int max = 3;
float scale = 0.1;
float ground;
ArrayList<Voice> voices = new ArrayList<Voice>();

Dartboard db = new Dartboard();
Rain rain = new Rain();
Flock crows = new Flock();

void setup() {
  size(800, 600);
  background(255);
  baseline = height;
  amplitude = height/(max*2);
  ground = height-(amplitude*max*2*scale);

  for (int i = 0; i < max; i++) {
    voices.add(new Voice(i, 0));
  }
}

void draw() {
  noStroke();
  fill(200);
  rect(0, 0, width, ground);

  if (x > width) {
    background(255);
    x = 0;
  }
  if (frameCount % 10 == 0) {
    x+=.5;

    float offset = 0;
    float [] values = new float [voices.size()];
    float [] offsets = new float [voices.size()];

    for (int i = 0; i < voices.size(); i++) {
      Voice thisVoice = voices.get(i);
      if (thisVoice.on) {
        float value = thisVoice.run();
        display(value, offset, thisVoice.col);
        offset += value;
        values[i] = value;
      }
      else {
        values[i] = 0;
      }
      offsets[i] = offset;
    }

    int i = db.fire(0, height-50, offsets);
    if (i >=0) {
      float y = values[i];
      float yoff = offsets[i] - y;
      display(y, yoff, color(255, 0, 0, 100));
    }

    switch(i) {
    case 0:
      rain.add(values[i]*0.01);
      break;
    case 1:
      fill(255, 100);
      rect(0, 0, width, ground);
      break;
    case 2:
      crows.addBoid(new Boid(width, random(height)));
      break;
    }
  }

  rain.run();
  crows.run();
  label();
}

void display(float y, float yoff, color col) {
  pushMatrix();
  translate(0, baseline-(yoff*scale));
  stroke(col);
  line(x, 0, x, (-y*scale));
  noStroke();
  popMatrix();
}


void label() {
  fill(0);
  rect(0, 0, width, 50);
  fill(255);

  String waveTypes = "";
  for (int i = 0; i < voices.size(); i++) {
    waveTypes += (i+1) + ": " + voices.get(i).getType() + "\t\t";
  }

  text("Spacebar to change TYPE: " + types[type]  + "\t\t\t\u2B0C AMP: " + amplitude + "\t\t\t\u2B0D FREQ: " + frequency, 10, 20);
  text("Pres NUM KEY to turn on VOICE: " + waveTypes, 10, 40);
}

void keyPressed() {
  // Toggle Voices on and off
  int index = parseInt(key)-49;
  if (index >=0 && index < max) {
    voices.get(index).toggle(type);
  }

  switch(keyCode) {
  case UP:
    frequency += frequency < .01 ? 0.001 : .01;
    break;
  case DOWN:
    frequency -= frequency < .01 ? 0.001 : .01;    
    break;
  case RIGHT:
    amplitude++;
    break;
  case LEFT:
    amplitude--;
    break;
  }

  if (key == 32) {
    type++;
    type%=types.length;
  }

  frequency = constrain(frequency, 0.001, PI);
  amplitude = constrain(amplitude, 0, width);
}

