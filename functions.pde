SXSSFWorkbook swb=null;
Sheet sh=null;
InputStream inp=null;
Workbook wb=null;

void init_game(String dir_card_values){
  String[][] saving = importExcel(dataPath("").replace("data",dir_card_values)); // get absolute path of file
  //init cards
  cards_stats= new String[saving.length-6][8];
  for(int r=6;r<saving.length;r++){
    for(int c=0;c<8;c++){
      cards_stats[r-6][c]=saving[r][c];
    }
  }
  //init yetused
  yet_used = new boolean[cards_stats.length];
  for(int n=0;n<yet_used.length;n++)
    yet_used[n]=false;
  //init state
  states = new State[state_names.length];
  rank=new State[states.length];
  for(int n=0;n<states.length;n++){
    states[n] = new State(state_names[n]);
  }
  //init option
  actual_optionA = new Option();
  actual_optionB = new Option();
  //init values
  value_imgs[0] = loadImage(dir_value_images+"a.png","png");
  value_imgs[1] = loadImage(dir_value_images+"p.png","png");
  value_imgs[2] = loadImage(dir_value_images+"fa.png","png");
  value_imgs[3] = loadImage(dir_value_images+"s.png","png"); 
  
  dead_img = loadImage(dir_value_images+"dead.png","png");
  oracle_img = loadImage(dir_value_images+"oracle.png","png"); 
  
  conseguences_gr = createGraphics(width-width/10,height-height/8);
  actual_value_gr = createGraphics(width,height);
  ranking = createGraphics(width,height);
}


void rotationControl(){
  if(rotation_control!=0){
    if(A_chosen){
      camera.orizontalRotation++;
      camera.actualX+=width/15;
    }else{
      camera.orizontalRotation--;
      camera.actualZ-=width/15;
    }
    if((--rotation_control)==0){
      increase_control=actual_optionA.copy.length;
      wait_control=1;
      show_conseguences_gr=true;
      states[turn].saveValues();
    }
  }
}


void showConseguencesGr(){
  if(show_conseguences_gr){
    pushMatrix();
    if(A_chosen){
      rotateY(-PI/2);
      translate(-width,0,0); 
    }else{
      rotateY(PI/2);
      translate(0,0,width); 
    }
    image(conseguences_gr,width/20,height/16);
    popMatrix();
  }
}


void increaseControl(){
  if(increase_control!=0 && (--wait_control)==0){
    if(A_chosen)
      states[turn].change_values(actual_optionA.copy[increase_control-1]);  
    else
      states[turn].change_values(actual_optionB.copy[increase_control-1]);     
    putValueGr(conseguences_gr,states[turn].values,states[turn].saved,states[turn].colors);
    if((--increase_control)==0)
      if(!oracle)change_card=true;
    else if(oracle){
      show_conseguences_gr=false;
      disableA();
      disableB();
      camera.restore();
      states[turn].restore();
      oracle=false;
    }
    wait_control=1;
  }
}

void showBoxes(){
  for (int n=1; n<=3; n+=2) {
    pushMatrix();
    stroke(255);
    translate(width/3*n-width/6, height/2, -width/2);
    noFill();
    if(A_chosen && n==1 || B_chosen && n==3)
      fill(0,255,0);
    box(width/3, height, width);
    popMatrix();
  } 
}


PImage getCard(int index){
  PImage img;
  img = loadImage(dir_card_images+""+index+".jpg");
  PGraphics g=createGraphics(img.width,img.height-img.height/5-(img.height*10)/(16*6));
  g.beginDraw();
  g.clear();
  g.background(0);
  g.image(img,0,-img.height/5);
  g.fill(255);
  g.noStroke();
  g.endDraw();
  //resize,they must have same size
  img.resize(g.width,g.height);
  img.pixels = g.pixels;
  //mask
  PGraphics mask=createGraphics(img.width,img.height);
  mask.beginDraw();
  mask.clear();
  mask.background(0);
  mask.fill(255);
  mask.noStroke();
  mask.smooth();
  mask.rect(0,0,mask.width,mask.height,50);
  mask.endDraw();
  img.mask(mask);
  return img;
}

