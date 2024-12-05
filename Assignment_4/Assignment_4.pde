import processing.sound.*;
SoundFile grasswalk;

int note = 0;
int bar = 1;
int frameCounter;

PVector timeMeasure = new PVector(1,1);

boolean songStart;

void setup(){
  size(400,400);
  grasswalk = new SoundFile(this, "Grasswalk.wav");
}

void draw(){
  
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
