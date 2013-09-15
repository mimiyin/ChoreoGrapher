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

