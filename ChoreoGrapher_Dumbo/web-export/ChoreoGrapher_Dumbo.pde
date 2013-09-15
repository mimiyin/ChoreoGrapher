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
  size(800, 600);

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
    float textWidth = textWidth(clock+5);

    if (play.isOn) {
      if (sb.isDone()) {
        sb.pickVoice();
      }
      sb.run();
      timer = millis() - startTime;
    }
    // When stopped, show end-time
    else {
      fill(0);
      rectMode(CENTER);
      rect(width-50, height-30, textWidth, 70);
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
    for (int v = voices.size()-1; v >= 0; v--) {
      voices.get(v).reset();
    }
    isPlayable = false;
  }
  else
    selected.reset();
  pauseEvent();
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
    if (play.isOn)
      pauseEvent();
    else
      playEvent();
  }
  else if (isDrawable) {
    pauseEvent();
  }
}

void mouseReleased() {
  isDrawing = false;
  if (isDrawable)
    selected.interpolate();

  if (play.isHovered() && isPlayable && !play.isOn)
    isDrawable = true;

  // Clear graph
  // Re-initialize beats array
  else if (clearAll.isHovered())
    reset(true);
  else if (clear.isHovered())
    reset(false);
  else if (isDrawable) {
    for (Voice v : voices) {
      if (v.button.isHovered())
        selectVoiceEvent(v);
    }
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
  sb.stopEvent();
  if (selected !=null)
    selected.button.toggle(true);

  isDrawable = true;
  isExporting = false;
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

// Keeps track of "tempo" as we move across the storyboard graph

class Beat {
  float beat, tempo, rawTempo, scaledTempo, counter;
  boolean isUserCreated;

  Beat(float _beat, float _tempo, boolean _isUserCreated) {
    beat = _beat;
    tempo = _tempo;
    rawTempo = tempo;
    isUserCreated = _isUserCreated;
  }

  void init() {    
// A tempo of 1 frame (3 minutes at 60fps) means take all 3 minutes to play out 1 scene
    // Max tempo means 10 scenes will play out in 1 second
    // Tempo values are mapped "on a curve" (natural log curve)
    // Play with expMax and expMin to play with which part of the curve you'd like to map your values to
    float max = 1000;
    float expMin = -5;
    float expMax = 2.5;
    float exp = map(rawTempo, height, mouseYMin, expMin, expMax);   
    float log = exp(exp);
    tempo = map(log, exp(expMin), exp(expMax), 0, max);
    //println("Beat: " + beat + "\tRaw Tempo: " + rawTempo + "\tNatural Log: " + log + "\tTempo: " + tempo);
  }

  void display(color currentCol) {
    noStroke();
    fill(currentCol);
    ellipse(beat, rawTempo, 10, 10);    
  }
}








/*
* Button classes and the functionality the buttons invoke
 */

class Button {
  int side, x, y;
  String label;
  color off = 67;
  color col = off;
  color hasBeatsCol = off;

  Button(String _label, String menu, int mult) {

    side = 85;
    if (menu == "CONTROLS") {
      x = width-((side + 10)*mult);
      y = side/4;
    }
    else if (menu == "MOTIFS") {
      x = 10;
      y = (int)(side*mult*.67) + 100;
      hasBeatsCol = colors[mult];
    }

    label = _label;
  } 

  void display() {

    rectMode(CORNER);
    stroke(255);
    fill(col);
    textSize(13);
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
  boolean isOn, hasBeats;

  ToggleButton(String _label, String menu, int mult, String _offLabel) {
    super(_label, menu, mult);
    label = _label;
    onLabel = _label;
    offLabel = _offLabel;
  }
  void toggle(boolean _isOn) {
    isOn = _isOn;
    col = isOn ? hasBeatsCol : (hasBeats ? hasBeatsCol : off);
    if (isOn)
      label = offLabel;
    else
      label = onLabel;
  }

  void setHasBeats(boolean _hasBeats) {
    hasBeats = _hasBeats;
    col = hasBeats ? hasBeatsCol : off;
  }
}

void load() {
  // Pause drawing while we load the file
  reset(true);
  isDrawable = false;
  selectFolder("Load Graph", "load");
}

void load(File folder) {
  // Clear voices
  voices = new ArrayList<Voice>();

  String path = folder.getAbsolutePath();
  int numVoices = folder.listFiles().length;

  for (int i = 0; i < numVoices; i++) {
    Voice v = new Voice(this, String.valueOf(i), i);
    voices.add(v);
    String[] savedBeats = loadStrings(path + "/" + nf(i, 2) + ".txt");
    Beat[] beats = new Beat[savedBeats.length];
    for (int j = 0; j < savedBeats.length; j++) {
      String[] savedBeat = savedBeats[j].split(", ");
      beats[j] = new Beat(Float.parseFloat(savedBeat[0]), Float.parseFloat(savedBeat[1]), Boolean.parseBoolean(savedBeat[2]));
    }
    v.loadBeats(beats);
    selectVoiceEvent(v);
  }
  // Get ready to play
  isDrawable = true;
  isPlayable = true;
}

void save() {
  selectFolder("Save This Graph", "dump");
}

void dump(File folder) {
  String path = folder.getAbsolutePath();

  for (Voice v: voices) {
    String[] savedBeats = new String[v.beats.length];
    String concatenator = ", ";
    Beat[] beatsToSave = v.beats;
    for (int i = 0; i < beatsToSave.length; i++) {
      Beat beat = beatsToSave[i];
      String savedBeat = "" + beat.beat;
      savedBeat += concatenator + beat.rawTempo;
      savedBeat += concatenator + beat.isUserCreated;
      savedBeats[i] = savedBeat;
    }
    saveStrings(path + "/" + nf(v.index, 2) + ".txt", savedBeats);
  }
}

void addVoice() {
  turnOffVoices();
  // Select folder to load media
  int num = voices.size();
  voices.add(new Voice(this, str(num+1), num));
}

void removeVoice() {
  // Must have at least 1 voice
  if (voices.size() > 1)
    return;

  int index = voices.indexOf(selected);
  voices.remove(index);
  try {
    selectVoiceEvent(voices.get(index));
  }
  finally {
    selectVoiceEvent(voices.get(index-1));
  }
}

void turnOffVoices() {
  for (Voice v : voices) {
    v.toggle(false);
  }
}  

// Manages display of your content
class Storyboard {
  Voice current;

  float t = width;
  float tSpeed = 10;
  float xPos, startingAt;

  float duration = 90;

  Storyboard() {

  }

  void reset() {
    t = width;
    for (Voice v : voices) {
      v.reset();
    }
  }

  float calcSum() {
    float sum = 0;
    for (Voice v : voices) {
      if (v.hasBeats) {
        v.run();
        sum += v.weight;
        v.threshold = sum;
        println("SUM: " + sum + "\tTH: " + v.threshold + "\tWEIGHT: " + v.weight);
      }
    }
    return sum;
  }

  void pickVoice() {
    t+=tSpeed;
    float sum = calcSum();
    float dart = random(sum);
    float lowest = sum;
    for (Voice v : voices) {
      if (v.weight > 0) {
        println("DART: " + dart + "\tTH: " + v.threshold + "\tLOWEST: " + lowest);
        if (dart < v.threshold && v.threshold <= lowest) {
          lowest = v.threshold;
          current = v;
        }
        v.toggleCurrent(false);
      }
    }
    if (current != null)
      current.toggleCurrent(true);
  }

  void run() {
    current.play();
    for (Voice v : voices) {
      if (v.hasBeats) {
        v.setProb(calcSum());
        v.display();
        v.trackCurve();
      }
    }

    // XPOS
    xPos = t + (tSpeed*current.prog);

    textSize(16);
    textAlign(LEFT);
    text("Clip " + int((t-startingAt)/10), xPos + 24, 100); 
 
    for(int t = mouseXMin; t < width; t+=tSpeed) {
     stroke(255, 16);
     line(t, 0, t, height);
    }
    
    stroke(255);    
    line(xPos, 0, xPos, height);
  }


  void startEvent() {
    startingAt = t;
    sb.pickVoice();
  }

  void stopEvent() {
     println("STOP!");
  }

  boolean isDone() {
    if (current == null || current.isDone()) {
      return true;
    }
    else
      return false;
  }
}

class Voice {
  boolean isCurrent;
  boolean hasBeats;
  Beat[] beats;
  String name;
  int index, counter;
  float prog;
  float weight, threshold, yPos;
  int firstBeatInd, lastBeatInd;
  ToggleButton button;

  color col;
  float diameter = 20;
  int prob = 0;

  PApplet parent;

  Voice(PApplet p, String _name, int _index) {
    parent = p;
    name = _name;
    index = _index;
    button = new ToggleButton(name, menus[1], index, "Draw " + name + "...");
    reset();
    col = colors[index];
    selectVoiceEvent(this);
  }

  void toggle(boolean isOn) {
    isCurrent = isOn;
    button.toggle(isOn);
  }

  void reset() {
    background(255);
    weight = 0;
    threshold = 0;

    // Initialize beats array with 
    // a dot for every x-position
    beats = new Beat[width];
    for (int i = 0; i < beats.length; i++) {
      beats[i] = drawEvent(i, -1, false);
    }

    // Has no beats yet
    hasBeats = false;
    button.setHasBeats(false);
  }

  void loadBeats(Beat[] _beats) {
    beats = _beats;
  }

  // Interpolate beats so that
  // every x-position has a beat value
  void interpolate() {

    // Calculate the first/last beat
    for (int i = 0; i < beats.length; i++) {
      if (beats[i].isUserCreated) {
        firstBeatInd = i;
        break;
      }
    }

    for (int i = beats.length-1; i > 0; i--) {
      if (beats[i].isUserCreated) {
        lastBeatInd = i;
        break;
      }
    }

    int prevBeatInd = firstBeatInd;
    int nextBeatInd = findNextBeat(firstBeatInd + 1);
    int indRange = nextBeatInd-prevBeatInd;
    PVector prevBeat = new PVector (beats[firstBeatInd].beat, beats[firstBeatInd].rawTempo);
    PVector nextBeat = new PVector (beats[nextBeatInd].beat, beats[nextBeatInd].rawTempo);
    PVector range = PVector.sub(nextBeat, prevBeat);
    float progress = 0;
    for (int i = firstBeatInd; i <= lastBeatInd; i++) {
      Beat thisBeat = beats[i];
      float beat = thisBeat.beat;
      float tempo = thisBeat.rawTempo;
      if (thisBeat.isUserCreated) {
        prevBeatInd = i;
        nextBeatInd = findNextBeat(i+1);
        indRange = nextBeatInd - prevBeatInd;
        prevBeat.set(beat, tempo);
        nextBeat.set(beats[nextBeatInd].beat, beats[nextBeatInd].rawTempo);
        range = PVector.sub(nextBeat, prevBeat);
      }
      else {
        progress = ((float)( i - prevBeatInd))/indRange;
        beat = prevBeat.x + Math.round(progress*range.x);
        tempo = prevBeat.y + Math.round(progress*range.y);
        thisBeat = drawEvent(beat, tempo, false);
      }    
      thisBeat.init();
      beats[i] = thisBeat;
    }

    if (firstBeatInd < sb.t) {
      sb.t = firstBeatInd;
      sb.xPos = sb.t;
    }

    // Has beats now
    hasBeats = true; 
    button.setHasBeats(true);
  }

  int findNextBeat(int _i) {
    for (int i = _i; i < lastBeatInd+1; i++) {
      if (beats[i].isUserCreated)
        return i;
    }
    // If there are no more beats
    // Send the last beat
    return lastBeatInd;
  }

  void record() {
    if (isOnScreen(new PVector(mouseX, mouseY))) {
      beats[mouseX] = drawEvent(mouseX, mouseY, true);
      isPlayable = true;
    }
  }

  void display() {
    for (Beat beat: beats) {
      if (beat.rawTempo > mouseYMin && beat.beat % 7 == 0) {
        color currentCol = isCurrent ? color(red(col), green(col), blue(col), 255) : color(red(col), green(col), blue(col), 32);
        beat.display(currentCol);
      }
    }
  }

  void erase() {
    boolean isGoingRight = mouseX > pmouseX;
    if (isGoingRight) {
      for (int i = pmouseX + 1; i < mouseX; i++) {
        beats[i] = drawEvent(i, -1, false);
      }
    }
    else {
      for (int i = pmouseX - 1; i > mouseX; i--) {
        beats[i] = drawEvent(i, -1, false);
      }
    }
  }

  void run() {
    Beat thisBeat = beats[(int)Math.round(sb.xPos)];
    weight = thisBeat.tempo;
  }

  void toggleCurrent(boolean _isCurrent) {
    isCurrent = _isCurrent;
    counter = 0;
  }

  void play() {

    // Calculate progress
    counter++;

    boolean isFadingIn = counter < sb.duration/2;
    float mult = map(counter, 0, sb.duration, isFadingIn ? 32: 255, isFadingIn ? 255 : 32)/128;
    background(red(col)*mult, green(col)*mult, blue(col)*mult);
    textSize(64);
    textAlign(LEFT);
    text("Motif " + name + " selected", 10, height-10);
  }


  void setProb(float sum) {
    prob = int(100*weight/sum);
  }

  void trackCurve() {
    prog = counter/sb.duration;

    // Calculate diameter
    diameter = isCurrent ? lerp(diameter, 50, prog*10) : lerp(20, diameter, prog*10);
    yPos = beats[(int)sb.xPos].rawTempo;
    if (yPos > mouseYMin) {
      stroke(255);
      strokeWeight(10);
      fill(col);
      ellipse(sb.xPos, yPos, diameter, diameter);
      strokeWeight(1);
      textSize(16);
      fill(255);
      text(prob + "%", sb.xPos + 30, yPos);
    }
  }

  boolean isDone() {
    if (counter > sb.duration)
      return true;
    else
      return false;
  }
}


