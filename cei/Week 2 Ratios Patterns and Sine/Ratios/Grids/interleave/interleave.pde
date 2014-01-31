int cell = 20; // Individual cell size
int cols, rows; // Total number of columns and rows
int colTH = 1; // Starting threshold for columns
int rowTH = 1; // Starting threshold for rows

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
      
      /* 
      * Why is the result so different if you reverse the order of the next 2 lines of code?
      * What if they were mutually exclusive?
      */
      // Fill every *th column black
      if (col%colTH == 0) fill(0);
      // Fill every *th row red
      if (row%rowTH == 0) fill(255, 0, 0);
      
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
  }
  
  colTH = constrain(colTH, 1, cols);
  rowTH = constrain(rowTH, 1, rows);

  println("COL TH: " + colTH + "\t\tROW TH: " + rowTH);
}

