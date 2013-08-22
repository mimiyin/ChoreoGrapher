/*
* Button classes and the functionality the buttons invoke
 */

class Button {
  int side, x, y;
  String label;

  Button(String _label, Control c, int mult) {
    side = 50;
    if (c == Controls.TOPRIGHT) {
      x = width-((side + 10)*mult);
      y = side/4;
    }
    else if(c == Controls.BOTTOMLEFT) {
      x = (side + 10)*mult;
      y = height - side/4;
    }
    else if(c == Controls.SIDEBAR) {
      x = 50;
      y = (height*mult) + 100
    }

    label = _label;
  } 

  void display() {
    rectMode(CORNER);
    stroke(255);
    fill(0);
    textSize(14);
    textAlign(CENTER, CENTER);
    rect(x, y, side, side/2);
    fill(255);
    text(label, x+(side/2), y+(side/4));
  }
  
  void update(String _label) {
    label = _label;
    
  }

  boolean isHovered() {
    if (mouseX > x && mouseX < x+side && mouseY > y && mouseY < y+(side/2))
      return true;
    else 
      return false;
  }
}

// Multi-state button
class ToggleButton extends Button {
  String onLabel, offLabel;
  boolean isOn;

  ToggleButton(String _label, int xMult, String _offLabel) {
    super(_label, xMult);
    label = _label;
    onLabel = _label;
    offLabel = _offLabel;
  }
  void toggle() {
    isOn = !isOn; 
    if (isOn)
      label = offLabel;
    else
      label = onLabel;
  }
}

void initPlayer() {
  sb.init();
  t = firstBeatInd;
  try {
    audio.cue(0);
    audio.play();
  }
  catch(Exception e) {
    println("No audio to play.");
  }
}
void resetPlayer() {
  initPlayer();
  drawDots();

  try {
    audio.pause();
  }
  catch(Exception e) {
    println("No audio to pause.");
  }
}

void load() {
  // Pause drawing while we load the file
  initialize();
  selectInput("Load Graph", "loadBeats");
}

void loadBeats(File file) {
  String[] savedBeats = loadStrings(file.getAbsolutePath());
  beats = new Beat[savedBeats.length];
  for (int i = 0; i < savedBeats.length; i++) {
    String[] savedBeat = savedBeats[i].split(", ");
    beats[i] = new Beat(Float.parseFloat(savedBeat[0]), Float.parseFloat(savedBeat[1]), Boolean.parseBoolean(savedBeat[2]));
  }

  // Get ready to play
  isPlayable = true;
}

void save() {
  selectOutput("Save This Graph", "saveBeats");
}

void saveBeats(File file) {
  String[] savedBeats = new String[beats.length];
  String concatenator = ", ";
  for (int i = 0; i < beats.length; i++) {
    Beat beat = beats[i];
    String savedBeat = "" + beat.beat;
    savedBeat += concatenator + beat.rawTempo;
    savedBeat += concatenator + beat.isUserCreated;
    savedBeats[i] = savedBeat;
  }
  println(file.getName());
  saveStrings(file.getAbsolutePath(), savedBeats);
}

void loadAudio(File file) {
  try {
    audio = minim.loadFile(file.getAbsolutePath());
    seconds = Math.round(audio.length()/1000);
    println("The audio is " + seconds + "s long.");
  }
  catch(Exception e) {
    println("No audio");
  }
}

void addVoice() {
  turnOffVoices();
  // Select folder to load media
  voices.add(new Voice());
}

void changeVoice(Voice v) {
  turnOffVoices();
  v.toggle(true) ;
}

void turnOffVoices() {
  for (Voice voice : voices) {
    voice.toggle(false);
  }
}

