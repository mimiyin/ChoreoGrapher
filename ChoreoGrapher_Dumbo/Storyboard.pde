// Manages display of your content
class Storyboard {
  Voice current;
  Minim minim;
  AudioPlayer audio;
  boolean hasAudio;

  float t = width;
  float tSpeed = 10;
  float startingAt = 0;
  float bubbleY = 0;

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
    int sum = 0;
    t+=tSpeed;
    for (Voice v : voices) {
      if (v.button.hasBeats) {
        v.run();
        sum += v.weight; 
        v.threshold = sum;
        println("VOICE: " + v.index + "\t" + v.threshold);
      }
    }
    
    for(Voice v : voices) {
      v.button.label = int(Math.round(v.weight/sum))*100 + "%";  
    }
    
    float dart = random(sum);
    for (Voice v : voices) {
      if (dart < v.threshold) {
        current = v;
        current.toggleCheck(true);
        if (current.hasClips)
          current.pickClip();
        break;
      }
      //      else
      //        current.toggleCheck(false);
    }
  }

  void run() {
    current.play();
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

