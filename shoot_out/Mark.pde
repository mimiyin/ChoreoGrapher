class Mark {
  float drawTime;
  float accuracy;

  Mark(float dt, float a) {
    drawTime = dt;
    accuracy = a;
  }
  
  // Update marksmanship as 
  // environmental factors change
  void update(float value){
    drawTime *= value;
    accuracy *= value;      
  }  
}

