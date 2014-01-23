float x, y;
float beatX, beatY;

boolean isOn;
float currentBeat;
float count;

float theta;
float d = 10;

float freq, amp, offset;
float margin = 30;

void setup() {
  // Size the window to fit 2 complete cycles of the sine wave
  size(int(720), 400);

  // Settings for sine wave
  freq = 5;
  amp = height/6;
  offset = calcOffset();

  // Draw beat 3/4 down the screen in the middle
  beatX = width*0.5;
  beatY = height*0.75;
  
  drawZeroLine();
}


void draw() {

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////// DRAW THE SINE WAVE //////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////

  // Why is amplitude negative here?
  y = sine(theta, freq, amp, amp+margin);

  // Start over
  if (x > width) {
    x = 0;
    drawZeroLine();
  }

  // Draw the sine wave
  fill(0, 128);
  ellipse(x, y, 1, 1);

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////// TOGGLE BEAT ACCORDING TO SINE WAVE //////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////

  // Draw background for bottom half
  fill(255);
  rect(0, height*0.5, width, height*0.5);
  
  // Turn beat on/off 
  if (isOn && count > currentBeat) {
    theta += TWO_PI/360;
    x++;
    currentBeat = int(sine(theta, freq, amp/10, amp/10));
    isOn = false;
    count = 0;
  }
  else if (!isOn && count > currentBeat) {
    isOn = true;
    count = 0;
  }  
  
  // Draw beat when on
  if (isOn) {
    fill(0);
    rect(beatX, beatY, d, d);
  }
  
  // Keep counting
  count++;
}

// Calculate sine values
float sine(float t, float f, float a, float o) {
  return sin(f*t)*a + o;
}

void drawZeroLine() {
    background(200);
    stroke(0, 64);
    line(0, offset, width, offset);
    noStroke();
}

float calcOffset() {
 return amp*2 + margin; 
}

void keyPressed() {

  switch(keyCode) {
  case UP:
    freq++;
    break;
  case DOWN:
    freq--;
    break;
  case RIGHT:
    amp++;
    break;
  case LEFT:
    amp--;
    break;
  } 

  // Don't let freq and amp go below zero
  if (freq < 1)
    freq = 1;
  if (amp < 0)
    amp = 0;
    
  offset = calcOffset();
}

