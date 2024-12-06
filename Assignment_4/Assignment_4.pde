import processing.sound.*;
SoundFile grasswalk;

boolean [] keys = new boolean[128];

int note = 0;
int bar = 1;
int frameCounter;
int currentScreen;
int score;

PVector timeMeasure = new PVector(1,1);

boolean songStart;

Menus screenManager;

void setup(){
  size(400,400);
  
  currentScreen = 5;
  
  grasswalk = new SoundFile(this, "Grasswalk.wav");
  
  screenManager = new Menus();
  
  
}

void draw(){
  background(0);
  
  switch(currentScreen){
    case 1:
      screenManager.mainMenu();
      break;
    case 2:
      screenManager.laneHighway(keys['a'], keys['s'], keys['d'], keys['j'], keys['k'], keys['l']);
      break;
    case 3:
      screenManager.winScreen(score);
      break;
    case 4:
      screenManager.perfectScreen();
      break;
    case 5:
      screenManager.failScreen();
      break;
  }
}


void Metronome(){
  frameCounter++;
  if (frameCounter%15 == 0){
    note++;
    if (note >8){
      note = 1;
      bar++;
      timeMeasure.y = bar;
    }
    timeMeasure.x = note;
    print(timeMeasure);
  }
}



void keyPressed(){
  keys[key] = true;
}

void keyReleased(){
  keys[key] = false;
}

void mouseClicked(){
  switch (currentScreen){
    case 1:
      if (mouseX >= 140 && mouseX <= 260 && mouseY >= 225 && mouseY <= 285)
        currentScreen = 2;
      else if (mouseX >= 140 && mouseX <= 260 && mouseY >= 300 && mouseY <= 349)
        exit();
        
      break;
    case 3:
    case 4:
    case 5:
      if (mouseX >= 140 && mouseX <= 260 && mouseY >= 225 && mouseY <= 285)
        currentScreen = 1;
      else if (mouseX >= 140 && mouseX <= 260 && mouseY >= 300 && mouseY <= 349)
        exit();
        
      break;
  }
}
