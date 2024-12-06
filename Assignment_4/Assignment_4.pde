import processing.sound.*;
SoundFile grasswalk;

PImage hitSpark;

boolean [] keys = new boolean[128];
boolean songStart = false;

int note;
int bar;
int frameCounter;
int currentScreen = 1;
int score;
int noteIndex;
int streak;

PVector beatTemp = new PVector();
PVector targetBar = new PVector(50, 300);
PVector metronome = new PVector(0,1);
PVector timeLimit = new PVector(30,1);

Menus screenManager;

ArrayList<Notes> notes = new ArrayList<Notes>();
ArrayList<Notes> activeNotes = new ArrayList<Notes>();

Table beatmap;

void setup(){
  size(400,400);
  
  hitSpark = loadImage("Hit Spark.png");
  
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
      if (noteIndex >= notes.size()-1){
        if (metronome.x == notes.get(noteIndex).getNoteInfo().x && metronome.y == notes.get(noteIndex).getNoteInfo().y){
          println("Added note "+noteIndex);
          activeNotes.add(notes.get(noteIndex));
          noteIndex++;
        }
      }
      for (int i = activeNotes.size()-1 ; i>= 0 ; i--){
          activeNotes.get(i).Display();
      }
      
      if (PVector.dist(metronome, timeLimit) == 0){
        if (score == notes.size())
          currentScreen = 4;
        else
          currentScreen = 3;
      }
      break;
    case 3:
      screenManager.winScreen(score, notes.size());
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
  }
}

void noteCheck(float lane){
  targetBar = new PVector (50+(60*(lane-1)), 300);
  for (int i = 0 ; i < activeNotes.size(); i++){
    if (activeNotes.get(i).getNoteInfo().z == lane && PVector.dist(activeNotes.get(i).getPosition(), targetBar) < 50){
      activeNotes.remove(i);
      image(hitSpark, (targetBar.x-25), (targetBar.y-25));
      score++;
      streak++;
    }
  }
}


void keyPressed(){
  switch(key){
    case 'a':
    case 'A':
      if (!keys['a'])
        noteCheck(1);
      break;
    case 's':
    case 'S':
      if (!keys['s'])
        noteCheck(2);
      break;
    case 'd':
    case 'D':
      if (!keys['d'])
        noteCheck(3);
      break;
    case 'j':
    case 'J':
      if (!keys['j'])
        noteCheck(4);
      break;
    case 'k':
    case 'K':
      if (!keys['k'])
        noteCheck(5);
      break;
    case 'l':
    case 'L':
      if (!keys['l'])
        noteCheck(6);
      break;
  }
  
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
