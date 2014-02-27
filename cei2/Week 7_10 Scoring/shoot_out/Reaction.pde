// Class for how caracters react to protagonist's choices.

class Reaction {
  float value; 
  Curve curve;  

  Reaction(float _value, Curve _curve) {
    value = _value;
    curve = _curve;
  }

  void react(float change) {
    value = curve.run(change);
  }
}

