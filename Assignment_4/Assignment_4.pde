import processing.sound.*;
SoundFile grasswalk;

boolean [] keys = new boolean[128];
boolean songStart = false;

int note;
int bar;
int frameCounter;
int currentScreen = 1;
int score;
int noteIndex;

PVector metronome = new PVector(0,1);
PVector beatTemp = new PVector();




Menus screenManager;

ArrayList<Notes> notes = new ArrayList<Notes>();
ArrayList<Notes> activeNotes = new ArrayList<Notes>();

Table beatmap;

void setup(){
  size(400,400);
  
  note = int(metronome.y-1);
  bar = int(metronome.x);
  
  grasswalk = new SoundFile(this, "Grasswalk.wav");
  screenManager = new Menus();
  beatmap = loadTable("Beatmap.csv", "header");
  
  for (TableRow row: beatmap.rows()){
    beatTemp.x = row.getInt("Bar");
    beatTemp.y = row.getInt("Beat");
    beatTemp.z = row.getInt("Type");
    
    notes.add(new Notes(beatTemp));
  }
  
  
}

void draw(){
  background(0);
  switch(currentScreen){
    case 1:
      screenManager.mainMenu();
      break;
    case 2:
      screenManager.laneHighway(keys['a'], keys['s'], keys['d'], keys['j'], keys['k'], keys['l']);
      if (!songStart){
        songStart = true;
        grasswalk.play();
      }
      Metronome();
      if (metronome.x == notes.get(noteIndex).getNoteInfo().x && metronome.y == notes.get(noteIndex).getNoteInfo().y){
        activeNotes.add(notes.get(noteIndex));
        if (noteIndex+1 > notes.size())
          noteIndex++;
      }
      for (int i = activeNotes.size() ; i> 0 ; i--){
        activeNotes.get(i-1).Display();
      }
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
      metronome.x = bar;
    }
    metronome.y = note;
    print("("+metronome.x+", "+metronome.y+")");
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
