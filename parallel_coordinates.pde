String path = "data.csv";
String xName = "";
String[] yNames;
String[] xNames;
int[][] values;
int[] axes_maxs;
int[] axes_mins;
int[][] row_color;
boolean[] flips;
boolean[] line_hover;

void loadStrings() {
  String[] lines = loadStrings(path);
  String[] firstLine = split(lines[0], ",");
  xName = firstLine[0];
  yNames = new String[firstLine.length-1];
  for (int i = 1; i < firstLine.length; ++i) {
    yNames[i-1] = firstLine[i];
  }
  xNames = new String[lines.length-1];
  values = new int[lines.length-1][firstLine.length-1];
  for (int i = 1; i < lines.length; i++) {
    String[] row = split(lines[i], ",");
    xNames[i-1] = row[0];
    for (int j = 1; j < firstLine.length; ++j) {
      values[i-1][j-1] = (int)parseFloat(row[j]);
    }
  }
}

int[] getColumn(int[][] array, int index){
    int[] column = new int[array.length]; // Here I assume a rectangular 2D array! 
    for(int i=0; i < column.length; i++){
       column[i] = array[i][index];
    }
    return column;
}

void axes() {
  axes_maxs = new int[values[0].length];
  axes_mins = new int[values[0].length];
  for (int i = 0; i < values[0].length; ++i) {
    float part = 1.0*(i)/(values[0].length-1);
    stroke(0, 0, 0);
    fill(0, 0, 0);
    rect(width/8+part*width*3/4, height/2, width/128, 3*height/4);
    
    int[] column = getColumn(values, i);
    int axis_max = (int)(max(column) * 1.1);
    axes_maxs[i] = axis_max;
    int axis_min = (int)(min(column) / 1.1);
    axes_mins[i] = axis_min;
    
    fill(255, 255, 255);
    textSize(height*width/60000);
    textAlign(CENTER, BOTTOM);
    if (!flips[i]) {  text(axis_max, width/8+part*width*3/4, height/8);  }
    else {  text(axis_min, width/8+part*width*3/4, height/8);  }
    text(yNames[i], width/8+part*width*3/4, height/8 - height/32);
    textAlign(CENTER, TOP);
    if (!flips[i]) {  text(axis_min, width/8+part*width*3/4, 7*height/8);  }
    else {  text(axis_max, width/8+part*width*3/4, 7*height/8);  }
    
    fill(57,180,189);
    rectMode(CENTER);
    rect(width/8+part*width*3/4, 7*height/8 + 3*height/64, width/32, height/32);
    rect(width/8+part*width*3/4 - width/64, 7*height/8 + 3*height/32, width/40, height/32);
    rect(width/8+part*width*3/4 + width/64, 7*height/8 + 3*height/32, width/40, height/32);
    fill(255, 255, 255);
    textAlign(CENTER, CENTER);
    text("Flip", width/8+part*width*3/4, 7*height/8 + 3*height/64);
    text("<-", width/8+part*width*3/4 - width/64, 7*height/8 + 3*height/32);
    text("->", width/8+part*width*3/4 + width/64, 7*height/8 + 3*height/32);
  }
}

void draw_lines() {
  for (int j = 0; j < values.length; ++j) {
    stroke(row_color[j][0], row_color[j][1], row_color[j][2]);
    if (line_hover[j]) {
      stroke(57,180,189);
    }
    for (int i = 0; i < values[j].length-1; ++i) {
      int cur_value = values[j][i];
      int next_value = values[j][i+1];
      float cur_part = 1.0*(i)/(values[j].length-1);
      float next_part = 1.0*(i+1)/(values[j].length-1);
      int cur_axis_max = axes_maxs[i];
      int cur_axis_min = axes_mins[i];
      int next_axis_max = axes_maxs[i+1];
      int next_axis_min = axes_mins[i+1];
      
      float x_start = width/8 + cur_part*width*3/4;
      float x_end = width/8 + next_part*width*3/4;
      float y_start = 7*height/8 - (1.0)*(cur_value - cur_axis_min)/(cur_axis_max - cur_axis_min)*(3*height/4);
      float y_end = 7*height/8 - (1.0)*(next_value - next_axis_min)/(next_axis_max - next_axis_min)*(3*height/4);
      if (flips[i]) {
        y_start = 7*height/8 - (1.0)*(cur_value - cur_axis_max)/(cur_axis_min - cur_axis_max)*(3*height/4);
      }
      if (flips[i+1]) {
        y_end = 7*height/8 - (1.0)*(next_value - next_axis_max)/(next_axis_min - next_axis_max)*(3*height/4);
      }
      
      line(x_start, y_start, x_end, y_end);
    }
  }
}

void check_hover() {
  for (int j = 0; j < values.length; ++j) {
    for (int i = 0; i < values[j].length-1; ++i) {
      int cur_value = values[j][i];
      int next_value = values[j][i+1];
      float cur_part = 1.0*(i)/(values[j].length-1);
      float next_part = 1.0*(i+1)/(values[j].length-1);
      int cur_axis_max = axes_maxs[i];
      int cur_axis_min = axes_mins[i];
      int next_axis_max = axes_maxs[i+1];
      int next_axis_min = axes_mins[i+1];
      
      float x_start = width/8 + cur_part*width*3/4;
      float x_end = width/8 + next_part*width*3/4;
      float y_start = 7*height/8 - (1.0)*(cur_value - cur_axis_min)/(cur_axis_max - cur_axis_min)*(3*height/4);
      float y_end = 7*height/8 - (1.0)*(next_value - next_axis_min)/(next_axis_max - next_axis_min)*(3*height/4);
      if (flips[i]) {
        y_start = 7*height/8 - (1.0)*(cur_value - cur_axis_max)/(cur_axis_min - cur_axis_max)*(3*height/4);
      }
      if (flips[i+1]) {
        y_end = 7*height/8 - (1.0)*(next_value - next_axis_max)/(next_axis_min - next_axis_max)*(3*height/4);
      }
      
      float line_eqn = y_start + x_start*((y_end - y_start) / (x_end - x_start));
      float mouse_eqn = y_start + x_start*((mouseY - y_start) / (mouseX - x_start));
      int tolerance = height/50;
      if (line_eqn <= (mouse_eqn + tolerance) && line_eqn >= (mouse_eqn - tolerance) &&
          mouseX >= x_start && mouseX <= x_end) {
        line_hover[j] = true;
        redraw();
      }
    }
  }
}

