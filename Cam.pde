class Cam{
  //sensibility
  final float sensZ=5,sensRotation=PI/30;
  //dragging variable
  boolean isDragging=false;
  int posMousePressedX,posMousePressedY;
  int deltaX,deltaY;
  //rotation variable
  boolean leftRotation=false,upRotation=false,rightRotation=false,downRotation=false;
  boolean rightFrontRotation=false,leftFrontRotation=false;
  //actual variable of graphics sketch
  int actualX=0,actualY=0,actualZ=0;
  int verticalRotation=0,orizontalRotation=0,frontalRotation=0;
  //initial variable
  int initX,initY;
  
  public Cam(int initX,int initY){
    this.initX = initX;
    this.initY = initY;
    actualX=initX;
    actualY=initY;
  }
  
  
  void control(boolean drawAxis){
    
    //change prespective
    if(isDragging)
      translate(deltaX,deltaY);
    translate(actualX,actualY,actualZ);
    //change rotation
    if(upRotation)
      verticalRotation++;
    if(downRotation)
      verticalRotation--;
    if(rightRotation)
      orizontalRotation++;
    if(leftRotation)
      orizontalRotation--;
    if(rightFrontRotation)
      frontalRotation--;
    if(leftFrontRotation)
      frontalRotation++;
      
    rotateX(verticalRotation*sensRotation);
    rotateY(orizontalRotation*sensRotation);
    rotateZ(frontalRotation*sensRotation);
    
    if(drawAxis){
      stroke(0,0,255);
      fill(0,0,255);
      line(0,0,300,0);
      text("X",301,0);
      stroke(255,0,0);
      line(0,0,0,-300);
      fill(255,0,0);
      text("Y",0,-301);
    }
    //println("w:",actualX,"h:",actualY,"z:",frontalRotation*sensRotation);
    //635
    //println("actualz:",actualZ,"width:",width,"height:",height);
  }
  void restore(){
    actualX = initX;
    actualY = initY;
    actualZ=0;
    verticalRotation=0;
    orizontalRotation=0;
    frontalRotation=0;
    
  }
  void mousePressed(){
    println("Pressed on");
    posMousePressedX=mouseX;
    posMousePressedY=mouseY;
  }
  
  void mouseReleased(){
    if(isDragging){
      actualX+=deltaX;
      actualY+=deltaY;  
    }  
    isDragging=false;
    println("Released");
  }
  
  void mouseDragged(){
    isDragging=true;
    deltaX=mouseX-posMousePressedX;
    deltaY=mouseY-posMousePressedY; 
  }
  int gg=0;
  void mouseWheel(MouseEvent event) {
    if(event.getCount()!=0){
      actualZ-=(event.getCount()*sensZ);
      println(++gg);
    }
  }
  
  void keyPressed() {
    switch(Character.toLowerCase(key)){
       case 'w':{
         upRotation=true; 
         break;
       }
       case 'a':{
         leftRotation=true; 
         break;
       }
       case 's':{
         downRotation=true; 
         break;
       }
       case 'd':{
         rightRotation=true; 
         break;
       }
        case 'z':{
         rightFrontRotation=true;
         break;
       }
        case 'x':{
         leftFrontRotation=true;       
         break;
       }
        case 'r':{
         restore();    
         break;
       }
    }
  }
  
  void keyReleased() {
    switch(key){
       case 'w':{
         upRotation=false; 
         break;
       }
       case 'a':{
         leftRotation=false; 
         break;
       }
       case 's':{
         downRotation=false; 
         break;
       }
       case 'd':{
         rightRotation=false; 
         break;
       }
        case 'z':{
         rightFrontRotation=false;
         break;
       }
        case 'x':{
         leftFrontRotation=false;       
         break;
       }
    }
  }
}
