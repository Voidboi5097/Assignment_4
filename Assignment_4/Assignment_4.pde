import processing.sound.*;
SoundFile grasswalk;

PImage hitSpark;
PImage heartIcon;

boolean [] keys = new boolean[128];

int noteLossLimit = 400;
int frameCounter;
int currentScreen = 1;
int score;
int noteIndex;
int streak;
int playerHealth = 5;

PVector beatTemp = new PVector();
PVector targetBar = new PVector(50, 350);
PVector metronomeStart = new PVector (0,0);
PVector metronome = metronomeStart.copy();
PVector timeLimit = new PVector();

Menus screenManager;

ArrayList<Notes> notes = new ArrayList<Notes>();
ArrayList<Notes> activeNotes = new ArrayList<Notes>();

Table beatmap;

void setup(){
  size(400,400);
  
  hitSpark = loadImage("Hit Spark.png");
  heartIcon = loadImage("Heart Icon.png");
  
  grasswalk = new SoundFile(this, "Grasswalk.wav");
  screenManager = new Menus();
  beatmap = loadTable("Beatmap.csv", "header");
  
  for (TableRow row: beatmap.rows()){
    beatTemp.x = row.getInt("Bar");
    beatTemp.y = row.getInt("Beat");
    beatTemp.z = row.getInt("Type");
    
    notes.add(new Notes(beatTemp));
  }
  
  timeLimit = new PVector(notes.get(notes.size()-1).getNoteInfo().x +5, 1.0);
  
}

void draw(){
  background(0);
  switch(currentScreen){
    case 1:
      valueReset();
      screenManager.mainMenu();
      break;
    case 2:
      screenManager.laneHighway(keys['a'], keys['s'], keys['d'], keys['j'], keys['k'], keys['l']);
      if (!grasswalk.isPlaying()){
        grasswalk.jump(0);
      }
      Metronome();
      if (noteIndex <= notes.size()-1){
        if (metronome.x == notes.get(noteIndex).getNoteInfo().x && metronome.y == notes.get(noteIndex).getNoteInfo().y){
          activeNotes.add(new Notes(notes.get(noteIndex).getNoteInfo()));
          noteIndex++;
        }
      }
      for (int i = activeNotes.size()-1 ; i>= 0 ; i--){
          activeNotes.get(i).Display();
          noteManager();
      }
      fill(0);
      rect(0,0,400,50);
      healthManager();
      
      if (PVector.dist(metronome, timeLimit) == 0){
        if (score == notes.size())
          currentScreen = 4;
        else
          currentScreen = 3;
      }
      break;
    case 3:
      if (grasswalk.isPlaying())
        grasswalk.pause();
      screenManager.winScreen(score, notes.size());
      break;
    case 4:
      if (grasswalk.isPlaying())
        grasswalk.pause();
      screenManager.perfectScreen();
      break;
    case 5:
      if (grasswalk.isPlaying())
        grasswalk.pause();
      screenManager.failScreen();
      break;
  }
}

void valueReset(){
  score = 0;
  streak = 0;
  playerHealth = 5;
  metronome = metronomeStart.copy();
  noteIndex = 0;
  for (int i = 0 ; i < activeNotes.size(); i++){
      activeNotes.remove(i);
  }
}

void Metronome(){
  frameCounter++;
  if (frameCounter%15 == 0){
    if (metronome.y == 8){
      metronome.y = 0;
      metronome.x++;
    }
    metronome.y++;
    println("("+metronome.x+", "+metronome.y+")");
  }
}

void noteManager(){
  for (int i = 0 ; i < activeNotes.size(); i++){
    if (activeNotes.get(i).getPosition().y >= noteLossLimit){
      activeNotes.remove(i);
      playerHealth--;
      streak = 0;
    }
  }
}

void noteCheck(float lane){
  targetBar.x = 50+(60*(lane-1));
  for (int i = 0 ; i < activeNotes.size(); i++){
    if (activeNotes.get(i).getNoteInfo().z == lane && PVector.dist(activeNotes.get(i).getPosition(), targetBar) < 50){
      activeNotes.remove(i);
      image(hitSpark, (targetBar.x-25), (targetBar.y-25));
      score++;
      streak++;
      if (streak == 10 && playerHealth!=5){
        streak = 0;
        playerHealth++;
      }
      else if (streak == 10)
        streak = 0;
    }
  }
}

void healthManager(){
  for (int i = 0 ; i < playerHealth ; i++){
     image (heartIcon, 200+(40*i), 10);
  }
  if (playerHealth == 0)
    currentScreen = 5;
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
  if (key < keys.length)
    keys[key] = true;

}

void keyReleased(){
  if (key < keys.length)
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
