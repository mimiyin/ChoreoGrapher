float x, y;
int baseline;


float freq = 0.005;
float amp = 50;
float off = 0;

int type;
String [] types = { "SIN", "COS", "TAN", "SQU", "SAW" };

int max = 5;
ArrayList<Voice> voices = new ArrayList<Voice>();

Dartboard db = new Dartboard();

boolean showWaves;

void draw() {
  x+=.5;

  if (x > width) {
    background(255);
    x = 0;
  }

  PVector offset = new PVector(0, 0);
  float [] values = new float [voices.size()];
  PVector [] offsets = new PVector [voices.size()];

  for (int i = 0; i < voices.size(); i++) {
    Voice thisVoice = voices.get(i);
    if (thisVoice.on) {
      float value = thisVoice.run(offset);
      if(showWaves) {
        display(value, value <= 0 ? offset.x : offset.y, thisVoice.col);
      }
      if (value >=0) {
        offset.y += value;
      }
      else {
        offset.x += value;
      }
      values[i] = value;
    }
    else {
      values[i] = 0;
    }
    offsets[i] = new PVector(offset.x, offset.y);
  }

  int i = db.fire(offset.x, offset.y, offsets);
  float y = values[i];
  float yoff = (y < 0 ? offsets[i].x : offsets[i].y) - y;
  display(y, yoff, color(255, 0, 0, 100));  

  label();
}

void display(float y, float yoff, color col) {
  pushMatrix();
  translate(0, yoff + baseline);
  stroke(col);
  line(x, 0, x, y);
  popMatrix();
}


void label() {
  noStroke();
  fill(0);
  rect(0, 0, width, 50);
  fill(255);

  String waveTypes = "";
  for (int i = 0; i < voices.size(); i++) {
    waveTypes += i + ": " + voices.get(i).getType() + "\t\t";
  }

  text("TYPE: " + types[type] + "\t\t\t\tFREQ: " + Float.toString(freq).substring(0, 5) + "\tAMP: " + amp, 10, 20);
  text("PRESS UP TO ADD WAVES: " + waveTypes, 10, 40);
}

void keyPressed() {
  // Toggle Voices on and off
  int index = parseInt(key)-49;
  if (index >=0 && index < max) {
    voices.get(index).toggle(type);
  }

  switch(keyCode) {
  case UP:
    freq+=.001;
    break;
  case DOWN:
    freq-=.001;
    break;
  case RIGHT:
    amp++;
    break;
  case LEFT:
    amp--;
    break;
  case ENTER:
    showWaves = !showWaves;
    break;
  }

  freq = constrain(freq, 0.001, PI);
  amp = constrain(amp, 1, 100);

  if (key == '=') {
    type++;
  }
  else if (key == '-') {
    type--;
  }

  type = constrain(type, 0, 4);
}

