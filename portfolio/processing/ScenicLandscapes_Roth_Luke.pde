/*
Author: Luke Roth
File: ScenicLandscapes_Roth_Luke.pde
Purpose: This file creates a drawing program
that allows a user to make scenery with grass,
snow, sand, water, trees, rocks, birds, and shrubs.
Once finished, the program makes a finished scene.

**REQUIRES SOUND LIBRARY**

*/

import processing.sound.*;

// ----- Global Variables -----

float n = 0;

// keeps track of where the user currently is
int restartTime = 0;
boolean choosingTime = false;
boolean choseDay = true;
boolean finished = false;
boolean choseSunny = false;
boolean choseRainy = false;

// stores tree shapes
PGraphics trees;
HashMap<Integer, ArrayList<PVector>> leafs;

// stores gif frames
PImage[] rays = new PImage[102];
PImage[] rain = new PImage[8];
PImage[] flies = new PImage[73];

// stores sound file
SoundFile sound;

// stores current tool
String tool = "grass";

// stores scaling info
int numTrees = 0;
float treeWidth = 35;
float treeHeight = 75;
float scaleFactor = 1;

void setup() {
  
  // setup program
  size(1000,1000);
  frameRate(120);
  
  noStroke();
  
  // display intro screen
  fill(0, 0, 0);
  rect (0, 0, 1000, 1000);
  fill(255, 255, 255);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Scenic Landscapes", 500, 350);
  
  // initialize variables
  trees = createGraphics(width, height);
  leafs = new HashMap<Integer, ArrayList<PVector>>();
  
  for (int i = 0; i < 102; i++) {
    String num = String.format("%03d", i);
    rays[i] = loadImage("img/new-rays/frame_" + num + "_delay-0.05s.gif");
  }
  
  for (int i = 0; i < 8; i++) {
    rain[i] = loadImage("img/rain/frame_" + i + "_delay-0.05s.gif");
  }
  
  for (int i = 0; i < 73; i++) {
    String num = String.format("%02d", i);
    flies[i] = loadImage("img/night/frame_" + num + "_delay-0.06s.gif");
  }
  
}

/*
This function gets actiaved when the user presses
a key. It allows the user to increase and decrease
the brush size
*/
void keyPressed() {
  switch(key) {
    // decrease size
    case 'i':
      if (scaleFactor > 0.058) {
        treeWidth *= 0.9;
        treeHeight *= 0.9;
        scaleFactor *= 0.9;
        drawUI();
      }
      return;
      
    // increase size
    case 'o':
      if (scaleFactor < 1.88) {
        treeWidth /= 0.9;
        treeHeight /= 0.9;
        scaleFactor /= 0.9;
        drawUI();
      }
      return;
  }
}


/*
This function runs continuously every frame. It allows
the user to draw on the canvas and keeps the UI
always on top of the drawing. 
*/
void draw() {
  
  // allow title screen to play
  
  if (millis() >= 2000 && millis() < 5000) {
    textSize(30);
    text("By Luke Roth", 500, 500);
    textSize(40);
  }
  
  else if (millis() >= 5000) {
    
    if (millis() < 5500) { choosingTime = true; }
    
    // let the user choose the time of day
    if (choosingTime) {
      
      // highlight hovered option
      if (mouseY < 500) {
         fill(146, 226, 255);
         rect(0, 0, 1000, 500);
         fill(12, 15, 43);
         rect(0, 500, 1000, 500);
         fill(0, 0, 0, 175);
         textSize(70);
         text("Day", 500, 250);
         fill(255, 255, 255);
         text("Night", 500, 750);
      } else {
         fill(126, 206, 237);
         rect(0, 0, 1000, 500);
         fill(2, 5, 33);
         rect(0, 500, 1000, 500);
         fill(0, 0, 0);
         textSize(70);
         text("Day", 500, 250);
         fill(255, 255, 255, 175);
         text("Night", 500, 750);
      }
      
      textSize(40);
      fill(0, 0, 0);
      text("Choose a time of day", 500, 50);
      
    } else {
      
      // Drawing on the canvas
      
      // only allow the user to draw within the canvas space
      if (mouseY > 200 && mouseY < 800 && !finished) {
      
        if (mousePressed && tool == "grass") { // draw grass
          
          fill(10, 171, 34);
          ellipse(mouseX, mouseY, 100*scaleFactor, 100*scaleFactor);
          
        } else if (mousePressed && tool == "water") { // draw water
          
          fill(0, 179, 214);
          ellipse(mouseX, mouseY, 100*scaleFactor, 100*scaleFactor);
          
        } else if (mousePressed && tool == "sand") { // draw sand
          
          fill(241, 207, 86);
          ellipse(mouseX, mouseY, 100*scaleFactor, 100*scaleFactor);
          
        } else if (mousePressed && tool == "snow") { // draw snow
          
          fill(255, 255, 255);
          ellipse(mouseX, mouseY, 100*scaleFactor, 100*scaleFactor);
          
        }
      
      }
      
      // keep the UI on top
      if (!finished) {
        drawUI();
      } else {
        finishDrawing();
      }
      
    }
 
    
  }
  
  
}

