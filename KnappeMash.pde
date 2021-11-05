import cc.arduino.*;
import org.firmata.*;

import processing.serial.*;


Arduino arduino;


PImage GWbilde;

int state = 0;

int knapp1 = 23;
int knapp2 = 24;
int knapp3 = 22;
int startKnapp = 25;
int last;

int startKnappVerdi;
int knapp1Verdi;
int knapp2Verdi;
int knapp3Verdi;

long teller = 0;
long igjen = 0;

int highScore = 0;
int textScore = 0;
int sistTrykk;
int feilTrykkAntall=0;

int feilTrykk=0;

int score = 0;

void setup() {

  size(1280, 720);
  
  println(Arduino.list());
  arduino = new Arduino(this, "COM5", 57600); // Husk å endre til riktig com port // Riktig Baud-rate
  
  arduino.pinMode(knapp1, Arduino.INPUT);
  arduino.pinMode(knapp2, Arduino.INPUT);
  arduino.pinMode(knapp3, Arduino.INPUT);
  arduino.pinMode(startKnapp, Arduino.INPUT);



  GWbilde = loadImage("GuidedWolf.jpg");
  
}




void draw() {
  image(GWbilde,0,0); 
  textSize(30);
 
// text(knapp3,50,50);
 
  if (state==0)
  {
   fill(30,30,30);
 
   text("Sist poengsum:",500,600);
   text("Highscore: ",500,700);
   text(score,1000,600);
   text(highScore,1000,700);
   textSize(70);
   text("Trykk på startknapp",300,400);
   textSize(30);
      text("FeilTrykk:",500,650);
   text(feilTrykkAntall,1000,650);

     
  String[] lines = loadStrings("highScore.txt");
  println("there are " + lines.length + " lines");
  for (int i = 0 ; i < lines.length; i++) {
    println(lines[i]);
  }
  textScore = Integer.parseInt(lines[0]);
  
  if(highScore>textScore)
    {
      String highScoreTXT = str(highScore);
      String[] list = split(highScoreTXT, ' ');
      saveStrings("highScore.txt",list);
      text(highScoreTXT,700,200);
    }
  else
    {
    highScore=textScore;
    }
   
   startKnappVerdi = arduino.digitalRead(startKnapp);
   if(startKnappVerdi==1)
   {
     //----------------SETTING UP NEW GAME!!!!!------------------
     state=1;
     teller=millis();
     last=2;
     score=0;
     feilTrykk = 0;
     feilTrykkAntall=0;
   }
  }
  else if(state==1){
    if(teller+10000>millis())
    {
      igjen = (teller+10000-millis());
      knapp1Verdi = arduino.digitalRead(knapp1);
      knapp2Verdi = arduino.digitalRead(knapp2);
      knapp3Verdi = arduino.digitalRead(knapp3);
         if (last==1)
         {    
         circle(525,400,50);
         fill(0,255,0);
         circle(650,500,60);
         fill(30,30,30);
         circle(775,400,50);
         }
        else if(last==2)
         {
         circle(525,400,50);
         circle(650,500,50);
         fill(0,255,0);
         circle(775,400,60);
         fill(30,30,30);
         }
         else
         {
         fill(0,255,0);
         circle(525,400,60);
         fill(30,30,30);
         circle(650,500,50);
         circle(775,400,50);
         }
         
       text("TID IGJEN",570,300);
       text((float)igjen/1000,600,400);
       
       if(knapp1Verdi==1 && knapp2Verdi==0 && knapp3Verdi ==0 && last==3)
       {
         score++;
         last=1; 
         sistTrykk=millis();
       }
       else if(knapp1Verdi==0 && knapp2Verdi==1 && knapp3Verdi ==0 && last==1){
         score++;
         last=2;
         sistTrykk=millis();
       }
       else if(knapp1Verdi==0 && knapp2Verdi==0 && knapp3Verdi ==1 && last ==2){
        score++;
        last=3;
        sistTrykk=millis();
       }
       //-------Sjekker om noen trykket feil------
       else if(sistTrykk+100<millis()){
         if (knapp1Verdi==1){
           feilTrykk++;
           sistTrykk=millis();
                 fill(255,0,0);
         circle(525,400,90);
         fill(30,30,30);
         }
         else if (knapp2Verdi==1){
           feilTrykk++;
           sistTrykk=millis();
                 fill(255,0,0);
         circle(650,500,90);
         fill(30,30,30);
         }
         else if(knapp3Verdi==1){
           feilTrykk++;
           sistTrykk=millis();
           
         fill(255,0,0);
         circle(775,400,90);
         fill(30,30,30);
   
         }
         
           text("OI",30,30);
           if(score>0){
           score--;
           feilTrykk=1;
           feilTrykkAntall++;

         
       }}
     
       if(score>highScore)
       {
        highScore=score;
       }
    text(score,1000,600);
    text(highScore,1000,700);
    
   text("Poengsum:",500,600);
   text("Highscore:",500,700);
   text("FeilTrykk:",500,650);
   text(feilTrykkAntall,1000,650);
    
    }
    else
    {
      state=0;
    }
  }
}
