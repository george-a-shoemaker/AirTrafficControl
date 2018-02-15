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
//TODO: Multiple channles & notes
//TODO: Graphical representation of LoopingTone
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

LoopingTone lt0; 

void setup() {
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
  println("");

  myBus = new MidiBus(this, -1, busName);

  //LoopingTone(String name, int channel, int pitch, int x, int y)//
  lt0 = new LoopingTone("F2", 1, 29, 400, 300);

  frameRate(24);
  size(800, 600);
  background(0);
  textFont(loadFont("Avenir-HeavyOblique-48.vlw"), 22);
}

void draw() {
  println(++frame);
  background(0);

  int channel = 1;
  int pitch = 29;
  int velocity = 100;

  stroke(255, 0, 0);
  fill(255, 0, 0);
  lt0.update();
  lt0.display();

  text("Air Traffic Control", 16, 30);


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
  

  float toneOnRatio, period, diameter;

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
  }
  void update() {
    //angle ranges from 2*PI to 0
    angle -= 0.05;//period/(2*PI);
    println(angle);
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
    //ellipse(x,y,200,200);
    fill(255, 0, 0);
    arc(x, y, 200, 200, angle, angle+2*PI*toneOnRatio);
    triangle(x, y-100, x-6, y-110, x+6, y-110);
  }
}