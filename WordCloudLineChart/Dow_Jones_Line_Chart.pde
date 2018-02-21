String path = "data.csv";
String path2 = "monthly_three_words.csv";
String[] months;
int[] years;
float[] values;
String[][] words;
int year;
float yAxisMax;
float yAxisMin;
float[] year_values;
boolean word_cloud;
int cloud_month_index;
String hover_word;

void loadStr() {
  String[] lines = loadStrings(path);
  months = new String[lines.length-1];
  years = new int[lines.length-1];
  values = new float[lines.length-1];
  for (int i = 1; i < lines.length; ++i) {
    String[] row = split(lines[i], ",");
    months[i-1] = row[0];
    years[i-1] = parseInt(row[1]);
    values[i-1] = parseFloat(row[2]);
  }
  lines = loadStrings(path2);
  words = new String[lines.length-1][3];
  for (int i = 1; i < lines.length; ++i) {
    String[] row = split(lines[i], ",");
    words[i-1][0] = row[2];
    words[i-1][1] = row[3];
    words[i-1][2] = row[4];
  }
}

void axes() {
  stroke(255, 255, 255);
  line(3*width/32, 7*height/8, 3*width/32, height/8); //draw y-axis
  line(3*width/32, 7*height/8, 31*width/32, 7*height/8); //draw x-axis
  yAxisMin = 1.25 * min(year_values);
  yAxisMax = 1.25 * max(year_values);

  //draw y-axis tick marks and labels
  fill(0, 0, 0);
  for (int i = 0; i <= 6; ++i) {
    line(3*width/32, (i+1)*height/8, 3*width/32 - width/100, (i+1)*height/8); //y-axis tick marks
    String axisLabel = "" + nf((i*(yAxisMax-yAxisMin)/6.0) + yAxisMin, 1, 2);
    textSize(width/100);
    textAlign(RIGHT, CENTER);
    text(axisLabel, 3*width/32 - width/50, (7-i)*height/8); //y-axis labels
  }

  //draw dotted line for zero line
  int zero_height = (7*height/8) - (int)(((-yAxisMin)/(yAxisMax-yAxisMin))*(3*height/4));
  for (int i = 3*width/32 + width/200; i < 31*width/32; i+=20) {
    ellipse (i, zero_height, 10, 1);
  }

  //title
  textSize(32*width/1000);
  textAlign(CENTER);
  text(year, width/2, height*4/50);
  fill(0, 0, 0);

  //draw <- and -> boxes
  rectMode(CENTER);
  rect(width/2 - width/14, 3*height/50, width/40, height/32);
  rect(width/2 + width/14, 3*height/50, width/40, height/32);
  fill(255, 255, 255);
  textSize(16*width/1000);
  textAlign(CENTER, CENTER);
  text("<-", width/2 - width/14, 3*height/50 - height/200);
  text("->", width/2 + width/14, 3*height/50 - height/200);

  //y-axis name
  fill(0, 0, 0);
  pushMatrix();
  translate(width/40, height/2);
  rotate(-1*PI/2);
  textSize(16*height/600);
  textAlign(CENTER);
  text("Monthly Net Change in Dow Jones", 0, 0);
  popMatrix();

  //x-axis name
  textSize(16*width/1000);
  textAlign(CENTER);
  text("Month", width/2, height*49/50);
  fill(0, 0, 0);

  //draw x-axis tick marks and labels
  for (int i = 0; i < 12; ++i) { //iterate through 12 months
    int x = width/16 + (int)(1.0*(i+1)/12*(55*width/64));
    int yStart = 7*height/8;
    int yEnd = 7*height/8 + height/100;
    line(x, yStart, x, yEnd); //x-axis tick-marks

    //x-axis labels
    String name = months[i];
    textSize(1.2*height/60);
    textAlign(CENTER, CENTER);
    text(name, x, yEnd + height/70);
  }
}

void lineChart() {
  for (int i = 0; i < year_values.length; ++i) {
    int curX = width/16 + (int)(1.0*(i+1)/year_values.length*(55*width/64));
    float curValue = year_values[i];
    int curY = (7*height/8) - (int)(((curValue-yAxisMin)/(yAxisMax-yAxisMin))*(3*height/4));
    if (i < year_values.length - 1) { //draw a line connecting this ellipse to next if not last ellipse
      int nextX = width/16 + (int)(1.0*(i+2)/year_values.length*(55*width/64));
      float nextValue = year_values[i+1];
      int nextY = (7*height/8) - (int)(((nextValue-yAxisMin)/(yAxisMax-yAxisMin))*(3*height/4));
      line(curX, curY, nextX, nextY);
    }
    fill(255, 0, 0); //default fill red
    if (curValue > 0) { //if value is above 0, make green
      fill(73, 166, 76);
    }
    ellipse(curX, curY, 80, 80);
    
    String word1 = words[i+12*(year-2009)][0]; //top word
    String word2 = words[i+12*(year-2009)][1]; //middle word
    String word3 = words[i+12*(year-2009)][2]; //bottom word
    
    if (word1.equals(hover_word)) { fill(255,255,0); } //if top word matches currently hovered word, highlight yellow
    else { fill(255,255,255); }
    PShape rect1 = createShape(RECT,0,0,55,13);
    shape(rect1,curX,curY-13);
    if (word2.equals(hover_word)) { fill(255,255,0); } //if middle word matches currently hovered word, highlight yellow
    else { fill(255,255,255); }
    PShape rect2 = createShape(RECT,0,0,55,13);
    shape(rect2,curX,curY+2);
    if (word3.equals(hover_word)) { fill(255,255,0); } //if bottom word matches currently hovered word, highlight yellow
    else { fill(255,255,255); }
    PShape rect3 = createShape(RECT,0,0,55,13);
    shape(rect3,curX,curY+17);
    fill(0,0,0);
    textSize(width/130);
    textAlign(CENTER, CENTER);
    text(word1, curX, curY-15);
    text(word2, curX, curY);
    text(word3, curX, curY+15);
  }
}

