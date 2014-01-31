// Size of window, keep it square
int s = 400;

// Initialize the text to be nothing.
String text = "";

// Set font-size to 20
int tSize = 20;

// Modulo Thresholds
int[] ths = new int[4];

void setup() {

  // Create a window 400 pixels wide by 400 pixels tall
  size (s, s);

  // Set the text color to white
  fill(255);

  // Set textsize 
  textSize(tSize);
  textAlign(CENTER, CENTER);
  randomSeed(0);
  for (int i = 0; i < ths.length; i++) {
    ths[i] = int(random(1, 20));
  }
  
}

void draw() {
  background(0);
  // Display text in a grid
  // Start off-screen and end off-screen
  // by amounts based on text-size
  for (int x = 0; x <= width; x+=tSize/(mouseX*.01)) {
    for (int y = 0; y <= height; y +=tSize/(mouseY*.01)) {

      // calculate col and row position of text
      int col = (int) x / tSize;
      int row = (int) y / tSize;

      // Use modulo to play with different text

      // write "=" every 42nd column
      if (col%ths[0] == 0)
        text = "=";

      // Or write "^" every 18th row
      else if (row%ths[1] == 0)
        text = "^";

      // Or write ")" every 37th column
      else if (col%ths[2] == 0)
        text = ")";

      // Or write "(" every 6th row
      else if (row%ths[3] == 0)
        text = "(";

      // Otherwise write ">"
      else
        text = ">";

      text(text, x, y);
    }
  }
}

void keyPressed() {

  if (key == '1') {
    ths[0]++;
  }
  else if (key == 'q') {
    ths[0]--;
  }

  else if (key == '2') {
    ths[1]++;
  }
  else if (key == 'w') {
    ths[1]--;
  }
  else if (key == '3') {
    ths[2]++;
  }
  else if (key == 'e') {
    ths[2]--;
  }
  else if (key == '4') {
    ths[3]++;
  }
  else if (key == 'r') {
    ths[3]--;
  }

  for (int i = 0; i < ths.length; i++) {
    ths[i] = constrain(ths[i], 1, s);
    print(i + ": " + ths[i] + "\t");
  }
  print("\n");
  
}

