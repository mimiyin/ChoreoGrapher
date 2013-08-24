/*
* Button classes and the functionality the buttons invoke
 */
import processing.core.*;

public class Button {
	PApplet parent;
  int side, x, y;
  String label;

  Button(PApplet p, String _label, Controls c, int mult) {
	  parent = p;
    side = 50;
    if (c == Controls.TOPRIGHT) {
      x = parent.width-((side + 10)*mult);
      y = side/4;
    }
    else if (c == Controls.BOTTOMLEFT) {
      x = (side + 10)*mult;
      y = parent.height - side/4;
    }
    else if (c == Controls.SIDEBAR) {
      x = 50;
      y = (parent.height*mult) + 100;
    }

    label = _label;
  } 

  void display() {
    parent.rectMode(PApplet.CORNER);
    parent.stroke(255);
    parent.fill(0);
    parent.textSize(14);
    parent.textAlign(PApplet.CENTER, PApplet.CENTER);
    parent.rect(x, y, side, side/2);
    parent.fill(255);
    parent.text(label, x+(side/2), y+(side/4));
  }

  void update(String _label) {
    label = _label;
  }

  boolean isHovered() {
    if (parent.mouseX > x && parent.mouseX < x+side && parent.mouseY > y && parent.mouseY < y+(side/2))
      return true;
    else 
      return false;
  }
}


