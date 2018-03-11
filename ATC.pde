/*Consider multiple windows like so
* https://gist.github.com/atduskgreg/666e46c8408e2a33b09a
*/



/*
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
//TODO: channel drop down menu changes channel output
//TODO: Connected to default bus indicator
//TODO: Bus not found warning
//TODO: Set output bus name UI

class ATC {
  GWindow window;
  int nLoops = 8;
  LoopingTone[] loops = new LoopingTone[nLoops];
  GSlider2D[] ltSliders = new GSlider2D[nLoops];
  
  GOption toggleOn, toggleSuspend, toggleOff;
  GDropList channelDL;
  
  MidiBus bus;
  boolean atcIsOn;
  
  
  
  
  ATC(MidiBus bus, PApplet parent){
    
    window = GWindow.getWindow(parent, "ATC", 100, 100, 800, 600, JAVA2D);
    window.addData(new GWinData());
    window.addDrawHandler(parent, "windowDraw");
    window.addMouseHandler(parent, "windowMouse");
    
    this.bus = bus;
    atcIsOn = false;
    
    /*
    int y0 = 265;
    int y1 = 475;
    loops[0] = new LoopingTone("F2 ", 0, 29, 100, y0, ltSliders[0], parent);
    loops[1] = new LoopingTone("G#2", 0, 32, 300, y0, ltSliders[1], parent);
    loops[2] = new LoopingTone("C3 ", 0, 36, 500, y0, ltSliders[2], parent);
    loops[3] = new LoopingTone("C#3", 0, 37, 700, y0, ltSliders[3], parent);
    loops[4] = new LoopingTone("D#3", 0, 39, 100, y1, ltSliders[4], parent);
    loops[5] = new LoopingTone("F3 ", 0, 41, 300, y1, ltSliders[5], parent);
    loops[6] = new LoopingTone("G#3", 0, 44, 500, y1, ltSliders[6], parent);
    loops[7] = new LoopingTone("NOPE", 0, 1, 700, y1, ltSliders[7], parent);
    */
    
    //GToggleGroup onOffToggle = new GToggleGroup();
    //toggleOn  = new GOption(this, 60, 100, 80, 24, "ON");
    //toggleOn.setLocalColor(2, color(150, 0, 0));
    //toggleSuspend = new GOption(this, 60, 120, 80, 24, "SUSPEND");
    //toggleSuspend.setLocalColor(2, color(150, 0, 0));
    //toggleOff = new GOption(this, 60, 140, 80, 24, "OFF");
    //toggleOff.setLocalColor(2, color(150, 0, 0));
    //onOffToggle.addControls(toggleOn, toggleSuspend, toggleOff);
    ////DEVICE IS OFF AT START//
    //atcIsOn = false;
    //toggleOff.setSelected(true);
    
    ////CHANNEL SELECTION DROP LIST SETUP//
    //channelDL = new GDropList(this, 200, 130, 30, 300, 16);
    //String[] channels = new String[16];
    //for(int i = 0; i < channels.length; i++){ channels[i] = ""+(i+1); }
    //channelDL.setItems(channels,0);
    //this.channelDL.setLocalColor(2, color(150, 0,0));
    //this.channelDL.setLocalColor(5, color(20));
    //this.channelDL.setLocalColor(3, color(255,0,0));
    //this.channelDL.setLocalColor(6, color(20));
    //this.channelDL.setLocalColor(16, color(0,255,0));
  }
  
}

 public void windowDraw(PApplet appc, GWinData data){
    appc.background(250, 0, 0);

    appc.stroke(150, 0, 0);
    appc.rect(100, 100, 50, 50);
}

public void windowMouse(PApplet applet, GWinData windata, MouseEvent mouseevent) {

}
 
private class LoopingTone {
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

  LoopingTone(String name, int channel, int pitch, int x, int y, GSlider2D slider, PApplet parent) {
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
    text(name+" "+"  "+ nf(period, 2, 1)+"s  %"+nf(toneOnRatio*100, 2, 1), x - diameter/2, y + diameter/2 +24);
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