void create_word_cloud() {
  String month = months[cloud_month_index]; //store month of cloud clicked
  String pic_file_name = "cloud/" + year + month + ".png"; //get proper format of text file name
  PImage img = loadImage(pic_file_name);
  int cur_width = img.width; //store width of image
  int cur_height = img.height; //store height of image
  int cur_x = (width - cur_width)/2; //top left corner of image
  int cur_y = (height - cur_height)/2; //top right corner of image
  image(img, cur_x, cur_y, cur_width, cur_height); //create image 
}

void mouseHover() {
  if (!word_cloud) {
    for (int i = 0; i < year_values.length; ++i) {
        int curX = width/16 + (int)(1.0*(i+1)/year_values.length*(55*width/64)); //store x position of center of circle
        float curValue = year_values[i];
        int curY = (7*height/8) - (int)(((curValue-yAxisMin)/(yAxisMax-yAxisMin))*(3*height/4)); //store y position of center of circle
        int topY = curY-13;
        int middleY = curY+2;
        int bottomY = curY+17;
        if((mouseY < topY + 6.5) && (mouseY > topY - 6.5) && (mouseX > curX - 27.5) && (mouseX < curX + 27.5)) { //if mouse over top rectangle
          String top_word = words[i+12*(year-2009)][0];
          hover_word = top_word;
        }
        else if((mouseY < middleY + 6.5) && (mouseY > middleY - 6.5) && (mouseX > curX - 27.5) && (mouseX < curX + 27.5)) { //if mouse over middle rectangle
          String middle_word = words[i+12*(year-2009)][1];
          hover_word = middle_word;
        }
        else if((mouseY < bottomY + 6.5) && (mouseY > bottomY - 6.5) && (mouseX > curX - 27.5) && (mouseX < curX + 27.5)) { //if mouse over bottom rectangle
          String bottom_word = words[i+12*(year-2009)][2];
          hover_word = bottom_word;
        }
    }
  }
}

void setup() {
  size(1200, 620);
  // surface.setResizable(true); //allow surface to be resizable
  loadStr(); //load data from csv into arrays
  year = 2009; //initial year to start at, doesn't really matter which
  year_values = new float[12]; //initialize year_values
  int start = (year - 2009)*12; //calculate start index in full value array
  //System.arraycopy(values, start, year_values, 0, 12); //copy values from that year into year_values array
  for (int i = 0; i < year_values.length; ++i) {
    year_values[i] = values[start + i];
  }
  word_cloud = false;
  cloud_month_index = 0;
  hover_word = "";
}

void draw() {
  background(208, 208, 208); //set background to grey
  if (!word_cloud) {
    axes(); //build axes and titles
    lineChart(); //build line chart
    mouseHover();
  } 
  else {
    create_word_cloud();
  }
}

void mouseClicked() {
  if (word_cloud) {
    word_cloud = false;
  } 
  else {
    //Check if <- button clicked
    float lowerX = width/2 - width/14 - width/80;
    float upperX = width/2 - width/14 + width/80;
    float lowerY = 3*height/50 - height/64;
    float upperY = 3*height/50 + height/64;
    if (mouseX >= lowerX && mouseX <= upperX && mouseY >= lowerY && mouseY <= upperY && year > 2009) {
      --year; //decrement year
      int start = (year - 2009)*12; //recalculate start index in full value array
      // System.arraycopy(values, start, year_values, 0, 12); //copy values from that year into year_values array
      for (int i = 0; i < year_values.length; ++i) {
        year_values[i] = values[start + i];
      }
    }

    //Check if -> button clicked
    lowerX = width/2 + width/14 - width/80;
    upperX = width/2 + width/14 + width/80;
    if (mouseX >= lowerX && mouseX <= upperX && mouseY >= lowerY && mouseY <= upperY && year < 2015) {
      ++year; //increment year
      int start = (year - 2009)*12; //recalculate start index in full value array
      // System.arraycopy(values, start, year_values, 0, 12); //copy values from that year into year_values array
      for (int i = 0; i < year_values.length; ++i) {
        year_values[i] = values[start + i];
      }
    }

    //Check if circle clicked
    for (int i = 0; i < year_values.length; ++i) {
      int curX = width/16 + (int)(1.0*(i+1)/year_values.length*(55*width/64));
      float curValue = year_values[i];
      int curY = (7*height/8) - (int)(((curValue-yAxisMin)/(yAxisMax-yAxisMin))*(3*height/4));
      double distance = Math.sqrt(Math.pow((curY-mouseY), 2) + Math.pow((curX-mouseX), 2));
      if (distance <= 40.0) {
        cloud_month_index = i;
        word_cloud = true;
      }
    }
  }
}