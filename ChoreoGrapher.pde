import processing.video.*;
import ddf.minim.*;

///////////////////////////
///////////////////////////
/////SETTINGS FOR YOU//////
///////////////////////////
///////////////////////////
float seconds = 90;
int fRate = 30;
int totalFrames = (int)seconds*fRate;
int maxNumberOfMedia = 1;



// Gatekeepers for drawing and playing modes
boolean isDrawable, isDrawing;
boolean isPlayable, isTiming;

// Rate at which we move across the screen
float tSpeed = 0;

// Voices
ArrayList<Voice> voices;
Voice selected;

// Managing moving through your content
Storyboard sb;

// Your content
ArrayList<Movie> movies;
Minim minim;
AudioPlayer audio;


// Keeping track oftime
// elapsed since clicking
// Play button
float timer;
ToggleButton play;
Button clear, save, load;
Button loadAudio, loadClips;
Button addVoice, removeVoice;

// Highest point you can draw
int mouseYMin = 0;

void setup() {
  size(640, 480); 
  loadAudio = new Button("Audio", Controls.TOPRIGHT, 1);
  save = new Button("Save", Controls.TOPRIGHT, 3);
  load = new Button("Load", Controls.TOPRIGHT, 4);
  play = new ToggleButton("Play", Controls.TOPRIGHT, 6, "Stop");
  clear = new Button("Clear", Controls.TOPRIGHT, 7);
  removeVoice = new Button("Remove", Controls.BOTTOMLEFT, 1);
  addVoice = new Button("Add", Controls.BOTTOMLEFT, 2);
  loadClips = new Button("Clips", Controls.BOTTOMLEFT, 3);

  imageMode(CENTER);
  frameRate(fRate);

  minim = new Minim(this);
  sb = new Storyboard();

  // Always start with at least one voice
  voices.add(new Voice("default", 0));
}

void draw() {

  // Drawing the storyboard graph
  if (isDrawable) {
    if (isDrawing) {
      selected.record();
    }
    for (Voice v : voices) {
      v.display();
    }
  }
  else if (isTiming) {
    //Calculate time elapsed
    //Since beginning of storyboard
    String clock = "";
    int time = 0;
    time = int(timer/1000) + 1;
    clock = time + "s";
    textAlign(CENTER);
    textSize(48);
    float textWidth = textWidth(clock+5);

    if (play.isOn) {
      if (sb.isDone())
        sb.pickVoice();
      sb.play();
      timer = timer + (millis() - timer);
    }
    // When stopped, show end-time
    else {
      fill(0);
      rectMode(CENTER);
      rect(50, 30, textWidth, 70);
    }

    // Display clock
    stroke(255);
    fill(255);
    text(clock, textWidth/2, 50);
  }
  showButtons();
}

void reset() {
  selected.reset();

  // Allow drawing
  // Don't allow playing
  // Reset beats array to
  // "hasn't been interpolated yet"
  isDrawable = true;
  isPlayable = false;
  isTiming = false;
}

//////////////////////////////////////////
//////////////////////////////////////////
/////////////// INTERACTION //////////////
//////////////////////////////////////////
//////////////////////////////////////////
void mousePressed() {
  isDrawing = true;

  // Clear graph
  // Re-initialize beats array
  if (clear.isHovered() && !play.isOn) {
    reset();
    }

    // Play or Stop storyboard
  else if (play.isHovered() && isPlayable) {
    if (!play.isOn) {
      initPlayer();
      isPlayable = true;
      isDrawable = false;
      timer = millis();
      isTiming = true;
    }
    else {
      resetPlayer();
    }    
    play.toggle();
  }
  else if (save.isHovered())
    save();

  else if (load.isHovered())
    load();

  else if (loadAudio.isHovered())
    selectAudioFile();

  else if (addVoice.isHovered())
    addVoice();

  else if (removeVoice.isHovered())
    removeVoice();

  else if (loadClips.isHovered())
    selected.selectClipsSource();

  else {
    for (Voice v : voices) {
      if (v.button.isHovered())
        changeVoice(v);
    }
  }
}

void mouseReleased() {
  isDrawing = false;
  if (isDrawable) {
    selected.interpolate();
  }

  if (!play.isOn)
    isDrawable = true;
}

void mouseDragged() {
  // ERASE
  if (isDrawable) {
    selected.erase();
  }
}

void MovieEvent(Movie m) {
  m.read();
}

void selectVoiceEvent(Voice v) {
  selected = v;
}

void showButtons() {
  loadAudio.display();
  load.display();
  save.display();
  play.display();
  clear.display();
  addVoice.display();
  removeVoice.display();
  loadClips.display();
}

