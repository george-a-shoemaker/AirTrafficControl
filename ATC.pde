public class ATC{
  PApplet parent;
  PApplet child;
 
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
    
    this.parent = parent;
    this.bus = bus;
    nNotes = 8;
    notes = new LoopingNote[8];
    isOn = false;
    refreshBusOutputs(); //set busNames array
    currentOutput = outputBuses[0];
    bus.addOutput(currentOutput);
    
    
    win = GWindow.getWindow(parent, "AirTrafficControl", 100, 100, 800, 600, JAVA2D);
    win.addData(new ATC_GWinData());
    ((ATC_GWinData)win.data).atc = this;
    
    win.addPreHandler(parent, "ATC_winPre"); //set the child param
    
    win.addDrawHandler(parent, "ATC_winDraw");
    textFont(loadFont("Avenir-HeavyOblique-48.vlw"), 22);
    
    //GUI
    noteSliders = new GSlider2D[nNotes];
  }
  
  void draw(){
    child.background(0);

    child.stroke(150, 0, 0);
    child.fill(150, 0, 0);

    child.textSize(30);
    child.text("AirTrafficControl", 60, 80);
    child.textSize(18);
  
    child.text("channel",180,120);
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
public void ATC_winDraw(PApplet appc, GWinData data) {
  ATC_GWinData data1 = (ATC_GWinData)data;
  data1.atc.draw();
}

/**
 * Sets font of ATC window before it is created
 * 
 * @param appc the PApplet object embeded into the frame
 * @param data the data for the GWindow being used
 */
public void ATC_winPre(PApplet appc, GWinData data) {
   ATC_GWinData data1 = (ATC_GWinData)data;
   data1.atc.child = appc;  
   appc.textFont(loadFont("Avenir-HeavyOblique-48.vlw"), 22); 
}

class ATC_GWinData extends GWinData {
  ATC atc;  
}










class LoopingNote {
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
  
  LoopingNote(String name, int channel, int pitch, int x, int y, GSlider2D slider, PApplet parent) {
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
    this.slider = new GSlider2D(parent, x-74, y-74, 148, 148);
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
