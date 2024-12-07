/*
Final Project time! This game is a clone of Guitar Hero, except that instead of 5 note lanes there are 6 mapped out to ASDJKL. Everything is executed in this main script, with 3 other classes
that allow for the magic to happen. Long ---- lines separate the different functoins while the smaller one are used to separate the cases in draw() that equivalate to the different menu screens.
*/

import processing.sound.*;                                                              // Imports the sound library from processing, this allows us to actually call audio files and play the main song

SoundFile grasswalk;                                                                    // Grasswalk is the song played in this game

PImage heartIcon;                                                                       // Heart Icon used to display how many lives the player has              

int metronomeCounter;                                                                   // Used by metronome to count frames in the Metronome function, allowing for the metronome to function
int currentScreen = 1;                                                                  // Determines which screen should be displaying, used by a Switch Case statement in Draw
int score;                                                                              // Keeps track of how many notes the player hit
int streak;                                                                             // Keeps track of how many notes the player hit in a row without missing, used to give the player health
int noteIndex;                                                                          // Used to reference the notes stored in the notes ArrayList
int maxHealth = 5;                                                                      // Max number of lives the player can have
int playerHealth = maxHealth;                                                           // How many lives the player has
int noteLossLimit = 400;                                                                // Indicates what Y value a note needs to hit to be considered "missed"
int rainCounter;                                                                        // Frame counter for the rain in the lose screen
int rainRandom;                                                                         // Holds a random value used to determine how much of a gap there should be between raindrop generation
int hitBarY = 350;                                                                      // Y position where the a note needs to be around for a player to hit it

PVector metronome = new PVector(0,0);                                                   // Used to count Beats and Bars in order to time note generation to the song. X value = bar, Y value = beat.
PVector timeLimit = new PVector();                                                      // Stores the last beat in the song, if Metronome hits this the player finished the song and won
PVector raindropPos = new PVector();                                                    // Used to assign Raindrop object a position vector upon construction
PVector[] lanes = new PVector[6];                                                       // Vector array with the position the point in each lane where the player needs to hit the notes.

ArrayList<Notes> noteBank = new ArrayList<Notes>();                                     // Bank of all the notes, data is read from Beatmap.csv
ArrayList<Notes> activeNotes = new ArrayList<Notes>();                                  // Copies note information from noteBank to create active notes in play

ArrayList<Raindrop> raindrops = new ArrayList<Raindrop>();                              // ArrayList of raindrop objects used for the rain effect in the lose screen

boolean [] keys = new boolean[128];                                                     // Boolean array of keys, used to check if a note is being held down
boolean rainTimer = false;                                                              // Used to make sure rainRandom isn't assigned a random value every frame

Menus screenManager;                                                                    // Menu object, used to create all the menu screens

Table beatmap;                                                                          // Table object used to read all the information from Beatmap.csv

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

void setup(){
  
/*
Setup is used to assign a file to the variables that need them, as well as instantiate the Menus object.
*/
  
  size(400,400);
  
  heartIcon = loadImage("Heart Icon.png");
  
  grasswalk = new SoundFile(this, "Grasswalk.wav");
  
  beatmap = loadTable("Beatmap.csv", "header");
  
  lanes[0] = new PVector(50, hitBarY);
  lanes[1] = new PVector(110, hitBarY);
  lanes[2] = new PVector(170, hitBarY);
  lanes[3] = new PVector(230, hitBarY);
  lanes[4] = new PVector(290, hitBarY);
  lanes[5] = new PVector(350, hitBarY);
  
  screenManager = new Menus();
  
  for (TableRow row: beatmap.rows()){                                                                     // For loop that runs for as many rows as Beatmap.csv has. Adds a new Notes object to the
    noteBank.add(new Notes(new PVector(row.getInt("Bar"), row.getInt("Beat"), row.getInt("Type"))));      // noteBank ArrayList using the Bar, Beat, and Type integers read from the .cvs.
  }                                                                                                              
  
  timeLimit = new PVector(noteBank.get(noteBank.size()-1).getNoteInfo().x +5, 1.0);                       // Has to be done after noteBank has been filled in. Makes the Metronome limit equal to 5 bar measures
}                                                                                                         // after the final note (length of song fade trail)

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

