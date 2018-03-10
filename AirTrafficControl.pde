/* ATC aka Air Traffic Control
 * George Shoemaker
 * Intro to Electronic Music Spring 2018
 *
 * Interactive program that generates MIDI events
 * to emulate Track 2 of Music For Airports by Brian Eno.
 *
 */


import themidibus.*;
import g4p_controls.*;


//GLOBAL DECLARATIONS//

int x, y, frame, fps;
int swidth, sheight;
ATC atc1;


//KILLLLLLL
MidiBus myBus;
int nLoops;
LoopingTone[] loops;
GSlider2D[] ltSliders;
GDropList channelDL;
GOption toggleOn, toggleSuspend, toggleOff;
boolean atcIsOn;
//KILLLLLLLLLL



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
  
  atc1 = new ATC(myBus, this);





  //INIT 7 NOTES//
  nLoops = 7;
  loops = new LoopingTone[nLoops];
  ltSliders = new GSlider2D[nLoops];
  int y0 = 265;
  int y1 = 475;
  loops[0] = new LoopingTone("F2 ", 0, 29, 100, y0, ltSliders[0], this);
  loops[1] = new LoopingTone("G#2", 0, 32, 200, y1, ltSliders[1], this);
  loops[2] = new LoopingTone("C3 ", 0, 36, 300, y0, ltSliders[2], this);
  loops[3] = new LoopingTone("C#3", 0, 37, 400, y1, ltSliders[3], this);
  loops[4] = new LoopingTone("D#3", 0, 39, 500, y0, ltSliders[4], this);
  loops[5] = new LoopingTone("F3 ", 0, 41, 600, y1, ltSliders[5], this);
  loops[6] = new LoopingTone("G#3", 0, 44, 700, y0, ltSliders[6], this);


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
}

void draw() {
  background(0);

//KILLLLLLLLLLLLLL
  stroke(150, 0, 0);
  fill(150, 0, 0);

  textSize(30);
  text("AirTrafficControl", 60, 80);
  textSize(18);
  
  text("channel",180,120);
//KILLLLLLLLLLLLLLLLL
  
  

//KILLLLLLLLLL
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
//KILLLLLLLLL
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
}

void exit() {
  println("Closing ATC...");
  for (int i = 0; i < 7; i++) {
    myBus.sendNoteOff(loops[i].channel, loops[i].pitch, loops[i].velocity);
  }
  println("All ATC MIDI notes set to off.");
  super.exit();
}