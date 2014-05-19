// Class for game-generated caracters
// Could have different "types" (e.g. SideKick, Antagonist/Villain, RomanticInterest)

class Caracter {
  String name;
  PVector loc;  
  float[] repute = new float[r.count];
  Reaction[] reactions;

  Mark mark;

  float willShoot;
  float awareness;

  Acootermint horse;

  // Each character needs an array to specify the stat-curve for each trait
  // Each trait needs to have a type of curve to describe their reactions
  Caracter(String _name, PVector _loc, float [] _repute, Reaction[] _reactions, Mark _mark, Curve hcurve) {
    name = _name;
    loc = _loc;
    repute = _repute;
    reactions = _reactions;
    mark = _mark; 

    horse = new Acootermint(name, hcurve);
  }

  // Update skills
  void update(float env) {
    mark.update(env);
  }

  //React to player's choices
  void react(int choice) {
    float expFactor = hasAgreed ? .5 : 1;
    
    switch(choice) {
    case Actions.RUN:
      break;
    case Actions.MERCY:
      break;
    case Actions.HOLDUP:
      reactions[Reactions.FEAR].react(5*expFactor);
      break;
    case Actions.MAIM:
      reactions[Reactions.FEAR].react(8*expFactor);
      break;
    case Actions.SHOOT:
      reactions[Reactions.FEAR].react(10*expFactor);
      break;
    case Actions.STEAL:
      break;
    case Actions.BEG:
      reactions[Reactions.SYMPATHY].react(5*expFactor);
      break;
    case Actions.CON:
      reactions[Reactions.RIGHTEOUSNESS].react(-3*expFactor);
      break;
    case Actions.PROPOSITION:
      reactions[Reactions.RIGHTEOUSNESS].react(-1*expFactor);
      break;    
    case Actions.THREATEN:
      reactions[Reactions.FEAR].react(3*expFactor);
      break;
    }
    
    awareness = 1;
  }
  
  float sumReactions() {
    float sum;
    for (Reaction reaction : reactions) {
      sum += reaction.value;
    }
    return sum;
  }
  
   // Ask caracter if they will agree to plan
  boolean willAgree() {
    
    if(sumReactions() > POINT_OF_NO_RETURN) {
       hasAgreed = true; 
    }
    return hasAgreed;
  }

 
  void display() {
    rect(x, y, 100, 200);
    for (int r = 0; r < reactions.length; r++) {
      String rname = Reactions.values()[r].name;
      print(rname + ": " + r.value + "\t");
    }

    horse.display();
    println("");
  }
}

