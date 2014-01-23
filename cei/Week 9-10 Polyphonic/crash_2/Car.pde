class Car {
  PVector loc;
  PVector speed;
  PVector accel;
  boolean troubled;
  Wave trouble;
  float mass;
  

  Car() {
  }

  void update() {
    speed.add(accel);
    loc.add(speed);
  }
  
  void crash() {
    
    
  }
 
  float getTrouble() {
      wave.run();    
  }
  
}

