/* ATC aka Air Traffic Control
 * George Shoemaker
 * Intro to Electronic Music Spring 2018
 *
 * Interactive program that generates MIDI events
 * to emulate Track 2 of Music For Airports by Brian Eno.
 *
 * https://teropa.info/loop/#/airports
 * 
 * Eno's OG notes (7)
 * i  Note  MIDI
 * 0  F2    29
 * 1  G#2   32
 * 2  C3    36
 * 3  C#3   37
 * 4  D#3   39
 * 5  F3    41
 * 6  G#3   44
 */


import themidibus.*;
import g4p_controls.*;

//TODO: Set all notes to off on close
//TODO: User input to change the duration and period of loop, 2d slider
//TODO: not on at start problem, edit the constructor, some notes should be on at start


//GLOBAL DECLARATIONS//
MidiBus myBus;
int x, y, frame, fps;
int swidth, sheight;
LoopingTone[] loops; 

GSlider2D ltControl;
GOption toggleOn, toggleSuspend, toggleOff;

boolean atcIsOn;

//DisposeHandler dh;



void setup() {
  //PROCESSING SETTINGS//
  fps = 30;
  frameRate(fps);
  size(800, 600);
  background(0);
  swidth = 800;
  sheight = 600;
  textFont(loadFont("Avenir-HeavyOblique-48.vlw"), 22);

  //SETUP MIDI PORT//
  String busName; //THIS IS THE NAME OF THE BUS FOR ATC
  busName = "MidiBusATC"; 
  busName = "SimpleSynth virtual input";
  busName = "IAC Bus 1";

  println("-This Processing program outputs MIDI events thru a port.\n"+
    "-To hear sound, a separate application is required\n"+
    "  to synthesize the MIDI events.\n"+
    "- This program expects to use a port named \""+busName+"\".\n"+
    "-If \""+busName+"\" is not available in the list below,\n" +
    "  either configure a port with that name,\n"+
    "  or set the \"busName\" variable to the name of a configured port\n"+
    "  in the source code.");
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, -1, busName);

  //INIT 7 NOTES//
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



  //isPlaying = true; // !! plan to remove this
  //ON OFF SWITCH SETUP//
  GToggleGroup onOffToggle = new GToggleGroup();
  toggleOn  = new GOption(this, 60, 100, 80, 24, "ON");
    toggleOn.setLocalColor(2, color(255,0,0));
  toggleSuspend = new GOption(this, 60, 120, 80, 24, "SUSPEND");
    toggleSuspend.setLocalColor(2, color(255,0,0));
  toggleOff = new GOption(this, 60, 140, 80, 24, "OFF");
   toggleOff.setLocalColor(2, color(255,0,0));
  onOffToggle.addControls(toggleOn, toggleSuspend, toggleOff);
  //DEVICE IS OFF AT START//
  atcIsOn = false;
  toggleOff.setSelected(true);


  // PERIOD & % ON SLIDER SETUP
  ltControl = new GSlider2D(this, 600, 15, 180, 140);
  ltControl.setLimitsX(180, 60, 480);
  ltControl.setLimitsY(150, 60, 280);
  ltControl.setEasing(8);
  ltControl.setNumberFormat(G4P.DECIMAL, 1);
  
  //dh = new DisposeHandler(this);
}

void draw() {
  background(0);

  stroke(255, 0, 0);
  fill(255, 0, 0);

  textSize(30);
  text("AirTrafficControl", 60, 80);
  textSize(18);

  textSize(18);

  //UPDATE NOTES ONLY IF DEVICE IS ON
  if (atcIsOn == true) {
    for (int i = 0; i < 7; i++) {
      loops[i].update();
      loops[i].draw();
    }
  } else { //ATC is off
    for (int i = 0; i < 7; i++) {
      loops[i].draw();
    }
  }
}

//OFF SWITCH EVENT HANDLER//
public void handleToggleControlEvents(GToggleControl source, GEvent event) {
  if (source == toggleOn) {
    atcIsOn = true;
    for(int i = 0; i < 7; i++) {
      if(loops[i].ltIsOn == true){
        myBus.sendNoteOn(loops[i].channel, loops[i].pitch, loops[i].velocity);
      }
    }
  } else if (source == toggleSuspend){
     atcIsOn = false;
  }
  else if (source == toggleOff) {
    atcIsOn = false;
    for(int i = 0; i < 7; i++) {
      if(loops[i].ltIsOn == true){
        myBus.sendNoteOff(loops[i].channel, loops[i].pitch, loops[i].velocity);
      }
    }
  }
}

//2D SLIDER EVENT HANDLER//
public void handleSlider2DEvents(GSlider2D slider2d, GEvent event){
  
}


class LoopingTone {
  String name;
  int channel, pitch, velocity;
  int x, y;

  boolean ltIsOn;

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
    toneOnRatio = random(0.2, 0.35);
    period = ((int)random(150, 250))/10.0;
    angle = random(0.0, 2*PI);
    angleDelta = 2*PI/period/fps;
    diameter = 144;

    //solve not on at start bug
    ltIsOn = false;
  }
  void update() {
    //angle descends from 2*PI to 0
    angle -= angleDelta;//period/(2*PI);

    if (angle <= 0.0) {
      angle += 2*PI;
      if (ltIsOn == false) {
        myBus.sendNoteOn(channel, pitch, velocity);
        ltIsOn = true;
      }
    } else if ( ltIsOn && angle <= 2*PI - toneOnRatio * 2 * PI) {
      myBus.sendNoteOff(this.channel, this.pitch, this.velocity);
      ltIsOn = false;
    }
  }

  void draw() {
    noFill();
    stroke(255, 0, 0);
    ellipse(x, y, diameter, diameter);
    fill(255, 0, 0);
    stroke(255, 0, 0);
    arc(x, y, diameter, diameter, angle + 3*PI/2, angle +2*PI*toneOnRatio + 3*PI/2);
    text(name+" "+"  "+nf(period, 2, 1)+"s  %"+nf(toneOnRatio*100, 2, 1), x - diameter/2, y + diameter/2 +24);
    noStroke();
    if (ltIsOn) {
      fill(255, 255, 0);
      triangle(x, y-diameter/2, x-6, y-diameter/2-10, x+6, y-diameter/2-10);
      noFill();
      stroke(255, 255, 0);
      rect(x-diameter/2-1, y-diameter/2-1, diameter+2, diameter+2);
    } else {
      fill(255, 0, 0);
      triangle(x, y-diameter/2, x-6, y-diameter/2-10, x+6, y-diameter/2-10);
      noFill();
      stroke(255, 0, 0);
      rect(x-diameter/2-1, y-diameter/2-1, diameter+2, diameter+2);
    }
  }
}

/*
public class DisposeHandler {
  DisposeHandler(PApplet pa)
  {
    pa.registerMethod("dispose", this);
  }
   
  public void dispose()
  {      
    println("Closing sketch");
    for(int i = 0; i < 7; i++){
      myBus.sendNoteOff(loops[i].channel, loops[i].pitch, loops[i].velocity);
    }
  }
}
*/
void exit() {
   println("Closing sketch...");
    for(int i = 0; i < 7; i++){
      myBus.sendNoteOff(loops[i].channel, loops[i].pitch, loops[i].velocity);
      //println("note "+i+" off");
    }
    println("All ATC MIDI notes set to off.");
    super.exit();
}