/*
This function runs when the mouse is released. It is used
to slect the time of day and place objects
*/
void mouseReleased() {
  
  // don't let the user draw before they choose day/night
  if (choosingTime && ((millis() - restartTime) > 500)) {
    
    // record time of day choice
    if (mouseY < 500) {
      choseDay = true;
      fill(126, 206, 237);
      rect(0, 0, 1000, 1000);
    } else {
      choseDay = false;
      fill(12, 15, 43);
      rect(0, 0, 1000, 1000);
    }
    choosingTime = false;
  } else {
    
    // check for clicks in the canvas
    if (mouseY > 200 && mouseY < 800 && !finished) {
    
      // allow the user to place objects when they release the mouse
      switch(tool) {
        
       // place a tree
       case "tree":
         redraw();
         leafs.put(numTrees, new ArrayList<PVector>());
         createTree(mouseX, mouseY);
         image(trees, 0, 0);
         drawLeaves();
         numTrees++;
         break;
         
       // place a rock
       case "rock":
         placeObject();
         break;
       
       // place a bird
       case "bird":
         placeObject();
         break;
       
       // place a tall grass
       case "tallgrass":
         placeObject();
         break;
        
      }
    
    }
    
  }
  
  
}

/*
This function places an object at the mouse's location
based on what current tool is selected. It is called once
when the mouse button is released.
*/
void placeObject() {
  
  // place a rock
  if (tool == "rock") {
    imageMode(CENTER);
    int num = int(random(5));
    PImage img = loadImage("img/rock_" + num + ".png");
    image(img, mouseX, mouseY, 100*scaleFactor, 100*scaleFactor);
    imageMode(CORNER);
    
  } else if (tool == "bird") { // place a bird
   
    imageMode(CENTER);
    int num = int(random(2));
    PImage img = loadImage("img/bird_" + num + ".png");
    image(img, mouseX, mouseY, 100*scaleFactor, 100*scaleFactor);
    imageMode(CORNER);
    
  } else if (tool == "tallgrass") { // place a tall grass
   
    imageMode(CENTER);
    PImage img = loadImage("img/grass.png");
    image(img, mouseX, mouseY - (50*scaleFactor), 100*scaleFactor, 100*scaleFactor);
    imageMode(CORNER);
    
  }
  
  
}