void updateRanking(){
  int max=-1;
  for(int n=0;n<rank.length;n++){
    rank[n]=states[n];
  }
  for(int i=0;i<rank.length;i++){
    for(int n=0;n<rank.length-1-i;n++){
      if(rank[n].years<rank[n+1].years){
        State t = rank[n];
        rank[n]= rank[n+1];
        rank[n+1]=t;
      }
    }
  }
  //ranking.clear();
  ranking.beginDraw();
  ranking.clear();
  ranking.background(0);
  ranking.textSize(height/20);
  ranking.textAlign(CENTER,CENTER);
  ranking.stroke(255);
  ranking.fill(255);
  ranking.text("CLASSIFICA\nanni passati: "+year,0,0,ranking.width,ranking.height/(rank.length+1));
  //ranking.stroke(255,0,0);
  //ranking.fill(255,0,0);
  //ranking.text("1° "+rank[0].name+ "\nanni:"+rank[0].years,0,height*2/12,ranking.width,ranking.height/6);
  //ranking.stroke(169);
  //ranking.noFill();
  //ranking.rect(0,height*2/12,ranking.width,ranking.height/6);
  //ranking.stroke(0);
  //ranking.noFill();
  //ranking.rect(0,0,ranking.width,ranking.height/6);
  //ranking.stroke(204,0,0);
  //ranking.fill(204,0,0);
  //ranking.text("2° "+rank[1].name+ "\nanni:"+rank[1].years,0,height*4/12,ranking.width,ranking.height/6);
  //ranking.stroke(169);
  //ranking.noFill();
  //ranking.rect(0,height*4/12,ranking.width,ranking.height/6);
  //ranking.stroke(153,0,0);
  //ranking.fill(153,0,0);
  //ranking.text("3° "+rank[2].name+ "\nanni:"+rank[2].years,0,height*6/12,ranking.width,ranking.height/6);
  //ranking.stroke(169);
  //ranking.noFill();
  //ranking.rect(0,height*6/12,ranking.width,ranking.height/6);
  //ranking.stroke(102,0,0);
  //ranking.fill(102,0,0);
  //ranking.text("4° "+rank[3].name+ "\nanni:"+rank[3].years,0,height*8/12,ranking.width,ranking.height/6);
  //ranking.stroke(169);
  //ranking.noFill();
  //ranking.rect(0,height*8/12,ranking.width,ranking.height/6);
  //ranking.stroke(51,0,0);
  //ranking.fill(51,0,0);
  //ranking.text("5° "+rank[4].name+ "\nanni:"+rank[4].years,0,height*10/12,ranking.width,ranking.height/6);
  //ranking.stroke(169);
  //ranking.noFill();
  //ranking.rect(0,height*10/12,ranking.width,ranking.height/6);
  
 for(int n=0;n<rank.length;n++){
    ranking.stroke(255-250/rank.length*n,0,0);
    ranking.fill(255-1-250/rank.length*n,0,0);
    ranking.text((n+1)+"° "+rank[n].name+ "\nanni:"+rank[n].years,0,ranking.height/(rank.length+1)*(n+1),ranking.width,ranking.height/(rank.length+1));
    ranking.stroke(169);
    ranking.noFill(); 
    ranking.rect(0,ranking.height/(rank.length+1)*(n+1),ranking.width,ranking.height/(rank.length+1));
    
    if(rank[n].stopped)
      ranking.image(dead_img, ranking.width/4 - max(ranking.height/(rank.length+1)/2, 50) , ranking.height/(rank.length+1)*(n+1)+ranking.height/(rank.length+1)/2-max(ranking.height/(rank.length+1)/2, 50)/2,max(ranking.height/(rank.length+1)/2, 50),max(ranking.height/(rank.length+1)/2, 50));
  }
  ranking.stroke(255,0,0);
  ranking.noFill();
  ranking.rect(0,0,ranking.width,ranking.height/(rank.length+1));
  ranking.endDraw();
}

void rotationControlRanking(){
  if(rotate_control_ranking!=0){
    camera.orizontalRotation++;
    camera.actualX+=width/30;
    camera.actualZ-=width/30;
    rotate_control_ranking--;
  }
}


