/*
* Button classes and the functionality the buttons invoke
 */

class Button {
  int side, x, y;
  String label;

  Button(String _label, Controls c, int mult) {
    side = 50;
    if (c == Controls.TOPRIGHT) {
      x = width-((side + 10)*mult);
      y = side/4;
    }
    else if (c == Controls.BOTTOMLEFT) {
      x = (side + 10)*mult;
      y = height - side/4;
    }
    else if (c == Controls.SIDEBAR) {
      x = 50;
      y = (height*mult) + 100;
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

  ToggleButton(String _label, Controls c, int mult, String _offLabel) {
    super(_label, c, mult);
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
  sb.reset();
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
  try {
    audio.pause();
  }
  catch(Exception e) {
    println("No audio to pause.");
  }
}

void load() {
  // Pause drawing while we load the file
  reset();
  selectFolder("Load Graph", "load");
}

void load(File folder) {
  // Clear voices
  voices = new ArrayList<Voice>();

  String path = folder.getAbsolutePath();
  int numVoices = folder.listFiles().length;
  String[] clips = loadStrings(path + "/clips.txt");

  for (int i = 0; i < numVoices; i++) {
    Voice v = new Voice(i.toString(), i);
    voices.add(v);
    String[] savedBeats = loadStrings(path + "/" + nf(i, 2) + ".txt");
    beats = new Beat[savedBeats.length];
    for (int i = 0; i < savedBeats.length; i++) {
      String[] savedBeat = savedBeats[i].split(", ");
      beats[i] = new Beat(Float.parseFloat(savedBeat[0]), Float.parseFloat(savedBeat[1]), Boolean.parseBoolean(savedBeat[2]));
    }
    v.loadBeats(beats);
    v.loadClips(new File(clips[i]));
  }

  // Get ready to play
  isPlayable = true;
}

void save() {
  selectFolder("Save This Graph", "dump");
}

void dump(File folder) {
  String path = folder.getAbsolutePath();

  for (Voice v: voices) {
    String[] savedBeats = new String[beats.length];
    String concatenator = ", ";
    Beat[] beatsToSave = v.getBeats();
    for (int i = 0; i < beatsToSave.length; i++) {
      Beat beat = beatsToSave[i];
      String savedBeat = "" + beat.beat;
      savedBeat += concatenator + beat.rawTempo;
      savedBeat += concatenator + beat.isUserCreated;
      savedBeats[i] = savedBeat;
    }
    saveStrings(path + "/" + nf(i, 2) + ".txt", savedBeats);
  }
  
  
}

void selectAudioFile() {
  selectOutput("Select Audio File", "loadAudio");
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

void removeVoice() {
  // Must have at least 1 voice
  if (voices.size() > 1)
    return;

  int index = voices.indexOf(selected);
  voices.remove(index);
  try {
    changeVoice(voices.get(index));
  }
  finally {
    changeVoice(voices.get(index-1));
  }
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

