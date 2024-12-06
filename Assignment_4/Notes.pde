class Notes{
  
  PImage noteImage;
  
  PVector noteInfo = new PVector();
  PVector position;
  
  float speed = 3;
  
  
  
  
  Notes(PVector noteInformation){
    
    noteInfo = noteInformation.copy();
    
    switch(int(noteInfo.z)){
      case 1:
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

/*-----------------------------------------------------------------------------------------------*/

  void Display(){
    image (noteImage, position.x, position.y);
    position.y += speed;
  }
  
/*-----------------------------------------------------------------------------------------------*/

  PVector getNoteInfo(){
    return noteInfo;
  }
  
/*-----------------------------------------------------------------------------------------------*/
  
  PVector getPosition(){
    return position;
  }
}
