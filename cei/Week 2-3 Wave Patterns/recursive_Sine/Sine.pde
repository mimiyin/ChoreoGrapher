class Sine {
  float t, f, a, o, of, oa;
  Sine freq;
  Sine amp;

  Sine(float _t, float _f, float _a, float _o) {
    t = _t;
    f = _f;
    a = _a;
    o = _o;
  }
  
  // Reset everything
  void reset() {
    f = frequency; 
    a = amplitude;
    freq = new Sine(t, f, a, o);
    amp = new Sine(t, f, a, o);
  }
  
  // Set frequency
  void setF(float _f) {
    f = _f;
    freq = new Sine(t, f, a, o);
  }
  
  // Set amplitude
  void setA(float _a) {
    a = _a;      
    amp = new Sine(t, f, a, o);
  }  
  
  // Recursive wave function
  float wave(int count) {
    if (count >= limit) {
      return sine();
    }
    else {
      if (freq == null) {
        freq = new Sine(t, f, a, o);
      }
      if (amp == null) {
        amp = new Sine(t, f, a, o);
      }
      f = freq.wave(count+1)/(a*TWO_PI);
      a = amp.wave(count+1);
      return sine();
    }
  }
  
  // Calculate sine value
  float sine() {
    t+=f;
    return sin(t)*a + o;
  }
}

