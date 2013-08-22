// Manages display of your content
class Storyboard {
  Voice selected;

  Storyboard() {
  }

  void pickVoice() {
    int sum = 0;
    for (Voice v : voices) {
      sum += v.weight; 
      v.threshold = sum;
    }
    float dart = random(sum);
    for (Voice v : voices) {
      if (dart < v.threshold) {
        selected = voices.get(v);
        selected.pickClip();
        break;
      }
    }
  }

  void record() {
    selected.record();
  }

  void play() {
    selected.play();
  }

  boolean isDone() {
    if (selected.isDone())
      return true;
    else
      return false;
  }
}