void draw(){
  background(0);
  
  switch(currentScreen){       
/*-------------------------------------------------------------------------------------------------------------------------------------*/
    case 1: /*-------------------------------------------------------------------------------------------------------------------------*/// Case 1 is the main menu. When here the code will reset all values
      ValueReset();                                                                                                                      // changed during runtime in order to allow for internal replayability
      screenManager.mainMenu();                                                                                                          // without the need to restart the program
      break;
/*-------------------------------------------------------------------------------------------------------------------------------------*/// Case 2 is the main game screen. It calls the noteHighway screen       
    case 2: /*-------------------------------------------------------------------------------------------------------------------------*/// while telling it if any of the game keys are being pressed down 
      screenManager.laneHighway(keys['a'], keys['s'], keys['d'], keys['j'], keys['k'], keys['l']);                                       // in order for them to be displayed appropriately. The code checks
      if (!grasswalk.isPlaying()){                                                                                                       // if Grasswalk is playing, playing the song from the 0 second mark if 
        grasswalk.jump(0);                                                                                                               // it wasn't playing.
      }
      Metronome();                                                                                                                       // The metronome function is called to start the timer and create 
      if (noteIndex <= noteBank.size()-1){                                                                                               // the notes in sync with the song. First it checks if the noteIndex 
        if (metronome.x == noteBank.get(noteIndex).getNoteInfo().x && metronome.y == noteBank.get(noteIndex).getNoteInfo().y){           // isn't equal to the size of the noteBank ArrayList in order to avoid 
          activeNotes.add(new Notes(noteBank.get(noteIndex).getNoteInfo()));                                                             // null pointer exceptions before checking if the note in the bank's 
          noteIndex++;                                                                                                                   // time measurement is the same as the metronome's, creating it if it
        }                                                                                                                                //  is and increasing the index by 1.
      }
      
      for (int i = activeNotes.size()-1 ; i>= 0 ; i--){                                                                                  // Next the code runs a for loop equal to how many active notes are on  
          activeNotes.get(i).Display();                                                                                                  // screen, running backwards to avoid issues if the notes are removed 
          NoteManager();                                                                                                                 // due to being hit or missed. After the note has been moved it checks 
      }                                                                                                                                  // if the there are any notes at the missed threshhold in order to 
                                                                                                                                         // remove them and reduce the player's lives.
                                                                                                                                         
      fill(0);                                                                                                                           // A black rectangle is drawn at the top of the screen in order to  
      rect(0,0,400,50);                                                                                                                  // hide the coordinates where the notes are created and to provide
      HealthManager();                                                                                                                   //  a blank area to display the player's lives
      
      if (PVector.dist(metronome, timeLimit) == 0){                                                                                      // This checks if the Metronome has reached the time limit, if so the 
        if (score == noteBank.size())                                                                                                    // player has won and the player is transitioned to the win screen. 
          currentScreen = 4;                                                                                                             // If their score = the total number of notes, they got a perfect 
        else                                                                                                                             // score and are transitioned to the special screen. If not, they 
          currentScreen = 3;                                                                                                             // are transfered to the normal win screen
      }
      
      break;
      
/*-------------------------------------------------------------------------------------------------------------------------------------*/
    case 3: /*-------------------------------------------------------------------------------------------------------------------------*/// Case 3 is the default win screen. It calls the winScreen function 
      if (grasswalk.isPlaying())                                                                                                         // while providing it with the player's score and the total number of
        grasswalk.pause();                                                                                                               // notes in the song so that if I add more I won't have to recode the
      screenManager.winScreen(score, noteBank.size());                                                                                   // maximum possible score.
      break;
      
/*-------------------------------------------------------------------------------------------------------------------------------------*/
    case 4: /*-------------------------------------------------------------------------------------------------------------------------*/// Case 4 is the Full Combo screen. No values need to be inputted
      if (grasswalk.isPlaying())                                                                                                         // since it just says the player got a perfect score.
        grasswalk.pause();
      screenManager.perfectScreen();
      break;

/*-------------------------------------------------------------------------------------------------------------------------------------*/
    case 5: /*-------------------------------------------------------------------------------------------------------------------------*/// Case 5 is the lose screen. It calls the MakeItRain function to
      if (grasswalk.isPlaying())                                                                                                         // create the rainfall effect in the background. Similar to Case
        grasswalk.pause();                                                                                                               // 3 and 4, it also checks if Grasswalk is playing, pausing it so.
      MakeItRain();
      screenManager.failScreen();
      break;
  }
}

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/ // end of draw()

void ValueReset(){
/*
Description: valueReset simply resets the values of all variables that are changed during runtime in order for the player to be able to replay the game
simply by clicking Replay in the win or lose screens. It resets all values and clears both of the ArrayLists that are altered during runtime.
*/
  score = 0;
  streak = 0;
  playerHealth = 5;
  metronomeCounter = 0;
  metronome = new PVector(0,0);
  noteIndex = 0;
  rainTimer = false;
  rainCounter = 0;
  rainRandom = 0;
  
  for (int i = 0 ; i < activeNotes.size(); i++){
      activeNotes.remove(i);
  }
  
  for (int i = 0 ; i < raindrops.size(); i++){
      raindrops.remove(i);
  }
  
}

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

void Metronome(){
/*
Description: Metronome is the most important function in the entire game. It counts every frame when called, increasing the Y Value of the metronome PVector by 1
every 15 frames, counting perfect 8th note measures for a 120bpm song. Every time the Y value would equal 9, it instead is set to 0 to be increased to 1 and the X value of the vector is increased by 1
instead, functioning as a bar measure. This allows me to time the generation of all notes perfectly.
*/
  metronomeCounter++;
  if (metronomeCounter%15 == 0){
    if (metronome.y == 8){
      metronome.y = 0;
      metronome.x++;
    }
    metronome.y++;
  }
}

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

