class Wave {
  float t, f, a, o, of, oa;
  Wave freq;
  Wave amp;

  Wave(float _t, float _f, float _a, float _o) {
    t = _t;
    f = _f;
    a = _a;
    o = _o;
    of = f;
    oa = a;
  }

  void init() {
    f = of;    
    a = oa;
  }

  float wave(int lim) {
    if (hasChanged) {
      init(); 
    }
    
    if (lim <= 0) {
      return sine();
    }
    else {
      println("LIM: " + lim);
      
      if (freq == null) {
        freq = new Wave(t, f, a, o);
      }
      if (amp == null) {
        amp = new Wave(t, f, a, o);
      }
      f = freq.wave(lim-1)/(a*TWO_PI);
      a = amp.wave(lim-1);
      return sine();
    }
  }

  float sine() {
    t+=f;
    return sin(t)*a + o;
  }
}

