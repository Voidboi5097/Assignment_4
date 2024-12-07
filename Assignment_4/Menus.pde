/*
Menus is the class that manages what should be appearing on screen depending on what screen the player is on. It creates these displays using a series of images I created.
Since all it does is display the menus, the only thing it does is display images and check if the mouse is over the buttons of each screen to highlight them.
*/

class Menus{
 
  PImage gameName;
  
  PImage laneHighway;
  
  PImage youRock;
  
  PImage score;
  
  PImage reallyRock;
  
  PImage perfect;
  
  PImage fail;
  
  PImage start;
  PImage startHighlight;
  
  PImage quit;
  PImage quitHighlight;
  
  PImage retry;
  PImage retryHighlight;
  
  PImage aButton;
  PImage aButtonPressed;
  
  PImage sButton;
  PImage sButtonPressed;
  
  PImage dButton;
  PImage dButtonPressed;
  
  PImage jButton;
  PImage jButtonPressed;
  
  PImage kButton;
  PImage kButtonPressed;
  
  PImage lButton;
  PImage lButtonPressed;
  
  PImage raindrop;
  
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
  
  Menus(){                                                                  // Constructor assigns image files to each PImage variable
    gameName = loadImage("Game Name.png");
    
    start = loadImage("Start.png");
    startHighlight = loadImage("StartHighlight.png");
    
    quit = loadImage("Quit.png");
    quitHighlight = loadImage("QuitHighlight.png");
    
    aButton = loadImage("A Button.png");
    aButtonPressed = loadImage("A Button Pressed.png");
    
    sButton = loadImage("S Button.png");
    sButtonPressed = loadImage("S Button Pressed.png");
    
    dButton = loadImage("D Button.png");
    dButtonPressed = loadImage("D Button Pressed.png");
    
    jButton = loadImage("J Button.png");
    jButtonPressed = loadImage("J Button Pressed.png");
    
    kButton = loadImage("K Button.png");
    kButtonPressed = loadImage("K Button Pressed.png");
    
    lButton = loadImage("L Button.png");
    lButtonPressed = loadImage("L Button Pressed.png");
    
    laneHighway = loadImage("LaneHighway.png");
    
    youRock = loadImage("You Rock.png");
    
    score = loadImage("Score.png");
    
    perfect = loadImage("Perfect.png");
    
    reallyRock = loadImage("Really Rock.png");
    
    retry = loadImage("Retry.png");
    retryHighlight = loadImage("Retry Highlight.png");
    
    fail = loadImage("Failed.png");
    
    raindrop = loadImage("Raindrop.png");
  }
  
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
  
  void mainMenu(){                                                                                // Main Menu screen, includes 2 buttons
    image(gameName, 63,25);
    
    
    
    if (mouseX >= 140 && mouseX <= 260 && mouseY >= 225 && mouseY <= 274)
      image(startHighlight,140,225);
    else
      image(start,140,225);
    
    if (mouseX >= 140 && mouseX <= 260 && mouseY >= 300 && mouseY <= 349)
      image(quitHighlight,140,300);
    else
      image(quit,140,300);
      
  }
  
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
  
  void laneHighway(boolean a, boolean s, boolean d, boolean j, boolean k, boolean l){              // main Game screen, takes in 6 different booleans in order to highlight a key if the player is holding it down
    
    image (laneHighway, 0, 50);
    
    if (a)
      image (aButtonPressed, 25,325);
    else
      image (aButton, 25,325);
    
    if (s)
      image (sButtonPressed, 85, 325);
    else
      image (sButton, 85, 325);
    
    if (d)
      image (dButtonPressed, 145, 325);
    else
      image (dButton, 145, 325);
    
    if (j)
      image (jButtonPressed, 205, 325);
    else
      image (jButton, 205, 325);
    
    if (k)
      image (kButtonPressed, 265, 325);
    else
      image (kButton, 265, 325);
    
    if (l)
      image (lButtonPressed, 325, 325);
    else
      image (lButton, 325, 325);
  }
  
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

  void winScreen(int points, int maxScore){                                                      // Default win screen. Takes in 2 values to show the player's score/how many notes there are.
    image (youRock, 32,50);
    
    image (score, 125,172);
    
    fill (255);
    textSize(30);
    text(points + "/"+ maxScore, 200,200);
    
    if (mouseX >= 140 && mouseX <= 260 && mouseY >= 225 && mouseY <= 285)
      image(retryHighlight,140,225);
    else
      image(retry,140,225);
    
    
    if (mouseX >= 140 && mouseX <= 260 && mouseY >= 300 && mouseY <= 349)
      image(quitHighlight,140,300);
    else
      image(quit,140,300);
    
  }
  
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

  void perfectScreen(){                                                                          // perfect win screen. doesn't display score since the player hit every note.
    image (perfect, 1, 25);
    
    image (reallyRock, 45, 140);
    
    
    if (mouseX >= 140 && mouseX <= 260 && mouseY >= 225 && mouseY <= 285)
      image(retryHighlight,140,225);
    else
      image(retry,140,225);
    
    
    if (mouseX >= 140 && mouseX <= 260 && mouseY >= 300 && mouseY <= 349)
      image(quitHighlight,140,300);
    else
      image(quit,140,300);
  }
  
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

  void failScreen(){                                                                              //Game over screen.
    
    image(fail, 30, 25);
    
    if (mouseX >= 140 && mouseX <= 260 && mouseY >= 225 && mouseY <= 285)
      image(retryHighlight,140,225);
    else
      image(retry,140,225);
    
    
    if (mouseX >= 140 && mouseX <= 260 && mouseY >= 300 && mouseY <= 349)
      image(quitHighlight,140,300);
    else
      image(quit,140,300);
  }
}
