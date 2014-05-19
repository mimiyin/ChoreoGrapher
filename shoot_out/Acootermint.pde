class Acootermint {
  String owner;

  float health;
  Curve curve;

  float t;
  
  Acootermint(String _owner, Curve _curve) {
    owner = _owner;
    curve = _curve;
    
  }

  // Update health of horse
  // Based on environmental factors
  void update(float env) {
    t+=0.01;
    health = c.run()*env;
  }

  boolean isDead() {
    return health < - POINT_OF_NO_RETURN);
  }

  // Display horse's health
  void display() {
    print(owner + "'s horse's health: " + health);
  }
}

