import java.io.*;
import java.nio.file.FileSystems;
import org.apache.poi.ss.usermodel.Sheet;
import java.util.Scanner;
import java.util.Arrays;

Cam camera; 
String dir_card_images = "./card_images/".replace("/", FileSystems.getDefault().getSeparator());
String dir_value_images = "./value_images/".replace("/", FileSystems.getDefault().getSeparator());
String dir_card_values = "carte.xlsx";
String[][] cards_stats;
PImage actual_card;
Option actual_optionA;
Option actual_optionB;
State[] states;
State[] rank;
String[] state_names = new String[]{"Player1", "Player2"};
boolean change_card=true;
boolean A_chosen=false;
boolean B_chosen=false;
boolean change_actual_value_gr=false;
boolean show_conseguences_gr=false;
boolean oracle=false;
boolean peek=false;
boolean show_ranking=false;
boolean[] yet_used;
PImage[] value_imgs = new PImage[4];
PImage dead_img = new PImage();
PImage oracle_img = new PImage();
PGraphics actual_value_gr;
PGraphics conseguences_gr;
PGraphics ranking;

int index=4;
int year=-1;
int turn=-1;

int animation_control=0;
int increase_control=0;
int rotation_control=0;
int wait_control=0;
int rotate_control_ranking=0;
int zoom_peek=0;

void setup() {
  fullScreen(P3D);    //<>//
  terrain_setup();   //<>//
  init_game(dir_card_values); //<>//
  camera = new Cam(0, 0); //<>//
  frameRate(60);
}

void draw() {
  this.clear();
  this.background(0, 0, 0, 0);
  //rotation if one option chosen
  zoomControlzoom_peeking();
  rotationControlRanking();
  rotationControl();
  camera.control(false);
  terrain_draw();
  //cambio la carta
  changeCard();
  textAlign(CENTER, CENTER);
  textSize(height/25);
  fill(0, 255, 0);
  stroke(0);
  text("Turno: "+states[turn].name+"\nAnni: "+states[turn].years, width/3, 0, width/3, height/8);
  showBoxes();
  showActualValueGr();
  image(actual_card, width/3, height/8, width/3, height*7/8);
  image(actual_optionB.img, width*2/3, height/4);
  image(actual_optionA.img, 0, height/4);  
  //animation if rotation finished
  increaseControl();
  showConseguencesGr();
  showRanking();
}

void changeCard() {
  if (change_card) {    
    println("ENTRATO CAMBIO CARTA");
    //reiniazializzo il resto per la prossima scelta
    A_chosen=false;
    B_chosen=false;
    change_card=false;
    show_conseguences_gr=false;
    if (year==state_names.length/10)
      free_table();
    //index++;
    do  index=(int)random(cards_stats.length)+1; 
    while (!yet_used[index-1] && index==53 && index==54 && index==16 && index==17);
    do {
      turn=(turn+1)%state_names.length;
      if (turn==0) {
        year++;
        for (int n=0; n<states.length; n++)
          states[n].increaseYear();
        println("STOP:", states[turn].stop);
        show_ranking=true;
        rotate_control_ranking=30; 
        updateRanking();
      }
    } while (states[turn].stop>0);

    yet_used[index-1]=true;
    actual_card = getCard(index);
    System.gc(); 
    actual_optionA.getOption(index-1, "sx", 255);
    actual_optionB.getOption(index-1, "dx", 255);
    camera.restore();
    change_actual_value_gr=true;
  }
}


void zoomControlzoom_peeking() {
  if (zoom_peek>0) {
    zoom_peek-=4;
    camera.actualZ+=(2*camera.sensZ);
  }
}

void spaceEvent() {
  if (A_chosen || B_chosen) {
    rotation_control=15;
  }
}

void disableA() {
  A_chosen=false;        
  actual_optionA.getOption(index-1, "sx", 255);
}

void disableB() {
  B_chosen=false;        
  actual_optionB.getOption(index-1, "dx", 255);
}

void enableB() {
  B_chosen=true; 
  actual_optionB.getOption(index-1, "dx", 0);
}

void enableA() {
  A_chosen=true; 
  actual_optionA.getOption(index-1, "sx", 0);
}

