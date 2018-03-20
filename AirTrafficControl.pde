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


//TODO: Set output bus menu


//GLOBAL DECLARATIONS//
//GWindow helpWindow;

MidiBus myBus;
String busName; //THIS IS THE NAME OF THE BUS FOR ATC
int x, y, frame, fps;
int swidth, sheight;

ArrayList<GWindow> windows; 
ArrayList<ATC> atcList;

ATC atc, atc1;

Button addButton;

void setup() {
  
  addButton = new Button("+1 ATC", 50,140,100,50);
  
  //PROCESSING SETTINGS//
  fps = 2;
  frameRate(fps);
  
  background(0);
  swidth  = 300;
  sheight = 200;
  size(300, 200);
  textFont(loadFont("Avenir-HeavyOblique-48.vlw"), 22);

  //SETUP MIDI PORT//

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
  
  atc  = new ATC(this, myBus);
  atc1 = new ATC(this, myBus);
  atc1.setChannel(2);
  windows = new ArrayList<GWindow>();
  windows.add(atc.win);
  windows.add(atc1.win);
}

void draw() {
  
  background(0);

  stroke(150, 0, 0);
  fill(150, 0, 0);

  textSize(30);
  text("ATC Launcher", 120, 40);
  textSize(18);
  
  
  fill(255);
  text(frameRate, 100, 80);
  text("Using Bus: \"" + busName + "\"", 100, 110);
  addButton.Draw();
  
  if (addButton.MouseIsOver()) {
    rect(200, 20, 50, 50);
  }
}

void mousePressed()
{
  if (addButton.MouseIsOver()) {
    
  }
}


//OFF SWITCH EVENT HANDLER//
public void handleToggleControlEvents(GToggleControl source,  GEvent event) {
    GWindow w = (GWindow)(source.getPApplet());
    ATC atc = ((ATC_GWinData)w.data).atc;
     
    if (atc.toggleOn == source) {
      atc.isOn = true;
      for (int i = 0; i < atc.nNotes; i++) {
        if (atc.notes[i].isOn == true) {
          atc.bus.sendNoteOn(atc.notes[i].channel, atc.notes[i].pitch, atc.notes[i].velocity);
        }
      }
    } else if (atc.toggleSuspend == source ) {
      atc.isOn = false;
    } else if (atc.toggleOff == source) {
      atc.isOn = false;
      for (int i = 0; i < 7; i++) {
        if (atc.notes[i].isOn == true) {
          myBus.sendNoteOff(atc.notes[i].channel, atc.notes[i].pitch, atc.notes[i].velocity);
          atc.notes[i].isOn = false;
      }
    }
  }
}


//2D SLIDER EVENT HANDLER//
public void handleSlider2DEvents(GSlider2D slider2d, GEvent event) {
  GWindow w = (GWindow)(slider2d.getPApplet());
  ATC atc = ((ATC_GWinData)w.data).atc;
  
  for(int i = 0; i < atc.notes.length; i++){
    if (slider2d == atc.notes[i].slider){
       atc.notes[i].toneOnRatio = slider2d.getValueXF();
       atc.notes[i].period = slider2d.getValueYF();
       return;
    }
  }
}




 

void exit() {
  /*
  println("Closing ATC...");
  for (int i = 0; i < 7; i++) {
    myBus.sendNoteOff(loops[i].channel, loops[i].pitch, loops[i].velocity);
  }
  println("All ATC MIDI notes set to off.");
  */
  super.exit();
}