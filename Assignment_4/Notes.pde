class Notes{
  
  PImage noteImage;
  
  PVector noteInfo;
  PVector position = new PVector();
  
  float speed = 1.5;
  
  
  
  
  Notes(PVector noteInformation){
    
    noteInfo.x = noteInformation.x;
    noteInfo.y = noteInformation.y;
    
    switch(int(noteInformation.z)){
      case 1:
        noteImage = loadImage("Note 1.png");
        break;
      case 2:
        noteImage = loadImage("Note 2.png");
        break;
      case 3:
        noteImage = loadImage("Note 3.png");
        break;
      case 4:
        noteImage = loadImage("Note 4.png");
        break;
      case 5:
        noteImage = loadImage("Note 5.png");
        break;
      case 6:
        noteImage = loadImage("Note 6.png");
        break;
    }
  }
    
  void Display(){
    image (noteImage, noteInfo.x, noteInfo.y);
    noteInfo.y -= speed;
  }
}
