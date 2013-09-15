// Manages display of your content
class Storyboard {
  Voice current;
  Minim minim;
  AudioPlayer audio;
  boolean hasAudio;

  float t = width;
  float tSpeed = 10;
  float xPos, startingAt;

  float duration = 90;

  Storyboard(PApplet parent) {
    minim = new Minim(parent);
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

  void addAudio(String path) {
    audio = minim.loadFile(path);
    audio.cue(0);

    hasAudio = true;
    println("Loaded audio from: " + path);
    println("The audio is " + Math.round(audio.length()/1000) + "s long.");
  }

  void startEvent() {
    startingAt = t;
    if (hasAudio) {
      audio.cue(0);
      audio.play();
    }
  }

  void stopEvent() {
    if (hasAudio)
      audio.pause();
  }

  boolean isDone() {
    if (current == null || current.isDone()) {
      return true;
    }
    else
      return false;
  }
}

