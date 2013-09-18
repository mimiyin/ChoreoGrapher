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

