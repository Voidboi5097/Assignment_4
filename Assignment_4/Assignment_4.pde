import processing.sound.*;
SoundFile grasswalk;

boolean [] keys = new boolean[128];

int note = 0;
int bar = 1;
int frameCounter;

PVector timeMeasure = new PVector(1,1);

boolean songStart;

Menus screenManager;

void setup(){
  size(400,400);
  grasswalk = new SoundFile(this, "Grasswalk.wav");
  screenManager = new Menus();
}

void draw(){
  background(0);
  
  screenManager.failScreen();
  
  //screenManager.laneHighway(keys['a'], keys['s'], keys['d'], keys['j'], keys['k'], keys['l']);
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
