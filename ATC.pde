


public class ATC{
  PApplet parent;
 
  MidiBus bus;
  int nNotes;
  LoopingNote[] notes;
  boolean isOn;
  String outputBuses[];
  String currentOutput;
  
  //GUI
  GSlider2D[] noteSliders;
  // Channel knob
  GOption toggleOn, toggleSuspend, toggleOff;
  // HELP BUTTON
  
  
  GWindow win;
  
  ATC(PApplet parent, MidiBus bus) {
    
    this.parent = parent; // The PApplet that created the instance of ATC //<>//
    this.bus = bus; //<>//
    nNotes = 8; //<>//
    notes = new LoopingNote[8]; //<>//
    isOn = false; //<>//
    refreshBusOutputs(); //set busNames array //<>//
    currentOutput = outputBuses[0]; //<>//
    bus.addOutput(currentOutput); //<>//
    
    
    win = GWindow.getWindow(parent, "AirTrafficControl", 100, 100, 800, 600, JAVA2D); //<>//
    win.loop();
    win.setActionOnClose(G4P.CLOSE_WINDOW);
    win.addData(new ATC_GWinData()); //<>//
    ((ATC_GWinData)win.data).atc = this; //Attach instance of ATC to window data
    
    win.textFont(loadFont("Avenir-HeavyOblique-48.vlw"), 22);
    
    win.addDrawHandler(parent, "ATC_winDraw");
    textFont(loadFont("Avenir-HeavyOblique-48.vlw"), 22);
    
    //GUI
    noteSliders = new GSlider2D[nNotes];
    GToggleGroup onOffToggle;
    
    int y0 = 265;
    int y1 = 475;
    notes[0] = new LoopingNote("F2 ", 0, 29, 100, y0, win);
    notes[1] = new LoopingNote("G#2", 0, 32, 300, y0, win);
    notes[2] = new LoopingNote("C3 ", 0, 36, 500, y0, win);
    notes[3] = new LoopingNote("C#3", 0, 37, 700, y0, win);
    notes[4] = new LoopingNote("D#3", 0, 39, 100, y1, win);
    notes[5] = new LoopingNote("F3 ", 0, 41, 300, y1, win);
    notes[6] = new LoopingNote("G#3", 0, 44, 500, y1, win);
    notes[7] = new LoopingNote("-- ", 0, 44, 700, y1, win);
    
    onOffToggle = new GToggleGroup();
    toggleOn = new GOption(win, 60, 100, 80, 24, "ON");
    toggleOn.setLocalColor(2, color(150, 0, 0));
    toggleSuspend = new GOption(win, 60, 120, 80, 24, "SUSPEND");
    toggleSuspend.setLocalColor(2, color(150, 0, 0));
    toggleOff = new GOption(win, 60, 140, 80, 24, "OFF");
    toggleOff.setLocalColor(2, color(150, 0, 0));
    onOffToggle.addControls(toggleOn, toggleSuspend, toggleOff);
  }
  
  void draw(){
    win.background(0);

    win.stroke(150, 0, 0);
    win.fill(150, 0, 0);

    win.textSize(30);
    win.text("AirTrafficControl", 60, 80);
    win.textSize(18);
  
    win.text("channel",180,120);
    
    //UPDATE NOTES ONLY IF DEVICE IS ON
    if (atcIsOn == true) {
      for (int i = 0; i < 7; i++) {
        notes[i].update();
        notes[i].draw();
      }
    } else { //ATC is off
      for (int i = 0; i < 7; i++) {
        notes[i].draw();
    }
  }
    
  }
  
  private void refreshBusOutputs(){
    outputBuses = new String[16]; //set all values to NULL
    int n = MidiBus.availableInputs().length;
    if (n > 16) n = 16;
    System.arraycopy(MidiBus.availableInputs(), 0, outputBuses, 0, n);
  }
}

/**
 * Handles drawing to the windows PApplet area
 * 
 * @param appc the PApplet object embeded into the frame
 * @param data the data for the GWindow being used
 */
 
synchronized public void ATC_winDraw(PApplet appc, GWinData data) {
  ATC_GWinData data1 = (ATC_GWinData)data;
  data1.atc.draw();
}
 //<>//
class ATC_GWinData extends GWinData {
  ATC atc;  
}






class LoopingNote {
  GWindow win;
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
  
  LoopingNote(String name, int channel, int pitch, int x, int y, PApplet win) {
    this.win = (GWindow)win;
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
    
    slider = new GSlider2D(this.win, x-74, y-74, 148, 148);
    slider.setLimitsX(toneOnRatio, 0.0, 1.0);
    slider.setLimitsY(period, 0.5, 30);
    
    for (int i = 0; i < 16; i++) {
      slider.setLocalColor(i, color(255, 0));
    }
    
    slider.setLocalColor(6, color(255, 0));
    slider.setLocalColor(15, color(100, 150));
    slider.setEasing(4);
    
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
    win.noFill();

    win.fill(150, 0, 0);
    win.stroke(150, 0, 0);
    win.text(name+" "+"  "+nf(period, 2, 1)+"s  %"+nf(toneOnRatio*100, 2, 1), x - diameter/2, y + diameter/2 +24);
    win.noStroke();
    if (isOn) {
      win.fill(250, 0, 0);
      win.arc(x, y, diameter, diameter, angle + 3*PI/2, angle +2*PI*toneOnRatio + 3*PI/2);
      win.triangle(x, y-diameter/2, x-6, y-diameter/2-10, x+6, y-diameter/2-10);
      win.noFill();
      win.stroke(250, 0, 0);
      win.ellipse(x, y, diameter, diameter);
      //rect(x-diameter/2-1, y-diameter/2-1, diameter+2, diameter+2);
    } else {
      win.fill(120, 0, 0);
      win.triangle(x, y-diameter/2, x-6, y-diameter/2-10, x+6, y-diameter/2-10);
      win.arc(x, y, diameter, diameter, angle + 3*PI/2, angle +2*PI*toneOnRatio + 3*PI/2);      
      win.noFill();
      win.stroke(120, 0, 0);
      win.ellipse(x, y, diameter, diameter);
      //win.rect(x-diameter/2-1, y-diameter/2-1, diameter+2, diameter+2);
    }
  }
}
