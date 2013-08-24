import processing.core.PApplet;

// Multi-state button
public class ToggleButton extends Button {
  String onLabel, offLabel;
  boolean isOn;

  ToggleButton(PApplet p, String _label, Controls c, int mult, String _offLabel) {
    super(p, _label, c, mult);
    label = _label;
    onLabel = _label;
    offLabel = _offLabel;
  }
  void toggle() {
    isOn = !isOn; 
    if (isOn)
      label = offLabel;
    else
      label = onLabel;
  }
}
