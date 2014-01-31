float x, y;
float movingX, movingY, xSpeed;
float theta;

float d = 10;
float freq, amp, offset;

void setup() {
  // Size the window to fit 2 complete cycles of the sine wave
  size(int(720), 400);

  // Settings for sine wave
  freq = 1;
  amp = height/6;
  offset = height/4;
  
  // Draw ball half-way down the window
  movingY = height*0.5;
  
  drawZeroLine();

}


void draw() {
  
  // Move around the "circle" 1-degree at a time
  theta+=TWO_PI/360;
  
  
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////// DRAW THE SINE WAVE //////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////


  // Why is amplitude negative here?
  y = sine(theta, freq, -amp, offset);
  x++; 

  // Start over
  if (x > width) {
    x = 0;
    drawZeroLine();
  }

  // Draw the sine wave
  fill(0, 128);
  rect(x, y, 1, 1);

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ///////////////////// MOVE THE BALL ACCORDING TO SINE WAVE /////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  
  // Draw background for bottom half
  fill(255);
  rect(0, height*0.5, width, height*0.5); 

  // Affect speed with the sine wave
  // Try both versions, what's the difference?
  xSpeed = sine(theta, freq, amp, 0); 
  //xSpeed = sine(theta, freq, amp/10, amp/10); 
  
  if (movingX > width) {
    movingX = 0;
  }
  else if (movingX < 0) {
    movingX = width;
  }
  
  // Move the rect
  movingX+=xSpeed;

  // Draw the sine wave
  fill(0);
  rect(movingX, movingY, d, d);

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
  if(freq < 1)
    freq = 1;
  if(amp < 0)
    amp = 0;
}

