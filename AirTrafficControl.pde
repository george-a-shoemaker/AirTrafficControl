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

//TODO: make note always on or completely off explicit
//TODO: fix arc not fitting into circle, off by 1 pix
//TODO: verify that the default notes are "correct" w/ Eno's Track 2 Music for airports
//TODO: build note UI
//TODO: fix mismatched on/off midi note bug (this is a problem for garageband)
  // UNTESTED FIX
//TODO: add 8th looping tone, organize them 1-4 / 5-8
//TODO: when set to off, "dim" the color of all notes
  // UNTESTED FIX
//TODO: channel drop down menu
//TODO: channel drop down menu changes channel output
//TODO: Connected to default bus indicator
//TODO: Bus not found warning
//TODO: Set output bus name UI


//GLOBAL DECLARATIONS//
//GWindow helpWindow;

MidiBus myBus;
int x, y, frame, fps;
int swidth, sheight;

int nLoops;
LoopingNote1[] loops;
GSlider2D[] ltSliders;
GDropList channelDL;

GOption toggleOn, toggleSuspend, toggleOff;

boolean atcIsOn;

ATC atc;

void setup() {
  
  
  //PROCESSING SETTINGS//
  fps = 36;
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
    " to synthesize the MIDI events.\n"+
    "-This program expects to use a port named \""+busName+"\".\n"+
    "-If \""+busName+"\" is not available in the list below,\n" +
    " either configure a port with that name,\n"+
    " or set the \"busName\" variable to the name of a configured port\n"+
    " in the source code.");
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  
  myBus = new MidiBus(this, -1, busName);

  //INIT 7 NOTES//
  nLoops = 7;
  loops = new LoopingNote1[nLoops];
  ltSliders = new GSlider2D[nLoops];
  int y0 = 265;
  int y1 = 475;
  loops[0] = new LoopingNote1("F2 ", 0, 29, 100, y0, ltSliders[0], this);
  loops[1] = new LoopingNote1("G#2", 0, 32, 200, y1, ltSliders[1], this);
  loops[2] = new LoopingNote1("C3 ", 0, 36, 300, y0, ltSliders[2], this);
  loops[3] = new LoopingNote1("C#3", 0, 37, 400, y1, ltSliders[3], this);
  loops[4] = new LoopingNote1("D#3", 0, 39, 500, y0, ltSliders[4], this);
  loops[5] = new LoopingNote1("F3 ", 0, 41, 600, y1, ltSliders[5], this);
  loops[6] = new LoopingNote1("G#3", 0, 44, 700, y0, ltSliders[6], this);
  //loops[7] = new LoopingNote1();


  //ON OFF SWITCH SETUP//
  GToggleGroup onOffToggle = new GToggleGroup();
  toggleOn  = new GOption(this, 60, 100, 80, 24, "ON");
  toggleOn.setLocalColor(2, color(150, 0, 0));
  toggleSuspend = new GOption(this, 60, 120, 80, 24, "SUSPEND");
  toggleSuspend.setLocalColor(2, color(150, 0, 0));
  toggleOff = new GOption(this, 60, 140, 80, 24, "OFF");
  toggleOff.setLocalColor(2, color(150, 0, 0));
  onOffToggle.addControls(toggleOn, toggleSuspend, toggleOff);
  //DEVICE IS OFF AT START//
  atcIsOn = false;
  toggleOff.setSelected(true);
  
  //CHANNEL SELECTION DROP LIST SETUP//
  channelDL = new GDropList(this, 200, 130, 30, 300, 16);
  String[] channels = new String[16];
  for(int i = 0; i < channels.length; i++){ channels[i] = ""+(i+1); }
  channelDL.setItems(channels,0);
  this.channelDL.setLocalColor(2, color(150, 0,0));
  this.channelDL.setLocalColor(5, color(20));
  this.channelDL.setLocalColor(3, color(255,0,0));
  this.channelDL.setLocalColor(6, color(20));
  this.channelDL.setLocalColor(16, color(0,255,0));
  
  atc = new ATC(this, myBus);
  
  
}

