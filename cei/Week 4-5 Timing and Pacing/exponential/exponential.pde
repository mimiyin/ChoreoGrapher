



void keyPressed() {
    if (key == '+') {
      speed += 0.001;
    }
    else if (key == '_') {
      speed -= 0.001;
    }
    else if (key == '=') {
      exp++;
    }
    else if (key =='-') {
      exp--;
    }  
}
