// Something to control the number of types of cars that are in play
// A curve to describe the probability of each type of car
// A curve to describe the trouble in each car
// Speed and mass of each car


// Probability waves to release cars
// Each car has a trouble wave
// For each car, sample cars near them
// If trouble wave meets some threshold
// Toss a coin --> Crash!
// Link this up to the Choreographer
// Severity of crash based on mass of each car
// They all drive towards each other

// Score keeping
// Each time there isn't a crash, we increase the probability of a crash by adjusting the coin toss threshold


void setup() {
  size(800, 600);
  background(255);
}

void draw() {
  conductor.run();
}



