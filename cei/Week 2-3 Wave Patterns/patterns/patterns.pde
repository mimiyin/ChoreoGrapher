int cell = 20;
int cols, rows;
int colTH = 1;
int rowTH = 1;

void setup() {
  size(800, 600);
  cols = width/cell;
  rows = height/cell;
  background(255);
  noStroke();
}

void draw() {
  for (int col = 0; col < cols; col++) {
    float x = col*cell;
    for (int row = 0; row < rows; row++) {
      float y = row*cell;
      if (col%colTH == 0) fill(0);
      if (row%rowTH == 0) fill(255, 0, 0);
      rect(x, y, cell, cell);
    }
  }
}

void keyPressed() {

  switch(keyCode) {
  case UP:
    colTH++;
    break;
  case DOWN:
    colTH--;
    break;
  case RIGHT:
    rowTH++;  
    break;
  case LEFT:
    rowTH--;
    break;
  }

  colTH = constrain(colTH, 1, cols);
  rowTH = constrain(rowTH, 1, rows);

  println("COL TH: " + colTH + "\tROW TH: " + rowTH);
}