/*
This function runs when the user selects that they are finished
with their drawing. It allows the user to choose the weather, then
once chosen overlays a gif on the image and plays a sound
*/
void finishDrawing() {
  
  // white bars
  fill(255, 255, 255);
  rect(0, 0, 1000, 200);
  rect(0, 800, 1000, 200);
  
  // title
  fill(0, 0, 0);
  text("Weather?", 500, 50);
  
  // notice
  textSize(25);
  text("Note: making a selection may take a few seconds", 500, 850);
  textSize(40);
  
  // shows buttons for daytime
  if (choseDay) {
  
    fill(150, 150, 150);
    rect(200, 100, 300, 100);
    fill(255, 255, 255);
    text("SUNNY", 350, 150);
    if (mouseX >= 200 && mouseX < 500 && mouseY >= 100 && mouseY < 200) {
      fill(80, 80, 80);
      rect(200, 100, 300, 100);
      fill(255, 255, 255);
      text("SUNNY", 350, 150);
    }
  
  } else { // shows buttons for nighttime
    
    fill(150, 150, 150);
    rect(200, 100, 300, 100);
    fill(255, 255, 255);
    text("CLEAR", 350, 150);
    if (mouseX >= 200 && mouseX < 500 && mouseY >= 100 && mouseY < 200) {
      fill(80, 80, 80);
      rect(200, 100, 300, 100);
      fill(255, 255, 255);
      text("CLEAR", 350, 150);
    }
    
  }
  
  // shows rainy weather button
  fill(150, 150, 150);
  rect(500, 100, 300, 100);
  fill(255, 255, 255);
  text("RAINY", 650, 150);
  if (mouseX >= 500 && mouseX < 800 && mouseY >= 100 && mouseY < 200) {
    fill(80, 80, 80);
    rect(500, 100, 300, 100);
    fill(255, 255, 255);
    text("RAINY", 650, 150);
  }
  
  // plays the sunny gif
  if (choseSunny && choseDay) {
    
    PImage canvas = loadImage("finishedCanvas.tiff");
    image(canvas, 0, 0);
    
    frameRate(30);
    blendMode(SCREEN);
    image(rays[frameCount%102], 0, 0, 1000, 800);
    blendMode(BLEND);
    
    // black bars
    fill(0, 0, 0);
    rect(0, 0, 1000, 200);
    rect(0, 800, 1000, 200);
  }
  
  // plays the fireflies nighttime gif
  if (choseSunny && !choseDay) {
    
    PImage canvas = loadImage("finishedCanvas.tiff");
    image(canvas, 0, 0);
    
    // add a blue tint
    fill(0, 0, 133, 50);
    rect(0, 0, 1000, 1000);
    
    frameRate(10);
    blendMode(SCREEN);
    image(flies[frameCount%73], 0, 200, 1000, 600);
    blendMode(BLEND);
    
    // black bars
    fill(0, 0, 0);
    rect(0, 0, 1000, 200);
    rect(0, 800, 1000, 200);
    
  }
  
  // plays the rainy gif
  if (choseRainy) {
    
    PImage canvas = loadImage("finishedCanvas.tiff");
    image(canvas, 0, 0);
    
    // add a blue tint
    fill(0, 0, 133, 50);
    rect(0, 0, 1000, 1000);
    
    frameRate(30);
    blendMode(MULTIPLY);
    image(rain[frameCount%8], 0, 0, 1000, 800);
    blendMode(BLEND);
    
    // black bars
    fill(0, 0, 0);
    rect(0, 0, 1000, 200);
    rect(0, 800, 1000, 200);
    
  }
  
  
}