void keyPressed() {
  switch(Character.toLowerCase(key)) {
  case ' ':
    {
      if (show_ranking) {
        show_ranking=false;
        rotate_control_ranking=0;
        camera.restore();
      }
      spaceEvent();
      break;
    }
  case 'k':
    {
      if (!A_chosen && !show_ranking) {
        if (B_chosen) {
          B_chosen=false;
          actual_optionB.getOption(index-1, "dx", 255);
        }
        A_chosen=true; 
        actual_optionA.getOption(index-1, "sx", 0);
      } else {
        A_chosen=false;        
        actual_optionA.getOption(index-1, "sx", 255);
      }
      break;
    }
  case 'l':
    {
      if (!B_chosen && !show_ranking) {
        if (A_chosen) {
          A_chosen=false;
          actual_optionA.getOption(index-1, "sx", 255);
        }
        B_chosen=true; 
        actual_optionB.getOption(index-1, "dx", 0);
      } else {
        B_chosen=false;        
        actual_optionB.getOption(index-1, "dx", 255);
      }
      break;
    }
    //oracolo
  case 'o':
    {
      if (!oracle && (A_chosen || B_chosen)) {
        oracle=true;
        spaceEvent();
      } else {
        oracle=false;
      }
      break;
    }//sbirciata ai valori attuali
  case 'p':
    {
      if (zoom_peek==0 && !peek && !A_chosen && !B_chosen) {
        zoom_peek=400;
        peek=true;
      } else if (zoom_peek==0 && peek) {
        peek=false;
        camera.restore();
      }
      break;
    }
  case 'c':
    {
      if (!show_ranking) {
        show_ranking=true;
        rotate_control_ranking=30;
      } else {
        show_ranking=false;
        rotate_control_ranking=0; 
        camera.restore();
      }
      break;
    }
  case '1':
    {
      if (show_ranking) {
        states[Arrays.asList(state_names).indexOf(rank[0].name)].years++;
        show_ranking=false;
        updateRanking();
        show_ranking=true;
      }
      break;
    }
  case '2':
    {
     if (show_ranking) {
        states[Arrays.asList(state_names).indexOf(rank[1].name)].years++;
        show_ranking=false;
        updateRanking();
        show_ranking=true;
      }
      break;
    }
  case '3':
    {
      if (show_ranking) {
        states[Arrays.asList(state_names).indexOf(rank[2].name)].years++;
        show_ranking=false;
        updateRanking();
        show_ranking=true;
      }
      break;
    }
  case '4':
    {
      if (show_ranking) {
        states[Arrays.asList(state_names).indexOf(rank[3].name)].years++;
        show_ranking=false;
        updateRanking();
        show_ranking=true;
      }
      break;
    }
  case '5':
    {
      if (show_ranking) {
        states[Arrays.asList(state_names).indexOf(rank[4].name)].years++;
        show_ranking=false;
        updateRanking();
        show_ranking=true;
      }
      break;
    }
  
  case '0':
    {
      if (show_ranking) {
        states[Arrays.asList(state_names).indexOf(rank[0].name)].years--;
        show_ranking=false;
        updateRanking();
        show_ranking=true;
      }
      break;
    }
  case '9':
    {
     if (show_ranking) {
        states[Arrays.asList(state_names).indexOf(rank[1].name)].years--;
        show_ranking=false;
        updateRanking();
        show_ranking=true;
      }
      break;
    }
  case '8':
    {
      if (show_ranking) {
        states[Arrays.asList(state_names).indexOf(rank[2].name)].years--;
        show_ranking=false;
        updateRanking();
        show_ranking=true;
      }
      break;
    }
  case '7':
    {
      if (show_ranking) {
        states[Arrays.asList(state_names).indexOf(rank[3].name)].years--;
        show_ranking=false;
        updateRanking();
        show_ranking=true;
      }
      break;
    }
  case '6':
    {
      if (show_ranking) {
        states[Arrays.asList(state_names).indexOf(rank[4].name)].years--;
        show_ranking=false;
        updateRanking();
        show_ranking=true;
      }
      break;
    }
  }
}
