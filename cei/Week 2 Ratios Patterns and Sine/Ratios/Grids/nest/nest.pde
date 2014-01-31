int cell = 5; // Individual cell size
int cols, rows; // Total number of columns and rows
float colTH, rowTH; // Threshold for columns and rows
boolean auto;

void setup() {
  size(800, 600);

  // The number of rows and columns is a function of
  // how many times a cell fits across/down the window
  cols = width/cell;
  rows = height/cell;

  background(255);
  noStroke();
}

void draw() {
  if (auto) {
    colTH +=random(-10, 10);
    rowTH +=random(-10, 10);
  }


  // CREATE A GRID WITH SO MANY COLUMNS...
  for (int col = 0; col < cols; col++) {
    // The x-location of the cell is a function of
    // the column the cell is in and the size of the cell
    float x = col*cell;

    // ...AND SO MANY ROWS
    for (int row = 0; row < rows; row++) {
      // The y-location of the cell is a function of
      // the row it's in and the size of the cell
      float y = row*cell;

      fill(255, 0, 0);

      // Fill cells in the middle with black
      if ((col>=(cols/2-colTH) && col <(cols/2+colTH)) && (row >=(rows/2-rowTH) && row <(rows/2+rowTH))) fill(0);

      rect(x, y, cell, cell);
    }
  }
}

void keyPressed() {

  switch(keyCode) {
  case UP:
    rowTH++;  
    break;
  case DOWN:
    rowTH--;
    break;
  case RIGHT:
    colTH++;
    break;
  case LEFT:
    colTH--;
    break;
  case ENTER:
    auto = !auto;
    colTH = 0;
    rowTH = 0;
    break;
  }

  colTH = constrain(colTH, 0, cols/2);
  rowTH = constrain(rowTH, 0, rows/2);

  println("COL TH: " + colTH + "\t\tROW TH: " + rowTH);
}