/*
This function runs when the mouse is pressed down.
It is used to select different tools and options
from the menu.
*/
void mousePressed() {
  
  // don't do anything if the user is choosing a time
  if (choosingTime) {
    return;
  }
  
  // check for buttons in different places when the user is finished
  if (finished) {
    
    // chose sunny
    if (mouseX >= 200 && mouseX < 500 && mouseY >= 100 && mouseY < 200) {
      choseSunny = true;
      saveFrame("finishedCanvas.tiff");
      if (choseDay) {
        sound = new SoundFile(this, "sound/day.mp3");
        sound.loop();
        
      } else {
        sound = new SoundFile(this, "sound/night.mp3");
        sound.loop();
      }
    }
    
    // chose rainy
    if (mouseX >= 500 && mouseX < 800 && mouseY >= 100 && mouseY < 200) {
      choseRainy = true;
      saveFrame("finishedCanvas.tiff");
      sound = new SoundFile(this, "sound/rain.mp3");
      sound.loop();
    }
    
  }
  
  //--------- TOP BUTTONS ---------------
    
  // reset button
  if (mouseX < 200 && mouseY < 100) {
    redraw();
    if (choseDay) {
      fill(126, 206, 237);
    } else {
      fill(12, 15, 43);
    }
    rect(0, 0, 1000, 1000);
  }
  
  // restart button
  if (mouseX < 200 && mouseY >= 100 && mouseY < 200) {
    choosingTime = true;
    restartTime = millis();
  }
  
  // decrease size button
  if (mouseX > 200 && mouseX < 500 && mouseY < 100) {
    if (scaleFactor > 0.058) {
        treeWidth *= 0.9;
        treeHeight *= 0.9;
        scaleFactor *= 0.9;
        drawUI();
      }
  }
  
  // increase size button
  if (mouseX > 500 && mouseX < 800 && mouseY < 100) {
    if (scaleFactor < 1.88) {
        treeWidth /= 0.9;
        treeHeight /= 0.9;
        scaleFactor /= 0.9;
        drawUI();
      }
  }
  
  // finish button
  if (mouseX >= 200 && mouseX < 800 && mouseY >= 100 && mouseY < 200) {
    finished = true;
    finishDrawing();
  }
  
  //-------- BOTTOM BUTTONS -------------
  
  //TOP ROW
  if (mouseY >= 800 && mouseY < 900) {
    
    // grass button
    if (mouseX <= 200) {
      tool = "grass";
    }
    
    // snow button
    if (mouseX > 200 && mouseX <= 400) {
      tool = "snow";
    }
    
    // tree button
    if (mouseX > 600 && mouseX <= 800) {
      tool = "tree";
    }
    
    // bird button
    if (mouseX > 800 && mouseX <= 1000) {
      tool = "bird";
    }
   
    
  } else if (mouseY >= 900) {  // BOTTOM ROW
    
    // sand button
    if (mouseX <= 200) {
      tool = "sand";
    }
    
    // water button
    if (mouseX > 200 && mouseX <= 400) {
      tool = "water";
    }
    
    // rock button
    if (mouseX > 600 && mouseX <= 800) {
      tool = "rock";
    }
    
    // shrubs button
    if (mouseX > 800 && mouseX <= 1000) {
      tool = "tallgrass";
    }
    
  }
  
}

