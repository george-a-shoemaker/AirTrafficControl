/* ATC aka Air Traffic Control
 * George Shoemaker
 * Intro to Electronic Music Spring 2018
 *
 * Interactive program the generates the notes
 * from Track 2 of Music For Airports by Brian Eno
 *
 * https://teropa.info/loop/#/airports
 */

import themidibus.*; //Import the library

//TODO: On/Off tone with LoopingTone class
//TODO: Adjust random initial settings to be a factor of deltaAngle
//TODO: Multiple channles & notes
//TODO: User input to change the duration and period of loop

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

void setup() {
  fps = 30;
  frameRate(fps);
  size(800, 600);
  background(0);
  textFont(loadFont("Avenir-HeavyOblique-48.vlw"), 22);
  
   frame = 0;
   
  String busName = "MidiBusATC"; //THIS IS THE NAME OF THE BUS FOR ATC

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
  
  int swidth = 800;
  int sheight = 600;
  
  loops = new LoopingTone[7];
  
  int y0 = 200;
  int y1 = 450;
  loops[0] = new LoopingTone("F2 ", 1, 29, 100, y0);
  loops[1] = new LoopingTone("G#2", 1, 32, 200, y1);
  loops[2] = new LoopingTone("C3 ", 1, 36, 300, y0);
  loops[3] = new LoopingTone("C#3", 1, 37, 400, y1);
  loops[4] = new LoopingTone("D#3", 1, 39, 500, y0);
  loops[5] = new LoopingTone("F3 ", 1, 41, 600, y1);
  loops[6] = new LoopingTone("G#3", 1, 44, 700, y0);
}

void draw() {
  //println(++frame);
  background(0);

  int channel = 1;
  int pitch = 29;
  int velocity = 100;

  
  stroke(255, 0, 0);
  fill(255, 0, 0);
  for(int i = 0; i < 7; i++){
    loops[i].update();
    loops[i].display();
  }  

  textSize(30);
  text("AirTrafficControl", 16, 30);
  textSize(18);
  
 


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
  

  float toneOnRatio, period, diameter, angleDelta;

  float angle; //this is the relative angle
  //of the head from the start of the loop
  //in radians
  boolean on;

  LoopingTone(String name, int channel, int pitch, int x, int y) {
    this.name  = name;
    this.channel = channel;
    this.pitch = pitch;
    this.x = x;
    this.y = y;
    toneOnRatio = random(0.15, 0.25);
    period = (int)random(20, 30);
    angle = random(0.0, 2*PI);
    angleDelta = 2*PI/period/fps;
    
    diameter = 144;
    
    println(period);
  }
  void update() {
    //angle ranges from 2*PI to 0
    angle -= angleDelta;//period/(2*PI);
    if (angle <= 0) {
      angle = 2*PI + angle;
      //myBus.sendNoteOn(channel, pitch, velocity);
      //println("Note ON");
    } else if (angle >= toneOnRatio * 2 * PI) {
      //myBus.sendNoteOff(channel, pitch, velocity);
      //println("  Note OFF");
    }
  }

  void display() {
    noFill();
    ellipse(x,y,diameter,diameter);
    //rect(x-diameter/2,y-diameter/2, diameter, diameter);
    fill(255, 0, 0);
    arc(x, y, diameter, diameter, angle, angle+2*PI*toneOnRatio);
    triangle(x, y-diameter/2, x-6, y-diameter/2-10, x+6, y-diameter/2-10);
    text(name+" "+"  "+nf(period,2,1)+"s  %"+nf(toneOnRatio*100,2,1), x - diameter/2-10, y + diameter/2 +24);
  }
}