void setup() {
  size(1200, 700);
  frameRate(10);
  //surface.setResizable(true);
  loadStrings();
  flips = new boolean[values[0].length];
  for (int i = 0; i < flips.length; ++i) {
    flips[i] = false;
  }
  line_hover = new boolean[values.length];
  for (int i = 0; i < line_hover.length; ++i) {
    line_hover[i] = false;
  }
  row_color = new int[values.length][3];
  for (int j = 0; j < row_color.length; ++j) {
    row_color[j][0] = 255;
    row_color[j][1] = 255;
    row_color[j][2] = 255;
  }
}

void draw() {
  background(208, 208, 208);
  textAlign(CENTER, CENTER);
  text("Hello", width/2, height/2);
  axes();
  draw_lines();
}

void mouseMoved() {
  for (int i = 0; i < line_hover.length; ++i) {
    if (line_hover[i]) {
      line_hover[i] = false;
      redraw();
    }
  }
  check_hover();
}

void mouseClicked() {
  for (int i = 0; i < values[0].length; ++i) {
    //Check if column is clicked
    float part = 1.0*(i)/(values[0].length-1);
    float y_start = 7*height/8;
    float y_end = height/8;
    float x_lower = width/8 + part*width*3/4 - width/256;
    float x_upper = width/8 + part*width*3/4 + width/256;
    int[] column = getColumn(values, i);
    int column_max = axes_maxs[i];
    int column_min = axes_mins[i];
    if (mouseX >= x_lower && mouseX <= x_upper && mouseY >= y_end && mouseY <= y_start) {
      for (int j = 0; j < row_color.length; ++j) {
        if (flips[i]) {
          row_color[j][0] = (int)(255*(float)(column[j]-column_max)/(column_min-column_max));
        }
        else {
          row_color[j][0] = (int)(255*(float)(column[j]-column_min)/(column_max-column_min));
        }
        row_color[j][1] = 0;
        row_color[j][2] = 255 - row_color[j][0];
      }
      redraw();
    }
    
    //Check if flip button clicked
    float lowerX = width/8 + part*width*3/4 - width/64;
    float upperX = width/8 + part*width*3/4 + width/64;
    float lowerY = 7*height/8 + 3*height/64 - height/64;
    float upperY = 7*height/8 + 3*height/64 + height/64;
    if (mouseX >= lowerX && mouseX <= upperX && mouseY >= lowerY && mouseY <= upperY) {
      flips[i] = !flips[i];
      redraw();
    }
    
    //Check if <- button clicked
    lowerX = width/8 + part*width*3/4 - width/64 - width/80;
    upperX = width/8 + part*width*3/4 - width/64 + width/80;
    lowerY = 7*height/8 + 3*height/32 - height/64;
    upperY = 7*height/8 + 3*height/32 + height/64;
    if (i != 0 && mouseX >= lowerX && mouseX <= upperX && mouseY >= lowerY && mouseY <= upperY) {
      //Switch all col arrays
      int prev = i - 1;
      String cur_yName = yNames[i];
      int[] cur_values = getColumn(values, i);
      int cur_axisMax = axes_maxs[i];
      int cur_axisMin = axes_mins[i];
      boolean flip = flips[i];
      
      for(int j = 0; j < values.length; ++j) {
        values[j][i] = values[j][prev];
        values[j][prev] = cur_values[j];
      }
      yNames[i] = yNames[prev];
      axes_maxs[i] = axes_maxs[prev];
      axes_mins[i] = axes_mins[prev];
      flips[i] = flips[prev];
      
      yNames[prev] = cur_yName;
      axes_maxs[prev] = cur_axisMax;
      axes_mins[prev] = cur_axisMin;
      flips[prev] = flip;
      redraw();
    }
    
    //Check if -> button clicked
    lowerX = width/8 + part*width*3/4 + width/64 - width/80;
    upperX = width/8 + part*width*3/4 + width/64 + width/80;
    lowerY = 7*height/8 + 3*height/32 - height/64;
    upperY = 7*height/8 + 3*height/32 + height/64;
    if (i != values[0].length-1 && mouseX >= lowerX && mouseX <= upperX && mouseY >= lowerY && mouseY <= upperY) {
      //Switch all col arrays
      int next = i + 1;
      String cur_yName = yNames[i];
      int[] cur_values = getColumn(values, i);
      int cur_axisMax = axes_maxs[i];
      int cur_axisMin = axes_mins[i];
      boolean flip = flips[i];
      
      for(int j = 0; j < values.length; ++j) {
        values[j][i] = values[j][next];
        values[j][next] = cur_values[j];
      }
      yNames[i] = yNames[next];
      axes_maxs[i] = axes_maxs[next];
      axes_mins[i] = axes_mins[next];
      flips[i] = flips[next];
      
      yNames[next] = cur_yName;
      axes_maxs[next] = cur_axisMax;
      axes_mins[next] = cur_axisMin;
      flips[next] = flip;
      redraw();
    }
  }
}