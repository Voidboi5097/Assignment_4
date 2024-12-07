/*
Description: Class that manages the note objects. Constructor uses the PVectors created by the beatmap table.
*/

class Notes{
  
  PImage noteImage;                                                          // PImage for the note
  
  PVector noteInfo = new PVector();                                          // PVector that holds the information assigned to the Note upon Construction
  PVector position;                                                          // PVector that holds the current position of the Note
  
  float speed = 3;                                                           // Speed at which the note descends the lane highway. Currently takes 2 seconds to reach the hit zone.
  
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
  
  Notes(PVector noteInformation){
    
    noteInfo = noteInformation.copy();
    
    switch(int(noteInfo.z)){                                                  // This switch case assigns a different image to the noteImage PVector depending on what lane the note is to be created in,
      case 1:                                                                 // also giving it a position value that corresponds with that lane. Lanes are 1-6 from left to right.
        noteImage = loadImage("Note 1.png");
        position = new PVector(38,-10);
        break;
      case 2:
        noteImage = loadImage("Note 2.png");
        position = new PVector(98,-10);
        break;
      case 3:
        noteImage = loadImage("Note 3.png");
        position = new PVector(158,-10);
        break;
      case 4:
        noteImage = loadImage("Note 4.png");
        position = new PVector(218,-10);
        break;
      case 5:
        noteImage = loadImage("Note 5.png");
        position = new PVector(278,-10);
        break;
      case 6:
        noteImage = loadImage("Note 6.png");
        position = new PVector(338,-10);
        break;
    }
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

  void Display(){                                                                                // Function that generates the image for the note and moves it down the note highway
    image (noteImage, position.x, position.y);
    position.y += speed;
  }
  
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

  PVector getNoteInfo(){                                                                         // returns noteInfo PVector to check values such as time signature and note type
    return noteInfo;
  }
  
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
  
  PVector getPosition(){                                                                         // returns position PVector to check where the note is.
    return position;
  }
}
