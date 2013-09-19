// Manages display of your content
class Storyboard {
  Voice current;

  float xPos, startingAt, endingAt, t;
  float tSpeed = 10;

  float duration = 90;

  Storyboard() {
  }

  void reset() {
    xPos = -1;
    startingAt = -1;
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
        //println("SUM: " + sum + "\tTH: " + v.threshold + "\tWEIGHT: " + v.weight);
      }
    }
    return sum;
  }

  void pickVoice() {
    float sum = calcSum();
    float dart = random(sum);
    float lowest = sum;
    for (Voice v : voices) {
      if (v.weight > 0) {
        //println("DART: " + dart + "\tTH: " + v.threshold + "\tLOWEST: " + lowest);
        if (dart < v.threshold && v.threshold <= lowest) {
          lowest = v.threshold;
          current = v;
        }
        v.toggleCurrent(false);
      }
    }
    if (current != null)
      current.toggleCurrent(true);
    t+=tSpeed;
  }

  void run() {
    //println("RUNNING VOICE: " + this.t);
    t = this.t;
    if (xPos >= endingAt) {
      pauseEvent();
    }
    else {
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
    }

    textSize(16);
    textAlign(LEFT);
    fill(255);
    text("Clip " + int((t-startingAt)/10), xPos + 24, 100); 

    for (int t = mouseXMin; t < width; t+=tSpeed) {
      stroke(255, 16);
      line(t, 0, t, height);
    }

    stroke(255);    
    line(xPos, 0, xPos, height);

    this.t = t;
  }


  void startEvent() {
    startingAt = width;
    endingAt = 0;
    for (Voice v: voices) {
      if (v.hasBeats) {
        v.diameter = 20;
        if (v.firstBeatInd < startingAt) {
          startingAt = v.firstBeatInd;
        }
        if (v.lastBeatInd > endingAt) {
          endingAt = v.lastBeatInd;
        }
      }
    }
    t = startingAt;
    xPos = t;
    sb.pickVoice();
  }

  void stopEvent() {
    for (Voice v : voices) {
      v.toggle(false);
    }
  }

  boolean isDone() {
    if (current == null || current.isDone()) {
      return true;
    }
    else
      return false;
  }
}