void showActualValueGr(){
  if(change_actual_value_gr){
    states[turn].saveValues();
    putValueGr(actual_value_gr,states[turn].saved,states[turn].saved,new color[]{#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF});
    change_actual_value_gr=false;
  }
  pushMatrix();
  translate(0,0,-width/2);
  image(actual_value_gr,width/3,height/4,width/3,height/2);
  popMatrix();
}

void putValueGr(PGraphics value_gr,int v[],int before_v[],color colors[]) {
  //value_gr.clear();
  value_gr.beginDraw();
  value_gr.clear();
  value_gr.background(0, 0, 0, 0);
  value_gr.noStroke();
  for (int n=0; n<v.length; n++) {
    value_gr.translate(value_gr.width/25, 0);
    value_gr.fill(169, 169, 169);
    value_gr.rect(0, 0, value_gr.width/5, value_gr.height);
    value_gr.fill(colors[n]);
    value_gr.rect(0, value_gr.height*(100-v[n])/100, value_gr.width/5, value_gr.height*v[n]/100);
    value_gr.noFill();
    value_gr.stroke(0);
    value_gr.rect(0, value_gr.height*(100-before_v[n])/100, value_gr.width/5, value_gr.height*before_v[n]/100);
    value_gr.image(value_imgs[n], 0, 0, value_gr.width/5, value_gr.height);
    value_gr.translate(value_gr.width/5, 0);
  }
  println("done values");
  value_gr.endDraw();
}


void showRanking(){
  if(show_ranking){
    pushMatrix();
    translate(0,0,-width-1);
    rotateY(PI);
    translate(-width,0,0);
    image(ranking,0,0);
    popMatrix();
  }
}

void free_table(){
  for(int n=0;n<yet_used.length;n++){
    yet_used[n]=false;
  }
}

String[][] importExcel(String filepath) {
  String[][] temp;
  try {
    inp = new FileInputStream(filepath);
  }
  catch(Exception e) {
    print("error in FileInputStrem\n");
  }
  try {
    wb = WorkbookFactory.create(inp);
  }
  catch(Exception e) {
    print("error in WorkbookFactory\n");
  }
  if(wb == null) 
    print(filepath, "\n");
  if(inp == null)
    print(filepath, "\n");
  Sheet sheet = wb.getSheetAt(0);
  int sizeX = sheet.getLastRowNum();
  int sizeY = 100;
  for (int i=0;i<sizeX;++i) {
    Row row = sheet.getRow(i);
    for (int j=0;j<sizeY;++j) {
      try {
        Cell cell = row.getCell(j);
      }
      catch(Exception e) {
        if (j>sizeY) {
          sizeY = j;
        }
      }
    }
  }
  temp = new String[sizeX][sizeY];
  for (int i=0;i<sizeX;++i) {
    for (int j=0;j<sizeY;++j) {
      Row row = sheet.getRow(i);
      try {
        Cell cell = row.getCell(j);
        if (cell.getCellType()==0 || cell.getCellType()==2 || cell.getCellType()==3)cell.setCellType(1);
        temp[i][j] = cell.getStringCellValue();
      }
      catch(Exception e) {
      }
    }
  }
  println("Excel file imported: " + filepath + " successfully!");
  return temp;
}

void exportExcel(String[][] data, String filepath) {
  SXSSFWorkbook wwb = new SXSSFWorkbook(100);
  Sheet sh = wwb.createSheet();
  int sizeX = data.length;
  int sizeY = data[0].length;
  for (int i=0;i<sizeX;++i) {
    Row row = sh.createRow(i);
    for (int j=0;j<sizeY;++j) {
      Cell cell = row.createCell(j);
      if (cell.getCellType()==0 || cell.getCellType()==2 || cell.getCellType()==3)cell.setCellType(1);
      cell.setCellValue(data[i][j]);
    }
  }
  try {
    FileOutputStream out = new FileOutputStream(filepath);
    wwb.write(out);
    println("Excel file exported: " + filepath + " sucessfully!");
  }
  catch (Exception e) {
    println("Error in saving the file...sorry!");
  }
}
