import processing.core.*;
import processing.video.*;

public class Voice {
  boolean isSelected;
  Beat[] beats;
  int t;
  float weight, threshold;
  int firstBeatInd, lastBeatInd, numBeats, threshold;
  ArrayList<Movie> clips;
  Movie selected;

  Button button;

  Voice(String name, int index) {
    toggle(true);
    button = new Button(name, Controls.SIDEBAR, index);
    reset();
  }

  void toggle(boolean isOn) {
    isSelected = isOn;
    if (isOn)
      selectVoiceEvent(v);
  }

  void reset() {
    background(255);
    t = 0;
    weight = 1;
    threshold = 0;

    // Initialize beats array with 
    // a dot for every x-position
    beats = new Beat[width];
    for (int i = 0; i < beats.length; i++) {
      beats[i] = createBeat(i, mouseYMin, false);
    }
  }
  
  void loadBeats(Beat[] _beats) {
    beats = _beats;
  }

  Beat createBeat(float x, float y, boolean isUserCreated) {
    x = constrain(x, 0, width);
    y = constrain(y, mouseYMin, height);
    return new Beat(x, y, isUserCreated);
  }

  void record() {
    if (mouseX >= 0 && mouseX < width && mouseY >= mouseYMin && mouseY < height) {
      beats[mouseX] = createBeat(mouseX, mouseY, true);
      isPlayable = true;
    }
  }

  void display() {
    background(255);
    for (Beat beat: beats) {
      color col = isSelected ? color(255, 0, 0) : color(0);
      beat.display(col);
    }
  }

  void erase() {
    boolean isGoingRight = mouseX > pmouseX;
    if (isGoingRight) {
      for (int i = pmouseX + 1; i < mouseX; i++) {
        beats[i] = createBeat(i, mouseYMin, false);
      }
    }
    else {
      for (int i = pmouseX - 1; i > mouseX; i--) {
        beats[i] = createBeat(i, mouseYMin, false);
      }
    }
  }

  void run() {
    t+=tSpeed; 
    weight = beats[t];
  }
  
  void pickClip() {
    int m = (int) Math.round(clips.size());
    selected = clips.get(m);  
    selected.play();
  }

  void play() {
    image(selected, 0, 0);
  }

  boolean isDone() {
    if (selected.time() > selected.duration)
      return true;
    else
      return false;
  }

  void selectClipsSource() {
    selectFolder("Select source folder for clips.", "loadClips");
  }

  void loadClips(File folder) {
    // Update button label with folder name
    button.update(folder.getName());

    // Try to load images
    for (int i = 0; i < folder.listFiles().length; i++) {
      String path = folder + "/" + nf(i, 4) + ".mov";
      Movie movie;
      try {
        movie = new Movie(this, path);
        clips.add(movie);
      }
      catch(Exception e) {
        println("No movie at: " + path);
      }
    }
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
    PVector prevBeat = new PVector (beats[0].beat, beats[0].rawTempo);
    PVector nextBeat = new PVector (beats[nextBeatInd].beat, beats[nextBeatInd].rawTempo);
    PVector range = PVector.sub(nextBeat, prevBeat);
    float progress = 0;
    for (int i = 0; i < (lastBeatInd + 1); i++) {
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
        thisBeat = createBeat(beat, tempo, false);
      }    
      thisBeat.init();
      beats[i] = thisBeat;
    }
    
    // Scale tSpeed so that it takes the full
    // duration of the piece to play all the beats
    numBeats = (lastBeatInd-firstBeatInd) + 1;
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
}
