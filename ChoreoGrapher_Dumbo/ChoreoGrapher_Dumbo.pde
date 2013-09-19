int fRate = 30;

// Gatekeepers for drawing, playing and exporting modes
boolean isDrawable, isDrawing;
boolean isPlayable, isExporting;
String exportPath;

// Controls
String [] menus = { 
  "CONTROLS", "MOTIFS"
};

// Voices
ArrayList<Voice> voices;
color[] colors = { 
  color(255, 0, 67), color(0, 153, 0), color(226, 202, 81), color(96, 136, 136), color(255, 102, 0)
};
Voice selected;

// Managing moving through your content
Storyboard sb;

// Keeping track oftime
// elapsed since clicking
// Play button
float timer, startTime;
ToggleButton play;
Button clearAll, clear;

// Highest point you can draw
int mouseYMin = 50;
int mouseXMin = 100;

void setup() {
  size(1024, 680);

  play = new ToggleButton("Play", menus[0], 1, "Stop");
  clearAll = new Button("Clear All", menus[0], 2);
  clear = new Button("Clear", menus[0], 3);

  imageMode(CENTER);
  frameRate(fRate);

  sb = new Storyboard();
  voices = new ArrayList<Voice>();

  reset(true);

  // Create 5 voices 
  for (int i = 0; i < colors.length; i++) {
    addVoice();
  }

  selectVoiceEvent(voices.get(0));
}

void draw() {

  // Drawing the storyboard graph
  if (isDrawable) {
    background(255);
    if (isDrawing) {
      selected.record();
    }
    for (Voice v : voices) {
      v.display();
    }
  }
  else {
    //Calculate time elapsed
    //Since beginning of storyboard
    String clock = "";
    int time = 0;
    time = int(timer/1000) + 1;
    clock = time + "s";
    textAlign(CENTER);
    textSize(48);

    if (play.isOn) {
      if (sb.isDone()) {
        sb.pickVoice();
      }
      sb.run();
      timer = millis() - startTime;
    }

    // Display clock
    stroke(255);
    fill(255);
    textSize(64);
    textAlign(RIGHT);
    text(clock, width-10, height-10);
  }

  showButtons();
}

void reset(boolean isResettingAll) {
  background(255);
  if (isResettingAll) {
    sb.reset();
    isPlayable = false;
  }
  else
    selected.reset();

  if (selected != null)
    selected.toggle(true);
  isDrawable = true;
}

//////////////////////////////////////////
//////////////////////////////////////////
/////////////// INTERACTION //////////////
//////////////////////////////////////////
//////////////////////////////////////////
void mousePressed() {
  isDrawing = true;
  // Play or Stop storyboard
  if (play.isHovered() && isPlayable) {
    //println("PLAY IS HOVERED!!!");
    if (play.isOn)
      pauseEvent();
    else
      playEvent();
  }
}

void mouseReleased() {
  isDrawing = false;
  if (isDrawable) {
    selected.interpolate();
    
    // Select voice to draw
    for (Voice v : voices) {
      if (v.button.isHovered())
        selectVoiceEvent(v);
    }
    
    // Clear graph
    // Re-initialize beats array
    if (clearAll.isHovered())
      reset(true);
    else if (clear.isHovered())
      reset(false);
  }
}

void mouseDragged() {
  if (isOnScreen(new PVector(mouseX, mouseY)) && isOnScreen(new PVector(pmouseX, pmouseY)))
    selected.erase();
}

boolean isOnScreen(PVector pos) {
  return pos.x >= mouseXMin && pos.x <= width && pos.y >= mouseYMin && pos.y <= height-100;
}

//////////////////////////////////////////
//////////////////////////////////////////
////////////////// EVENTS ////////////////
//////////////////////////////////////////
//////////////////////////////////////////

Beat drawEvent(float x, float y, boolean isUserCreated) {
  if (y < 0)
    y = 0;
  x = constrain(x, 0, width);
  y = constrain(y, -height, height);
  return new Beat(x, y, isUserCreated);
}

void playEvent() {

  play.toggle(true);
  isPlayable = true;
  isDrawable = false;
  startTime = millis();
  selected.toggle(false);
  sb.startEvent();
}

void pauseEvent() {
  play.toggle(false);
  isDrawable = true;
  sb.stopEvent();
  if (selected !=null)
    selected.toggle(true);
}

void selectVoiceEvent(Voice v) {
  turnOffVoices();
  v.toggle(true);
  selected = v;
}



void showButtons() {
  play.display();
  clearAll.display();
  clear.display();

  fill(isDrawable ? 0 : 255);
  textSize(16);
  textAlign(RIGHT);
  text("MOTIFS", mouseXMin-5, mouseYMin + 40);
  for (Voice v : voices) {
    v.button.display();
  }
}