/*
This function is used to draw the UI buttons
on the screen. It is called from the draw function,
so it gets drawn every frame
*/
void drawUI() {
  
  // don't draw the UI when finished
  if (finished) {
    return;
  }
  
  // white bars
  fill(255, 255, 255);
  rect(0, 0, 1000, 200);
  rect(0, 800, 1000, 200);
  
  //--------- TOP BUTTONS ---------------
  
  // reset button
  fill(150, 150, 150);
  rect(0, 0, 200, 100);
  fill(255, 255, 255);
  text("RESET", 100, 50);
  if (mouseX < 200 && mouseY < 100) {
    fill(80, 80, 80);
    rect(0, 0, 200, 100);
    fill(255, 255, 255);
    text("RESET", 100, 50);
  }
  
  // restart button
  fill(150, 150, 150);
  rect(0, 100, 200, 100);
  fill(255, 255, 255);
  text("RESTART", 100, 150);
  if (mouseX < 200 && mouseY >= 100 && mouseY < 200) {
    fill(80, 80, 80);
    rect(0, 100, 200, 100);
    fill(255, 255, 255);
    text("RESTART", 100, 150);
  }
  
  // finish button
  fill(150, 150, 150);
  rect(200, 100, 600, 100);
  fill(255, 255, 255);
  text("FINISH", 500, 150);
  if (mouseX >= 200 && mouseX < 800 && mouseY >= 100 && mouseY < 200) {
    fill(80, 80, 80);
    rect(200, 100, 600, 100);
    fill(255, 255, 255);
    text("FINISH", 500, 150);
  }
  
  // decrease button
  fill(150, 150, 150);
  rect(200, 0, 300, 100);
  fill(255, 255, 255);
  text("DECREASE: I", 350, 50);
  if (mouseX > 200 && mouseX < 500 && mouseY < 100) {
    fill(80, 80, 80);
    rect(200, 0, 300, 100);
    fill(255, 255, 255);
    text("DECREASE: I", 350, 50);
  }
  
  // increase button
  fill(150, 150, 150);
  rect(500, 0, 300, 100);
  fill(255, 255, 255);
  text("INCREASE: O", 650, 50);
  if (mouseX > 500 && mouseX < 800 && mouseY < 100) {
    fill(80, 80, 80);
    rect(500, 0, 300, 100);
    fill(255, 255, 255);
    text("INCREASE: O", 650, 50);
  }
  
  
  //-------- BOTTOM BUTTONS -------------
  
  
  // ---- BRUSHES ----
  
  // grass
  fill(150, 150, 150);
  rect(0, 800, 200, 100);
  fill(255, 255, 255);
  text("GRASS", 100, 850);
  
  // sand
  fill(150, 150, 150);
  rect(0, 900, 200, 100);
  fill(255, 255, 255);
  text("SAND", 100, 950);
  
  // snow
  fill(150, 150, 150);
  rect(200, 800, 200, 100);
  fill(255, 255, 255);
  text("SNOW", 300, 850);
  
  // water
  fill(150, 150, 150);
  rect(200, 900, 200, 100);
  fill(255, 255, 255);
  text("WATER", 300, 950);
  
  
  
  // ---- OBJECTS ----
  
  // tree
  fill(150, 150, 150);
  rect(600, 800, 200, 100);
  fill(255, 255, 255);
  text("TREE", 700, 850);
  
  // rock
  fill(150, 150, 150);
  rect(600, 900, 200, 100);
  fill(255, 255, 255);
  text("ROCK", 700, 950);
  
  // bird
  fill(150, 150, 150);
  rect(800, 800, 200, 100);
  fill(255, 255, 255);
  text("BIRD", 900, 850);
  
  // tall grass
  fill(150, 150, 150);
  rect(800, 900, 200, 100);
  fill(255, 255, 255);
  text("SHRUBS", 900, 950);
  
  
  // show a dark button when the tool is selected
  // also show a preview of the size in the top right
  switch(tool) {
    
    case "grass":
      fill(80, 80, 80);
      rect(0, 800, 200, 100);
      fill(255, 255, 255);
      text("GRASS", 100, 850);
      
      fill(10, 171, 34);
      ellipse(900, 100, 100*scaleFactor, 100*scaleFactor);
      break;
      
    case "sand":
      fill(80, 80, 80);
      rect(0, 900, 200, 100);
      fill(255, 255, 255);
      text("SAND", 100, 950);
      
      fill(241, 207, 86);
      ellipse(900, 100, 100*scaleFactor, 100*scaleFactor);
      break;
    
    case "snow":
      fill(80, 80, 80);
      rect(200, 800, 200, 100);
      fill(255, 255, 255);
      text("SNOW", 300, 850);
      
      strokeWeight(5);
      stroke(0, 0, 0);
      fill(255, 255, 255);
      ellipse(900, 100, 100*scaleFactor, 100*scaleFactor);
      noStroke();
      break;
      
    case "water":
      fill(80, 80, 80);
      rect(200, 900, 200, 100);
      fill(255, 255, 255);
      text("WATER", 300, 950);
      
      fill(0, 179, 214);
      ellipse(900, 100, 100*scaleFactor, 100*scaleFactor);
      break;
      
    case "tree":
      fill(80, 80, 80);
      rect(600, 800, 200, 100);
      fill(255, 255, 255);
      text("TREE", 700, 850);
      
      fill(112, 56, 17);
      rectMode(CORNERS);
      rect(980 - (treeWidth * 3), 180 - (treeHeight * 3), 1000, 200);
      rectMode(CORNER);
      break;
      
    case "rock":
      fill(80, 80, 80);
      rect(600, 900, 200, 100);
      fill(255, 255, 255);
      text("ROCK", 700, 950);
      
      imageMode(CENTER);
      PImage img = loadImage("img/rock_0.png");
      image(img, 900, 100, 100*scaleFactor, 100*scaleFactor);
      imageMode(CORNER);
      break;
      
    case "bird":
      fill(80, 80, 80);
      rect(800, 800, 200, 100);
      fill(255, 255, 255);
      text("BIRD", 900, 850);
      
      imageMode(CENTER);
      img = loadImage("img/bird_0.png");
      image(img, 900, 100, 100*scaleFactor, 100*scaleFactor);
      imageMode(CORNER);
      break;
      
    case "tallgrass":
      fill(80, 80, 80);
      rect(800, 900, 200, 100);
      fill(255, 255, 255);
      text("SHRUBS", 900, 950);
      
      imageMode(CENTER);
      img = loadImage("img/grass.png");
      image(img, 900, 100, 100*scaleFactor, 100*scaleFactor);
      imageMode(CORNER);
      break;
    
    
  }
  
  redraw();
  
}