void NoteManager(){
/*
Description: NoteManager is called whenever a note is moved. It checks if there are any notes at or past the Y coordinate where they are considered missed.
If they are, the game sets the player's streak to 0 and reduces their health by 1;
*/
  for (int i = 0 ; i < activeNotes.size(); i++){
    if (activeNotes.get(i).getPosition().y >= noteLossLimit){
      activeNotes.remove(i);
      playerHealth--;
      streak = 0;
    }
  }
}

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

void NoteCheck(float lane){
/*
Description: NoteCheck is called whenever the player pressed any of the 6 game keys. When called, it takes in the lane corresponding with the pressed key and
checks if there is a note in the same lane within 50 pixels of the hit zone of said lane. If both are true, the player's score and streak are increased by 1,
the note is destroyed. The code then checks if the player's streak is equal to 10, if they are and their health's isn't maxed they gain 1 life back, in either
case the streak is reset.
*/
  for (int i = 0 ; i < activeNotes.size(); i++){
    if (activeNotes.get(i).getNoteInfo().z == lane && PVector.dist(activeNotes.get(i).getPosition(), lanes[int(lane)-1]) < 50){
      activeNotes.remove(i);
      score++;
      streak++;
      if (streak == 10){
        if (playerHealth != maxHealth)
          playerHealth++;
        streak = 0;
        
      }
    }
  }
}

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

void HealthManager(){
/*
Description: HealthManager is called every frame to display the heart icons that show how many lives the player still has from right to left. Whenever
its called it also checks if the player's health is equal to 0, transitioning the game to the Lose screen if so.
*/
  for (int i = 0 ; i < playerHealth ; i++){
     image (heartIcon, 350 - (35*i), 10);
  }
  if (playerHealth == 0)
    currentScreen = 5;
}

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

void MakeItRain(){
/*
Description: MakeItRain is what causes the rain effect in the background of the lose screen. It first checks if the rainTimer is on or not, assining a random number
to rainRandom equal to then number of frames before another raindrop is created. Once rainCounter reaches the same number as rainRandom, rainTimer is set back to false,
rainCounter is reset, and a raindrop is created. When creating raindrop, first a 50/50 is generated to see if its goint to be created a long the top of the screen or along the left
so they appear as if they are falling onto the screen and don't appear in the middle of the screen. Once this random value is established it created the raindrop. The 2nd part of the
function moves all existing raindrops, calling the .display function of all existing raindrops and then checking if any of their X or Y values are greater than 400 (indicating they are
offscreen), removing them if such.
*/
  if (!rainTimer){
    rainRandom = int(random(1,15));
    rainTimer = true;
  }
  rainCounter++;
  if (rainCounter == rainRandom){
    rainCounter = 0;
    rainTimer = false;
    int tempRandom = int(random(1, 3));
    if (tempRandom == 1){
      raindropPos = new PVector (random(0,401), -10);
    }
    else{
      raindropPos = new PVector (-10, random(0,401));
    }
    raindrops.add(new Raindrop(raindropPos));
  }
  
  for (int i = raindrops.size()-1 ; i>=0 ; i--){
    raindrops.get(i).display();
    if (raindrops.get(i).getPos().x > 400 || raindrops.get(i).getPos().y > 400)
      raindrops.remove(i);
  }
}

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

void keyPressed(){
/*
Description: base Processing function. What its currently doing is checking if the key the player hit is any of the game keys. If it is, it then checks if the key's boolean is negative, 
meaning that it isn't being called from the key being held down and instead from the key being pressed. If that's the case, it calls NoteCheck inputing the lane associated with the pressed
key into the function and flips that key's boolean to on.
*/
  switch(key){
    case 'a':
    case 'A':
      if (!keys['a'])
        NoteCheck(1);
      break;
    case 's':
    case 'S':
      if (!keys['s'])
        NoteCheck(2);
      break;
    case 'd':
    case 'D':
      if (!keys['d'])
        NoteCheck(3);
      break;
    case 'j':
    case 'J':
      if (!keys['j'])
        NoteCheck(4);
      break;
    case 'k':
    case 'K':
      if (!keys['k'])
        NoteCheck(5);
      break;
    case 'l':
    case 'L':
      if (!keys['l'])
        NoteCheck(6);
      break;
  }
  if (key < keys.length)
    keys[key] = true;
}

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

void keyReleased(){
/*
Description: Simply does the inverse of KeyPressed, when it realizes a key of released it flips its boolean to false indicating its not being held down.
*/
  if (key < keys.length)
    keys[key] = false;
}

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

void mouseClicked(){
/*
Description: Whenever the user clicks the mouse, the code checks which screen the game is currently in first, then checks where the mouse is. If the mouse
is over the coordinates of any of the game's buttons, it does what the button is supposed to do.
*/
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
