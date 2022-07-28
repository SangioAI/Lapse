int w;
int h;
float vet[][];
int scale=25;
float flying=0;
float delta=0.05;

void terrain_setup() {
  w=(width*2)/scale;
  h=height/scale;
  vet=new float[h][w];
  vet[0][0]=100;
}

void terrain_draw() {  
  flying-=delta;
    float yoff=flying;
    for (int y=0; y<h; y++) {
      float xoff=0;
      for (int x=0; x<w; x++) {
      vet[y][x]=map(noise(xoff, yoff), 0, 1, 0, 200);
      //vet[y][x]=map(random(-10,10),-10,10,0,50);
      xoff+=delta;
    }
    yoff+=delta;
  }
  noFill();  
 // translate(-130,height/2-100,-height/2+10);
  for(int n=0;n<2;n++){
    pushMatrix();
    int c=1;
    if(n==1){
      rotateZ(PI);
      c=-1;
      translate(-width-width/2,height/2-200,(-height/2+100-500));
    }else
      translate(-width/2,(height+200),(-height/2+100-500));
    rotateX(PI/2);
    for (int y=0; y<h-1; y++) {
      beginShape(TRIANGLE_STRIP);
      for (int x=0; x<w; x++) {
          stroke((int)map(vet[y][x], 0, 200, 0, 255),0,255-(int)map(vet[y][x], 0, 200, 0, 255));
        vertex(x*scale, y*scale, vet[y][x]);
          stroke((int)map(vet[y+1][x], 0, 200, 0, 255),0,255-(int)map(vet[y+1][x], 0, 200, 0, 255));
        vertex((x)*scale, (y+1)*scale, vet[y+1][x]);
        //rect(n*10,c*10,10,10);
      }
      endShape();
    }
    popMatrix();
  }
}