/*
This function starts the creation of a new tree.
It creates the base 3 branches, wich will recursively
create new branches.
*/
void createTree(int posX, int posY) {
  
  trees.beginDraw();
  trees.noStroke();
  trees.background(0, 0);
  
  // debugging
  //System.out.println("Width: " + treeWidth + ", Height: " + treeHeight + ", SF: " + scaleFactor);
  
  // create the base branches
  for (int i = 3; i > 0; i--) {
    
    trees.fill(112 + (i*15), 56 + (i*15), 17 + (i*15));
    branch(posX, posY, treeWidth, -HALF_PI, treeHeight, 0);
  }
  
  trees.endDraw();  
}

/*
This function creates new branches for trees. It makes them at random
angles and randomly creates smaller branches that connect to them.
Also calls the leaf function to create leaves for the branch
*/
void branch(float x, float y, float bSize, float theta, float bLength, float pos) {
  
  // change the noise
  n += 0.01;
  // set the size of the branch
  float diam = lerp(bSize, 0.7*bSize, pos/bLength);
  
  // vary the size slightly
  diam *= map(noise(n), 0, 1, 0.4, 1.6);
  
  // draw the branch
  trees.ellipse(x, y, diam, diam);
  
  // make sure the size isn't too small
  if (bSize > 0.6 * scaleFactor) {
    if (pos < bLength) {
      
      // randomly offset and create a new branch
      x += cos(theta + random(-PI/10, PI/10));
      y += sin(theta + random(-PI/10, PI/10));
      branch(x, y, bSize, theta, bLength, pos+1);
    } else {
      
      ArrayList<PVector> currList = leafs.get(numTrees);
      currList.add(new PVector(x, y));
      leafs.put(numTrees, currList);
      
      // randomly decides whether to draw the next branches
      boolean drawleftBranch = random(1) > 0.1;
      boolean drawrightBranch = random(1) > 0.1;
      
      // draws new branches if decided earlier
      if (drawleftBranch) {
        branch(x, y, random(0.5, 0.7)*bSize, theta - random(PI/15, PI/5), random(0.6, 0.8)*bLength, 0);
      }
      
      if (drawrightBranch) {
        branch(x, y, random(0.5, 0.7)*bSize, theta + random(PI/15, PI/5), random(0.6, 0.8)*bLength, 0);
      }
      
      // when no branches will be drawn, create an end cap
      if (!drawleftBranch && !drawrightBranch) {
        
        trees.pushMatrix();
        trees.translate(x, y);
        trees.rotate(theta);
        trees.quad(0, -diam/2, 2*diam, -diam/6, 2*diam, diam/6, 0, diam/2);
        trees.popMatrix();
      }
    }
  }
}

/*
This function creates randomly sized circles to act
as leaves for the trees
*/
void drawLeaves() {
  
  // loops through all the leaves that were created in the branch function
  for (int i = 0; i < leafs.get(numTrees).size(); i++) {
    
    // randomly color and position leaves
    fill(random(10, 50), random(70, 140), random(10, 40));
    float diam = random(0, 20 * scaleFactor);
    float jitterX = random(-20, 20);
    float jitterY = random(-20, 20);
    
    // place the leaf with the random place and color
    ellipse(leafs.get(numTrees).get(i).x + jitterX, leafs.get(numTrees).get(i).y + jitterY, diam, diam);
  }
}
