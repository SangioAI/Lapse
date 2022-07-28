class State{
  String name;
  int years;
  
  int values[]=new int[]{50,50,50,50};
  int saved[]= new int[4];
  color colors[]=new color[]{#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF};
  int stop=0;//anni per cui deve stare fermo
  final int num_stop=2;
  boolean stopped=false;
  
  public State(String name){
    this.name = name;
  }

  void change_values(int v[]){
    for(int n=0;n<4;n++){
      if(v[n]<0)colors[n]=color(255,0,0);
      else if(v[n]>0)colors[n]=color(0,255,0);
      else colors[n]=color(255);
      values[n]+=v[n];
      if(values[n]<=0){
        values[n]=0;
        stop=num_stop;
        stopped=true;
        println(name,"scoppiato");
      }
    }
    println("stato:",name,"valori:",values[0],values[1],values[2],values[3]);
  }
  
  void increaseYear(){
    if(year>0){
      if((stop)>0){
         stop--;
         if(stop==0)
           values=new int[]{50,50,50,50};
       }else{
         years++;
       }
    }
  }
  
  
  void restore(){
   for(int n=0;n<4;n++){
       values[n]=saved[n];
    }
  }
  
  void saveValues(){
     for(int n=0;n<4;n++){
       saved[n]=values[n];
     }
  }
}
