class Notes{
  
  PImage noteImage;
  
  PVector noteInfo = new PVector();
  PVector position;
  
  float speed = 2.5;
  
  
  
  
  Notes(PVector noteInformation){
    
    noteInfo.x = noteInformation.x;
    noteInfo.y = noteInformation.y;
    
    switch(int(noteInformation.z)){
      case 1:
        noteImage = loadImage("Note 1.png");
        position = new PVector(38,0);
        break;
      case 2:
        noteImage = loadImage("Note 2.png");
        position = new PVector(98,0);
        break;
      case 3:
        noteImage = loadImage("Note 3.png");
        position = new PVector(158,0);
        break;
      case 4:
        noteImage = loadImage("Note 4.png");
        position = new PVector(218,0);
        break;
      case 5:
        noteImage = loadImage("Note 5.png");
        position = new PVector(278,0);
        break;
      case 6:
        noteImage = loadImage("Note 6.png");
        position = new PVector(338,0);
        break;
    }
  }

/*-----------------------------------------------------------------------------------------------*/

  void Display(){
    image (noteImage, position.x, position.y);
    position.y += speed;
  }
  
/*-----------------------------------------------------------------------------------------------*/

  PVector getNoteInfo(){
    return noteInfo;
  }
}
