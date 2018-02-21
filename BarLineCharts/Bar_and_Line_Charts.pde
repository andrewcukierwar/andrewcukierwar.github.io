String path = "data.csv";
String xName = "";
String yName = "";
String[] names;
int[] values;
boolean bar;
int yAxisMax;

void loadStr() {
  String[] lines = loadStrings(path);
  String[] firstLine = split(lines[0], ",");
  xName = firstLine[0];
  yName = firstLine[1];
  names = new String[lines.length-1];
  values = new int[lines.length-1];
  for (int i = 1; i < lines.length; i++) {
    String[] row = split(lines[i], ",");
    names[i-1] = row[0];
    values[i-1] = (int) parseFloat(row[1]);
  }
}

void axes() {
  stroke(255, 255, 255);
  line(width/8, 7*height/8, width/8, height/8);
  line(width/8, 7*height/8, 7*width/8, 7*height/8);
  int yMax = max(values);
  yAxisMax = (int)(yMax * 1.2);
  
  fill(0, 0, 0);
  for (int i = 1; i <= 6; ++i) {
    line(width/8, i*height/8, width/8 - width/100, i*height/8); //y-axis tick marks
    String axisLabel = "" + (i*yAxisMax/6.0);
    textSize(width/100);
    textAlign(RIGHT, CENTER);
    text(axisLabel, width/8 - width/50, (7-i)*height/8);
  }
  
  //y-axis name
  fill(0, 0, 0);
  pushMatrix();
  translate(width/20, height/2);
  rotate(-1*PI/2);
  textSize(16*height/600);
  textAlign(CENTER);
  text(yName, 0, 0);
  popMatrix();
  
  //x-axis name
  textSize(16*width/1000);
  textAlign(CENTER);
  text(xName, width/2, height*49/50);
  fill(0, 0, 0);
  
  for (int i = 0; i < names.length; ++i) {
    int x = width/8 + (int)(1.0*(i+1)/names.length*(23*width/32));
    int yStart = 7*height/8;
    int yEnd = 7*height/8 + height/100;
    line(x, yStart, x, yEnd); //x-axis tick-marks
    
    //x-axis labels
    String name = names[i];
    pushMatrix();
    translate(x, 7*height/8 + height/50); // FIX
    rotate(-1*PI/2);
    textSize(height/60);
    textAlign(RIGHT, CENTER);
    text(name, 0, 0);
    popMatrix();
  }
}

void barChart() {
  for (int i = 0; i < values.length; ++i) {
    int curX = width/8 + (int)(1.0*(i+1)/values.length*(23*width/32));
    int curValue = values[i];
    int halfY = (7*height/8) - (int)(((1.0)*curValue/yAxisMax)*(3*height/4)/2);
    fill(57, 180, 189);
    rectMode(CENTER);
    rect(curX, halfY, (int)(1.0/values.length*(23*width/32)/2), (int)(((1.0)*curValue/yAxisMax)*(3*height/4)));
  }
}

void barMouseHover() {
  for (int i = 0; i < names.length; ++i) {
    int curX = width/8 + (int)(1.0*(i+1)/values.length*(23*width/32));
    int curValue = values[i];
    int halfY = (7*height/8) - (int)(((1.0)*curValue/yAxisMax)*(3*height/4)/2);
    int colWidth = (int)(1.0/values.length*(23*width/32)/2);
    int colHeight = (int)(((1.0)*curValue/yAxisMax)*(3*height/4));
    String name = names[i];
    String value = "" + values[i];
    String tooltip = "(" + name + ", " + value + ")";
    if (mouseX >= (curX - colWidth/2) && mouseX <= (curX + colWidth/2) && mouseY >= (halfY - colHeight/2) && mouseY <= (halfY + colHeight/2)) {
      rectMode(CENTER);
      fill(0, 0, 0);
      rect(curX, halfY, colWidth, colHeight);
      textSize(9);
      textAlign(CENTER, BOTTOM);
      text(tooltip, curX, 7*height/8 - colHeight - height/100);
      fill(255, 255, 255);
    }
  }
}

void lineChart() {
  for (int i = 0; i < values.length; ++i) {
    int curX = width/8 + (int)(1.0*(i+1)/values.length*(23*width/32));
    int curValue = values[i];
    int curY = (7*height/8) - (int)(((1.0)*curValue/yAxisMax)*(3*height/4));
    if (i < values.length - 1) {
      int nextX = width/8 + (int)(1.0*(i+2)/values.length*(23*width/32));
      int nextValue = values[i+1];
      int nextY = (7*height/8) - (int)(((1.0)*nextValue/yAxisMax)*(3*height/4));
      stroke(57, 180, 189);
      line(curX, curY, nextX, nextY);
      stroke(255, 255, 255);
    }
    ellipse(curX, curY, 6, 6);
  }
}

void lineMouseHover() {
  for (int i = 0; i < names.length; ++i) {
    int curX = width/8 + (int)(1.0*(i+1)/values.length*(23*width/32));
    int curValue = values[i];
    int curY = (7*height/8) - (int)(((1.0)*curValue/yAxisMax)*(3*height/4));
    String name = names[i];
    String value = "" + values[i];
    String tooltip = "(" + name + ", " + value + ")";
    if (mouseX >= (curX-3) && mouseX <= (curX+3) && mouseY >= (curY-3) && mouseY <= (curY+3)) {
      fill(0, 0, 0);
      textSize(9);
      textAlign(CENTER, BOTTOM);
      text(tooltip, curX, curY - height/100);
      fill(255, 255, 255);
    }
  }
}

void drawBox() {
  fill(57,180,189);
  rectMode(CENTER);
  rect(7*width/8, height/16, width/8, height/32);
  fill(255, 255, 255);
  textAlign(CENTER, CENTER);
  textSize(12*width/1000);
  if (bar) {
    text("Change to Line", 7*width/8, height/16);
  }
  else {
    text("Change to Bar", 7*width/8, height/16);
  }
}

void setup() {
  size(800, 480);
  // surface.setResizable(true);
  loadStr();
  bar = true;
}

void draw() {
  background(208, 208, 208);
  axes();
  drawBox();
  if (bar) {
    barChart();
    barMouseHover();
  }
  else {
    lineChart();
    lineMouseHover();
  }
}

void mouseClicked() {
  int lowerX = 7*width/8 - width/12;
  int upperX = 7*width/8 + width/12;
  int lowerY = height/16 - height/64;
  int upperY = height/16 + height/64;
  if (mouseX >= lowerX && mouseX <= upperX && mouseY >= lowerY && mouseY <= upperY) {
    bar = !bar;
    clear();
    draw();
  }
}