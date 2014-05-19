class Role {
  int timeDrawing, timeSinceDrawing, timeSinceShot;
  boolean hasDrawn, hasShot;
  float life;
  int holdup;

  Role() {
  }

  void run() {
    if (hasDrawn) timeElapsed++;
    display();
  }

  // Decide whether caracter will draw or not
  boolean isDrawing() {
    // Affect this calc based on agreement and holdup status
    return sumReactions() > POINT_OF_NO_RETURN;
  }

  // Calculate whether caracter has finished drawing their gun
  boolean hasDrawn() {
    if (isDrawing()) timeDrawing++; 
    if (timeDrawing > mark.drawTime - awareness) {
      timeDrawing = 0;
      return true;
    }
    else return false;
  }
  
  void setHoldup(boolean isHeldup) {
     holdup = isHeldup ? 1: -1;
  }

  // Calculate damage of shot.
  // We'll assume right now that the player is always the target.
  float shoot() {
    hasShot = true;    
    if (timeSinceShot < 5) return 0;
    return mark.accuracy - random();
  }

  void takeHit(float damage) {
    life -= damage;
    holdup = 0;
    hasDrawn = false;
    hasShot = false;  
    timeDrawing = 0;
    timeSinceDrawing = 0;
    timeSinceShot = 0;
  }

  void display() {
  }
}

