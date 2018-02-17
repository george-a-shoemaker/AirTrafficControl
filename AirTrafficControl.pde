/* ATC aka Air Traffic Control
 * George Shoemaker
 * Intro to Electronic Music Spring 2018
 *
 * Interactive program that generates MIDI events
 * to emulate Track 2 of Music For Airports by Brian Eno.
 *
 * https://teropa.info/loop/#/airports
 */

import themidibus.*;
import g4p_controls.*;

//TODO: On/Off switch
//TODO: User input to change the duration and period of loop, 2d slider

/*
i  Note  MIDI
 0  F2    29
 1  G#2   32
 2  C3    36
 3  C#3   37
 4  D#3   39
 5  F3    41
 6  G#3   44
 */

MidiBus myBus; // The MidiBus
int x;
int y;
int frame;
int fps;

LoopingTone[] loops; 

//GSlider sdrPeriod;
//GSlider sdrRatio;
GSlider2D ltControl;
GOption on;
GOption off;

int swidth;
int sheight;

boolean isPlaying;

void setup() {
  fps = 30;
  frameRate(fps);
  size(800, 600);
  background(0);
  textFont(loadFont("Avenir-HeavyOblique-48.vlw"), 22);
  isPlaying = false;
 
   
  String busName = "MidiBusATC"; //THIS IS THE NAME OF THE BUS FOR ATC
         //busName = "SimpleSynth virtual input";

  println("This Processing program outputs MIDI events thru a port.\n"+
    "To hear sound, a separate application\n"+
    "is required to receive and interpret the MIDI events."+
    "This program expects to use a port named \""+busName+"\".\n"+
    "If \""+busName+"\" is not available in the list below,\n" +
    "either configure a port with that name,\n"+
    "or set the \"busName\" variable to the name of a configured port.");
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

  myBus = new MidiBus(this, -1, busName);
  
  /*
i  Note  MIDI
 0  F2    29
 1  G#2   32
 2  C3    36
 3  C#3   37
 4  D#3   39
 5  F3    41
 6  G#3   44
 */
  //LoopingTone(String name, int channel, int pitch, int x, int y)//
  
  swidth = 800;
  sheight = 600;
  
  loops = new LoopingTone[7];
  
  int y0 = 265;
  int y1 = 475;
  loops[0] = new LoopingTone("F2 ", 0, 29, 100, y0);
  loops[1] = new LoopingTone("G#2", 0, 32, 200, y1);
  loops[2] = new LoopingTone("C3 ", 0, 36, 300, y0);
  loops[3] = new LoopingTone("C#3", 0, 37, 400, y1);
  loops[4] = new LoopingTone("D#3", 0, 39, 500, y0);
  loops[5] = new LoopingTone("F3 ", 0, 41, 600, y1);
  loops[6] = new LoopingTone("G#3", 0, 44, 700, y0);
  
  on  = new GOption(this, 300, 100, 80, 24, "ON");
  off = new GOption(this, 300, 120, 80, 24, "OFF");
  
  
  //changePalette(8,{255,0,0});
  //G4P.setCursor(CROSS);
  //sdrPeriod = new GSlider(this, 500, 3, 200, 100, 15);
  //Ratio  = new GSlider(this, 500, 59, 200, 100, 15);
  //sdrPeriod.setLocalColorScheme(G4P.RED_SCHEME);
  
  
  ltControl = new GSlider2D(this, 600, 15, 180, 140);
  ltControl.setLimitsX(180, 60, 480);
  ltControl.setLimitsY(150, 60, 280);
  ltControl.setEasing(8);
  ltControl.setNumberFormat(G4P.DECIMAL, 1);
  //ltControl.drawValue();

}

void draw() {
  //println(++frame);
  background(0);

  int channel = 1;
  int pitch = 29;
  int velocity = 100;

  
  stroke(255, 0, 0);
  fill(255, 0, 0);
  
  textSize(30);
  text("AirTrafficControl", 60, 80);
  textSize(18);
  //text("Period",450,20);
  //text("%", 413,115);
  
  noFill();
  //rect(380,10,410,140);
  
  textSize(18);
  
  //loops[0].update();
  //loops[0].draw();
  
  for(int i = 0; i < 7; i++){
    loops[i].update();
    loops[i].draw();
  } 

 

  //MIDI TEST
  /*
  delay(1200);
   myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
   println("ON");
   delay(1000);
   myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi noteOff
   println("OFF");
   */
   
  
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}




//UNTESTED
class LoopingTone {
  String name;
  int channel, pitch, velocity;
  int x, y;
  
  boolean isOn;
  

  float toneOnRatio, period, diameter, angleDelta;

  float angle; //this is the relative angle
  //of the head from the start of the loop
  //in radians
  boolean on;

  LoopingTone(String name, int channel, int pitch, int x, int y) {
    this.name  = name;
    this.channel = channel;
    this.pitch = pitch;
    this.velocity = 100;
    this.x = x;
    this.y = y;
    toneOnRatio = random(0.15, 0.3);
    period = ((int)random(150, 250))/10.0;
    angle = random(0.0, 2*PI);
    angleDelta = 2*PI/period/fps;
    diameter = 144;
    
    isOn = false;
    
    println(period);
  }
  void update() {
    //angle ranges from 2*PI to 0
    angle -= angleDelta;//period/(2*PI);
    
    //println(this.name + " angle radians: " + angle);
    if(angle <= 0.0){
      angle += 2*PI;
      if(isOn == false){
         myBus.sendNoteOn(channel, pitch, velocity);
         isOn = true;
         //println(name + " is ON");
      }
    }
    
    else if ( isOn && angle <= 2*PI - toneOnRatio * 2 * PI) {
      myBus.sendNoteOff(this.channel, this.pitch, this.velocity);
      isOn = false;
      //println("  "+name + " is OFF");
    }
  }

  void draw() {
    noFill();
    stroke(255,0,0);
    ellipse(x,y,diameter,diameter);
    fill(255, 0, 0);
    stroke(255,0,0);
    arc(x, y, diameter, diameter, angle + 3*PI/2, angle +2*PI*toneOnRatio + 3*PI/2);
    text(name+" "+"  "+nf(period,2,1)+"s  %"+nf(toneOnRatio*100,2,1), x - diameter/2, y + diameter/2 +24);
    noStroke();
    if(isOn){
      fill(255,255,0);
      triangle(x, y-diameter/2, x-6, y-diameter/2-10, x+6, y-diameter/2-10);
      noFill();
      stroke(255,255,0);
      rect(x-diameter/2-1,y-diameter/2-1, diameter+2, diameter+2);
    }
    else {
      fill(255,0,0);
      triangle(x, y-diameter/2, x-6, y-diameter/2-10, x+6, y-diameter/2-10);
      noFill();
      stroke(255,0,0);
      rect(x-diameter/2-1,y-diameter/2-1, diameter+2, diameter+2);
    }
    
   
    
  }
}