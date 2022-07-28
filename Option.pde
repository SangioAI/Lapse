class Option{
  PGraphics img;
  int values[]=new int[4];
  int copy[][]=new int[20][4];
  int index=-1;
  
  void getOption(int index,String where,int colore){
    img=createGraphics(width/3,height/2,P3D);
    img.beginDraw();
    img.background(0,0,0,0);
    img.textSize(height/15);
    img.stroke(colore);
    img.fill(colore);
    img.textAlign(CENTER,CENTER);
    if(where.equalsIgnoreCase("sx")){
      if(index!=this.index)getValues(cards_stats[index][6],cards_stats[index][7]);
      img.text(java.lang.Character.toUpperCase(cards_stats[index][3].charAt(0))+cards_stats[index][3].substring(1).toLowerCase(),0,0,img.width,img.height);
    }
    else{
      if(index!=this.index)getValues(cards_stats[index][1],cards_stats[index][2]);    
      img.text(java.lang.Character.toUpperCase(cards_stats[index][4].charAt(0))+cards_stats[index][4].substring(1).toLowerCase(),0,0,img.width,img.height); 
    }
    img.endDraw();
    this.index=index;
  }
  
  //ORDINE Ambiente(a),Popolazione(p),Forza Militare(fa),Soldi(s)
  void getValues(String s1,String s2){
    values = new int[]{0,0,0,0};
    String[] v;
    if(s1!=null){
      v=s1.split(",");
      for(int n=0;n<v.length;n++){
        int c=1;
        if(v[n].startsWith("!"))
          c=-1;
        if(v[n].endsWith("fa"))
          values[2]+=10*c;
        else if(v[n].endsWith("a"))
          values[0]+=10*c;
        if(v[n].endsWith("s"))
          values[3]+=10*c;
        if(v[n].endsWith("p"))
          values[1]+=10*c;
      }
    }
    
    if(s2!=null){
      v=s2.split(",");
      for(int n=0;n<v.length;n++){
        int c=1;
        if(v[n].startsWith("!"))
          c=-1;
        if(v[n].endsWith("fa"))
          values[2]+=20*c;
        else if(v[n].endsWith("a"))
          values[0]+=20*c;
        if(v[n].endsWith("s"))
          values[3]+=20*c;
        if(v[n].endsWith("p"))
          values[1]+=20*c;
      }
    }
    println("\n",values[0],values[1],values[2],values[3]);
    for(int n=0;n<4;n++){
      int r=values[n]/(20/copy.length);
      println();
      for(int i=0;i<copy.length;i++){
        if(r>0){
          copy[i][n]=+(20/copy.length);
          r--;
        }else if(r<0){
          copy[i][n]=-(20/copy.length);
          r++;
        }else
          copy[i][n]=0;
        print(copy[i][n]," ");
      }
    }
    
    println("ENTRATO OPTION");
  }
}
