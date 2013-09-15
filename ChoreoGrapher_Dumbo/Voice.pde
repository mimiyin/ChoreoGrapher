class Voice {
  boolean isCurrent;
  boolean hasBeats;
  boolean hasClips;
  Beat[] beats;
  String name;
  int index, counter;
  float prog;
  float weight, threshold, yPos;
  int firstBeatInd, lastBeatInd;
  ArrayList<Movie> clips;
  Movie picked;
  ToggleButton button;

  color col;
  float diameter = 20;
  int prob = 0;

  PApplet parent;

  Voice(PApplet p, String _name, int _index) {
    parent = p;
    name = _name;
    index = _index;
    button = new ToggleButton(name, Controls.SIDEBAR, index, "Draw " + name + "...");
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

    // Init clips arraylist
    initClips();

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
      if (beat.rawTempo > mouseYMin) {
        color currentCol = isCurrent ? color(red(col), green(col), blue(col)) : color(red(col), green(col), blue(col), 8);
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

  void addClip(String path) {
    try {
      clips.add(new Movie(parent, path));
      hasClips = true;
    }
    catch (Exception e) {
      println("No movie at: " + path);
    }
  }

  void run() {
    if (picked != null) {
      picked.stop();
      picked = null;
    }
    Beat thisBeat = beats[(int)Math.round(sb.xPos)];
    weight = thisBeat.tempo;
  }

  void toggleCurrent(boolean _isCurrent) {
    isCurrent = _isCurrent;
    counter = 0;
    if (isCurrent && hasClips )
      pickClip();
  }

  void pickClip() {
    int m = (int)random(clips.size());
    picked = clips.get(m);  
    picked.play();
  }

  void play() {
    if (hasClips) {
      picked.play();
      image(picked, width/2, height/2, width, height);
    }
    else {
      // Calculate progress
      counter++;

      boolean isFadingIn = counter < sb.duration/2;
      float mult = map(counter, 0, sb.duration, isFadingIn ? 0: 255, isFadingIn ? 255 : 0)/128;
      background(red(col)*mult, green(col)*mult, blue(col)*mult);
      textSize(64);
      textAlign(LEFT);
      text("Motif " + name + " selected", 10, height-10);
    }
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
    if (hasClips && picked.time() >= picked.duration()-1) {
      println("VOICE IS DONE!!!");
      return true;
    }
    else if (counter > sb.duration)
      return true;
    else
      return false;
  }

  void setClipSource() {
    selectFolder("Select source folder for clips.", "loadClipsEvent");
  }

  void initClips() {
    clips = new ArrayList<Movie>();
  }
}

