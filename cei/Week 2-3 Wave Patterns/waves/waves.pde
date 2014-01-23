float t = 0;
float f = .01;
float a = 50;
float ao = a*2;
float o = 0;


float x, y;
int freq, amp, base;
ArrayList<Wave>waves = new ArrayList<Wave>();
boolean isModFreq, isModAmp;

PrintWriter output;

void setup() {
  size(800, 600);
  background(255);
  waves.add(new Sine(t, f, a, o));
  waves.add(new Cosine(t, f, a, o));
  waves.add(new Tan(t, f, a, o));
  waves.add(new Square(t, f, a, o));
  waves.add(new Sawtooth(t, f, a, o));

  output = createWriter("waves.txt");
}

void draw() {
  x+=.5;

  if (isModFreq && isModAmp) {
    display(height/2, waves.get(base).mod(waves.get(freq).run(), waves.get(amp).run()));
  }
  else if (isModFreq) {
    display(height/2, waves.get(base).modFreq(waves.get(freq).run()));
  }
  else if (isModAmp) {
    display(height/2, waves.get(base).modAmp(waves.get(amp).run()));
  }
  else {
    display(height/2, waves.get(base).run());
  }

  //  display(ao, tan.modAmp(cosine.run()));
  //  display((height/5) + ao, cosine.run());
  //  display(2*(height/5) + ao, tan.run());
  //  display(3*(height/5) + ao, square.run());
  //  display(4*(height/5) + ao, saw.run());
  displayInstructions();
}

void displayInstructions() {
  fill(0);
  rect(0, 0, width, 50);
  fill(255);
  text("PRESS 1-5 TO PICK FREQ \t\t\t 0-6 TO PICK AMP \t\t\t SPACEBAR TO CYCLE THROUGH THE BASE WAVE", 10, 20);

  text("BASE: " + base + "\t\tFREQ: " + freq + "\t\tAMP: " + amp, 10, 40);
}

void display(float yoff, float y) {
  pushMatrix();
  translate(0, yoff);
  line(x, 0, x, y);
  popMatrix();
}

void keyPressed() {
  if (keyCode == ENTER) {
    output.flush();  // Writes the remaining data to the file
    output.close();  // Finishes the file
    exit();  // Stops the program
  }
  // SPACEBAR
  if (key == 32) {
    base++;
    base%=5;
    output.println(x + "," + base);
  } 
  else if (key == '`') {
    isModFreq = false;
    freq = -1;
  } 
  else if (key == '-') {
    isModAmp = false;
    amp = -1;
  }
  else {
    int num = key == '0' ? 9 : parseInt(key)-49;
    if (num >=0) {
      if (num < 6) {
        isModFreq = true;
        freq = num;
        output.println(x + "," + freq);
      }
      else if (num < 10) {
        amp = 9-num;
        output.println(x + "," + amp);
      }
    }
  }
}