void draw() {
  background(0);

  stroke(150, 0, 0);
  fill(150, 0, 0);

  textSize(30);
  text("AirTrafficControl", 60, 80);
  textSize(18);
  
  text("channel",180,120);


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
public void handleToggleControlEvents(GToggleControl source,  GEvent event) {
  if (source == toggleOn) {
    atcIsOn = true;
    //for (int i = 0; i < 7; i++) {
      //if (loops[i].isOn == true) {
        //myBus.sendNoteOn(loops[i].channel, loops[i].pitch, loops[i].velocity);
      //}
    //}
  } else if (source == toggleSuspend) {
    atcIsOn = false;
  } else if (source == toggleOff) {
    atcIsOn = false;
    for (int i = 0; i < 7; i++) {
      if (loops[i].isOn == true) {
        myBus.sendNoteOff(loops[i].channel, loops[i].pitch, loops[i].velocity);
        loops[i].isOn = false;
      }
    }
  }
}

//2D SLIDER EVENT HANDLER//
public void handleSlider2DEvents(GSlider2D slider2d, GEvent event) {
  for(int i = 0; i < nLoops; i++){
    if(slider2d == loops[i].slider){
        loops[i].toneOnRatio = loops[i].slider.getValueXF();
        loops[i].period = loops[i].slider.getValueYF();
        break;
    }
  }
  for(int i = 0; i< 
}




 

void exit() {
  println("Closing ATC...");
  for (int i = 0; i < 7; i++) {
    myBus.sendNoteOff(loops[i].channel, loops[i].pitch, loops[i].velocity);
  }
  println("All ATC MIDI notes set to off.");
  super.exit();
}








////////////////// HELP WINDOW


//ATC help window
//public void createHelpWindow() {
//  helpWindow = GWindow.getWindow(this, "ATC help", 100, 100, 200, 200, JAVA2D);
//  helpWindow.addData(new HelpWinData());
//  helpWindow.addDrawHandler(this, "helpWinDraw");
//  //helpWindow.addMouseHandler(this, "helpWinMouse");
//}

//public void windowDraw(PApplet appc, GWinData data1) {
//  HelpWinData data = (HelpWinData)data1;
//  appc.background(data.col);
//}

//class HelpWinData extends GWinData {
//  int col = 100;
//}

class LoopingNote1 {
  String name;
  int channel, pitch, velocity;
  int x, y;

  boolean isOn;

  float toneOnRatio, period, diameter, angleDelta;

  float angle; //this is the relative angle
  //of the head from the start of the loop
  //in radians
  boolean on;
  
  GSlider2D slider;
  
LoopingNote1(String name, int channel, int pitch, int x, int y, GSlider2D slider, PApplet appc) {
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

    isOn = false;

    this.slider = slider;
    this.slider = new GSlider2D(appc, x-74, y-74, 148, 148);
    this.slider.setLimitsX(toneOnRatio, 0.0, 1.0);
    this.slider.setLimitsY(period, 0.5, 30);
    

    //set most colors of the slider to transparent
    for (int i = 0; i < 16; i++) {
      this.slider.setLocalColor(i, color(255, 0));
    }
    this.slider.setLocalColor(6, color(255, 0));
    this.slider.setLocalColor(15, color(100, 150));

    this.slider.setEasing(4);
  }
  
  void update() {
    angleDelta = 2*PI/period/fps;
    //angle descends from 2*PI to 0
    angle -= angleDelta;//period/(2*PI);

    if (angle <= 0.0) { //Reset angle 2 * PI
      angle += 2*PI;
      if (isOn == false) { // Turn note on if it is off
        myBus.sendNoteOn(channel, pitch, velocity);
        isOn = true;
      }
      // If note should be off
    } else if (angle <= 2*PI - toneOnRatio * 2 * PI) {
      if(isOn){ // turn it off
        myBus.sendNoteOff(this.channel, this.pitch, this.velocity);
        isOn = false;
      }
      
    }
    else { // note should be on
      if(isOn == false){
        myBus.sendNoteOn(this.channel, this.pitch, this.velocity);
        isOn = true;
      }
    }
  }
   void draw() {
    noFill();

    fill(150, 0, 0);
    stroke(150, 0, 0);
    text(name+" "+"  "+nf(period, 2, 1)+"s  %"+nf(toneOnRatio*100, 2, 1), x - diameter/2, y + diameter/2 +24);
    noStroke();
    if (isOn) {
      fill(250, 0, 0);
      arc(x, y, diameter, diameter, angle + 3*PI/2, angle +2*PI*toneOnRatio + 3*PI/2);
      triangle(x, y-diameter/2, x-6, y-diameter/2-10, x+6, y-diameter/2-10);
      noFill();
      stroke(250, 0, 0);
      ellipse(x, y, diameter, diameter);
      //rect(x-diameter/2-1, y-diameter/2-1, diameter+2, diameter+2);
    } else {
      fill(120, 0, 0);
      triangle(x, y-diameter/2, x-6, y-diameter/2-10, x+6, y-diameter/2-10);
      arc(x, y, diameter, diameter, angle + 3*PI/2, angle +2*PI*toneOnRatio + 3*PI/2);      
      noFill();
      stroke(120, 0, 0);
      ellipse(x, y, diameter, diameter);
      //rect(x-diameter/2-1, y-diameter/2-1, diameter+2, diameter+2);
    }
  }
}
