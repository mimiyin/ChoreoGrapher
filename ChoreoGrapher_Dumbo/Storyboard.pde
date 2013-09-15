// Manages display of your content
class Storyboard {
  Voice current;
  Minim minim;
  AudioPlayer audio;
  boolean hasAudio;

  float t = width;
  float tSpeed = 10;
  float startingAt = 0;

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

  void pickVoice() {
    float sum = 0;
    t+=tSpeed;
    for (Voice v : voices) {
      if (v.button.hasBeats) {
        v.run();
        sum += v.weight; 
        v.threshold = sum;
      }
    }

    float dart = random(sum);
    float lowest = sum;
    for (Voice v : voices) {
      if (v.button.hasBeats) {
        v.prob = (int)Math.round(100*v.weight/sum);
        if (dart < v.threshold && v.threshold <= lowest) {
          lowest = v.threshold;
          current = v;
        }
      }
    }

    for (Voice v : voices) {
      v.toggleCurrent(false);
    }

    current.toggleCurrent(true);

    if (current.hasClips)
      current.pickClip();
  }

  void run() {
    current.play();
    for (Voice v : voices) {
      if (v.button.hasBeats) {
        v.display();
        v.trackCurve();
      }
    }
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

