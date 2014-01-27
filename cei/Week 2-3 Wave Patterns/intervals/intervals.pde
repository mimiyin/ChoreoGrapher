//Import the library
import themidibus.*; 
MidiBus myBus; // The MidiBusint 
int channel = 10;
int velocity = 127;
int pitch = 96;

float x, y, prevX, xPos;

float w = 1;
float h = 10;

float d;
float interval = 1;
float frequency = 0.1;
float amplitude = 20;

int mode = 0;
String [] modes = { 
  "RANDOM", "SINE", "TAN", "MANUAL"
};

void setup() {
  size(800, 400);
  background(255);
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.    
  myBus = new MidiBus(this, -1, "Java Sound Synthesizer"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
}

void draw() {

  if (x-prevX >= interval) {
    fill(0);
    rect(x, y, w, h);
    interval = calc();
    prevX = x;
    myBus.sendNoteOff(channel, pitch, velocity);
    myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
  }
  // SOUND VERSION
  x++;
  
  // VISUAL VERSION
  //x+=interval;

  if (x > width) {
    y += h;
    x = -(x-width);
    prevX = x;
  }

  if (y > height) {
    background(255);
    x = 0;
    y = 0;
  }

  println("MODE: " + modes[mode] + "\tAMP: " + amplitude + "\tFREQ: " + frequency);
}

float calc() {

  d+=frequency;
  switch(mode) {
  case 0:
    return random(amplitude);
  case 1:
    return sin(d)*amplitude/2 + amplitude/2;
  case 2:
    return abs(tan(radians(d)))*amplitude + 1;
  default:
    return interval;
  }
}

void keyPressed() {

  switch(keyCode) {
  case UP:
    interval++;
    break;
  case DOWN:
    interval--;
    break;
  case RIGHT:
    mode++;
    break;
  case LEFT:
    mode--;
    break;
  }
  
  if (key == 'f' || key == 'v') {
    frequency += (key == 'f' ? 0.001 : -0.001);
    frequency = constrain(frequency, 0.001, PI);
  }
  else if (key == 'a' || key == 'z') {
    amplitude += (key == 'a' ? 10 : -10);
    amplitude = constrain(amplitude, 0, width);
  }
  
  interval = constrain(interval, 1, width);
  mode = constrain(mode, 0, modes.length-1);
}

