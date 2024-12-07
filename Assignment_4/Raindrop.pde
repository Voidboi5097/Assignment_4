/*
This class is only used for the rainfall in the lose screen. Creates all the raindrop objects.
*/

class Raindrop{
  
  PImage raindrop;                                              // image for the raindrop
  
  PVector pos;                                                  // Stores the position of the raindrop
  PVector speed;                                                // stores the speed of the object
  PVector accel;                                                // stores the rate at which the object accelerates across the screen
  
  Raindrop(PVector position){                                   // constructor only needs a PVector for where the raindrop should appear in
    
    pos = position.copy();
    speed = new PVector(1,1);
    accel = new PVector(0.1,0.1);
    raindrop = loadImage("Raindrop.png");
  }
  
  void display(){                                               // Displays the drop, moves it diagonally across the screen and increases the speed based on the acceleration
    image(raindrop, pos.x, pos.y);
    pos.add(speed);
    speed.add(accel);
  }
  
  PVector getPos(){                                             // returns the position of the raindrop
    return pos;
  }
  
}
