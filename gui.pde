/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

//synchronized public void win_draw1(PApplet appc, GWinData data) { //_CODE_:window1:586260:
//  appc.background(230);
//} //_CODE_:window1:586260:

//synchronized public void post(PApplet appc, GWinData data) { //_CODE_:window1:785447:
//  println("window1 - post method called " + millis());
//} //_CODE_:window1:785447:

//public void optOn_eventClicked(GOption source, GEvent event) { //_CODE_:optOn:856642:
//  println("option1 - GOption >> GEvent." + event + " @ " + millis());
//} //_CODE_:optOn:856642:

//public void optOff_clicked(GOption source, GEvent event) { //_CODE_:optOff:275341:
//  println("option3 - GOption >> GEvent." + event + " @ " + millis());
//} //_CODE_:optOff:275341:

//public void optSuspend_clicked(GOption source, GEvent event) { //_CODE_:optSuspend:915152:
//  println("option2 - GOption >> GEvent." + event + " @ " + millis());
//} //_CODE_:optSuspend:915152:

//public void veloKnob_turn(GKnob source, GEvent event) { //_CODE_:veloKnob:793092:
//  println("knob1 - GKnob >> GEvent." + event + " @ " + millis());
//} //_CODE_:veloKnob:793092:

//public void dropList1_click1(GDropList source, GEvent event) { //_CODE_:dropList1:819141:
//  println("dropList1 - GDropList >> GEvent." + event + " @ " + millis());
//} //_CODE_:dropList1:819141:

//public void slider2d2_change1(GSlider2D source, GEvent event) { //_CODE_:slider2d2:946904:
//  println("slider2d2 - GSlider2D >> GEvent." + event + " @ " + millis());
//} //_CODE_:slider2d2:946904:

//public void velocityKnob_turn(GKnob source, GEvent event) { //_CODE_:velocityKnob:757923:
//  println("knob2 - GKnob >> GEvent." + event + " @ " + millis());
//} //_CODE_:velocityKnob:757923:

//public void dropList2_click1(GDropList source, GEvent event) { //_CODE_:dropList2:548360:
//  println("dropList2 - GDropList >> GEvent." + event + " @ " + millis());
//} //_CODE_:dropList2:548360:

//public void slider2d1_change1(GSlider2D source, GEvent event) { //_CODE_:slider2d1:571820:
//  println("slider2d1 - GSlider2D >> GEvent." + event + " @ " + millis());
//} //_CODE_:slider2d1:571820:

//public void slider2d3_change1(GSlider2D source, GEvent event) { //_CODE_:slider2d3:602868:
//  println("slider2d3 - GSlider2D >> GEvent." + event + " @ " + millis());
//} //_CODE_:slider2d3:602868:

//public void slider2d4_change1(GSlider2D source, GEvent event) { //_CODE_:slider2d4:910129:
//  println("slider2d4 - GSlider2D >> GEvent." + event + " @ " + millis());
//} //_CODE_:slider2d4:910129:

//public void slider2d5_change1(GSlider2D source, GEvent event) { //_CODE_:slider2d5:671202:
//  println("slider2d5 - GSlider2D >> GEvent." + event + " @ " + millis());
//} //_CODE_:slider2d5:671202:

//public void channelKnob_turn(GKnob source, GEvent event) { //_CODE_:channelKnob:938707:
//  println("knob3 - GKnob >> GEvent." + event + " @ " + millis());
//} //_CODE_:channelKnob:938707:

//public void portDropList_click(GDropList source, GEvent event) { //_CODE_:portDropList:739954:
//  println("portDropList - GDropList >> GEvent." + event + " @ " + millis());
//} //_CODE_:portDropList:739954:

//public void slider2d6_change1(GSlider2D source, GEvent event) { //_CODE_:slider2d6:963527:
//  println("slider2d6 - GSlider2D >> GEvent." + event + " @ " + millis());
//} //_CODE_:slider2d6:963527:

//public void slider2d7_change1(GSlider2D source, GEvent event) { //_CODE_:slider2d7:644033:
//  println("slider2d7 - GSlider2D >> GEvent." + event + " @ " + millis());
//} //_CODE_:slider2d7:644033:

//public void slider2d8_change1(GSlider2D source, GEvent event) { //_CODE_:slider2d8:663342:
//  println("slider2d8 - GSlider2D >> GEvent." + event + " @ " + millis());
//} //_CODE_:slider2d8:663342:



//// Create all the GUI controls. 
//// autogenerated do not edit
//public void createGUI(){
//  G4P.messagesEnabled(false);
//  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
//  G4P.setCursor(ARROW);
//  surface.setTitle("Sketch Window");
//  window1 = GWindow.getWindow(this, "Window title", 0, 0, 476, 320, 150);
//  window1.noLoop();
//  window1.setActionOnClose(G4P.CLOSE_WINDOW);
//  window1.addDrawHandler(this, "win_draw1");
//  window1.addPostHandler(this, "post");
//  onOffToggle = new GToggleGroup();
//  optOn = new GOption(window1, 120, 8, 68, 16);
//  optOn.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
//  optOn.setText("ON");
//  optOn.setOpaque(false);
//  optOn.addEventHandler(this, "optOn_eventClicked");
//  optOff = new GOption(window1, 120, 40, 68, 16);
//  optOff.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
//  optOff.setText("OFF");
//  optOff.setOpaque(false);
//  optOff.addEventHandler(this, "optOff_clicked");
//  optSuspend = new GOption(window1, 120, 24, 68, 16);
//  optSuspend.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
//  optSuspend.setText("SUSPEND");
//  optSuspend.setOpaque(false);
//  optSuspend.addEventHandler(this, "optSuspend_clicked");
//  onOffToggle.addControl(optOn);
//  onOffToggle.addControl(optOff);
//  optOff.setSelected(true);
//  onOffToggle.addControl(optSuspend);
//  chanLabel = new GLabel(window1, 500, 20, 90, 20);
//  chanLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
//  chanLabel.setText("CHANNEL");
//  chanLabel.setOpaque(false);
//  veloKnob = new GKnob(window1, 500, 40, 40, 40, 0.8);
//  veloKnob.setTurnRange(110, 70);
//  veloKnob.setTurnMode(GKnob.CTRL_HORIZONTAL);
//  veloKnob.setSensitivity(1);
//  veloKnob.setShowArcOnly(false);
//  veloKnob.setOverArcOnly(false);
//  veloKnob.setIncludeOverBezel(false);
//  veloKnob.setShowTrack(true);
//  veloKnob.setLimits(1.0, 0.0, 127.0);
//  veloKnob.setNbrTicks(127);
//  veloKnob.setStickToTicks(true);
//  veloKnob.setOpaque(false);
//  veloKnob.addEventHandler(this, "veloKnob_turn");
//  velocityLabel = new GLabel(window1, 200, 8, 64, 12);
//  velocityLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
//  velocityLabel.setText("VELOCITY");
//  velocityLabel.setOpaque(false);
//  dropList1 = new GDropList(window1, 660, 80, 90, 80, 3);
//  dropList1.setItems(loadStrings("list_819141"), 0);
//  dropList1.addEventHandler(this, "dropList1_click1");
//  label3 = new GLabel(window1, 660, 60, 90, 20);
//  label3.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
//  label3.setText("MIDI Bus");
//  label3.setOpaque(false);
//  labelATC = new GLabel(window1, 8, 16, 108, 32);
//  labelATC.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
//  labelATC.setText("AirTrafficControl George Shoemaker");
//  labelATC.setTextBold();
//  labelATC.setTextItalic();
//  labelATC.setOpaque(false);
//  label5 = new GLabel(window1, 540, 40, 50, 40);
//  label5.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
//  label5.setText("My label");
//  label5.setOpaque(false);
//  slider2d2 = new GSlider2D(window1, 128, 64, 104, 104);
//  slider2d2.setLimitsX(0.5, 0.0, 1.0);
//  slider2d2.setLimitsY(0.5, 0.0, 1.0);
//  slider2d2.setNumberFormat(G4P.DECIMAL, 2);
//  slider2d2.setOpaque(false);
//  slider2d2.addEventHandler(this, "slider2d2_change1");
//  velocityKnob = new GKnob(window1, 200, 20, 36, 36, 0.8);
//  velocityKnob.setTurnRange(110, 70);
//  velocityKnob.setTurnMode(GKnob.CTRL_HORIZONTAL);
//  velocityKnob.setSensitivity(1);
//  velocityKnob.setShowArcOnly(false);
//  velocityKnob.setOverArcOnly(false);
//  velocityKnob.setIncludeOverBezel(false);
//  velocityKnob.setShowTrack(true);
//  velocityKnob.setLimits(100.0, 0.0, 127.0);
//  velocityKnob.setNbrTicks(127);
//  velocityKnob.setStickToTicks(true);
//  velocityKnob.setOpaque(false);
//  velocityKnob.addEventHandler(this, "velocityKnob_turn");
//  velocityVal = new GLabel(window1, 236, 20, 28, 36);
//  velocityVal.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
//  velocityVal.setText("000");
//  velocityVal.setOpaque(false);
//  dropList2 = new GDropList(window1, 564, 30, 90, 80, 3);
//  dropList2.setItems(loadStrings("list_548360"), 0);
//  dropList2.addEventHandler(this, "dropList2_click1");
//  slider2d1 = new GSlider2D(window1, 12, 64, 104, 104);
//  slider2d1.setLimitsX(0.5, 0.0, 1.0);
//  slider2d1.setLimitsY(0.5, 0.0, 1.0);
//  slider2d1.setNumberFormat(G4P.DECIMAL, 2);
//  slider2d1.setOpaque(false);
//  slider2d1.addEventHandler(this, "slider2d1_change1");
//  slider2d3 = new GSlider2D(window1, 244, 64, 104, 104);
//  slider2d3.setLimitsX(0.5, 0.0, 1.0);
//  slider2d3.setLimitsY(0.5, 0.0, 1.0);
//  slider2d3.setNumberFormat(G4P.DECIMAL, 2);
//  slider2d3.setOpaque(false);
//  slider2d3.addEventHandler(this, "slider2d3_change1");
//  slider2d4 = new GSlider2D(window1, 360, 64, 104, 104);
//  slider2d4.setLimitsX(0.5, 0.0, 1.0);
//  slider2d4.setLimitsY(0.5, 0.0, 1.0);
//  slider2d4.setNumberFormat(G4P.DECIMAL, 0);
//  slider2d4.setOpaque(false);
//  slider2d4.addEventHandler(this, "slider2d4_change1");
//  noteLabel1 = new GLabel(window1, 12, 168, 28, 16);
//  noteLabel1.setText("A#0");
//  noteLabel1.setOpaque(false);
//  portLabel = new GLabel(window1, 360, 8, 104, 12);
//  portLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
//  portLabel.setText("MIDI OUT PORT");
//  portLabel.setOpaque(false);
//  secLabel1 = new GLabel(window1, 44, 168, 36, 16);
//  secLabel1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
//  secLabel1.setText("00.0s");
//  secLabel1.setOpaque(false);
//  slider2d5 = new GSlider2D(window1, 12, 192, 104, 104);
//  slider2d5.setLimitsX(0.5, 0.0, 1.0);
//  slider2d5.setLimitsY(0.5, 0.0, 1.0);
//  slider2d5.setNumberFormat(G4P.DECIMAL, 2);
//  slider2d5.setOpaque(false);
//  slider2d5.addEventHandler(this, "slider2d5_change1");
//  percentLabel1 = new GLabel(window1, 72, 168, 44, 16);
//  percentLabel1.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
//  percentLabel1.setText("%0.00");
//  percentLabel1.setOpaque(false);
//  channelKnob = new GKnob(window1, 280, 20, 36, 36, 0.8);
//  channelKnob.setTurnRange(110, 70);
//  channelKnob.setTurnMode(GKnob.CTRL_HORIZONTAL);
//  channelKnob.setSensitivity(1);
//  channelKnob.setShowArcOnly(false);
//  channelKnob.setOverArcOnly(false);
//  channelKnob.setIncludeOverBezel(false);
//  channelKnob.setShowTrack(true);
//  channelKnob.setLimits(1.0, 1.0, 16.0);
//  channelKnob.setNbrTicks(16);
//  channelKnob.setStickToTicks(true);
//  channelKnob.setShowTicks(true);
//  channelKnob.setOpaque(false);
//  channelKnob.addEventHandler(this, "channelKnob_turn");
//  channelLabel = new GLabel(window1, 280, 8, 64, 12);
//  channelLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
//  channelLabel.setText("CHANNEL");
//  channelLabel.setOpaque(false);
//  channelVal = new GLabel(window1, 316, 20, 28, 36);
//  channelVal.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
//  channelVal.setText("00");
//  channelVal.setOpaque(false);
//  portDropList = new GDropList(window1, 360, 20, 104, 56, 3);
//  portDropList.setItems(loadStrings("list_739954"), 0);
//  portDropList.addEventHandler(this, "portDropList_click");
//  slider2d6 = new GSlider2D(window1, 128, 192, 104, 104);
//  slider2d6.setLimitsX(0.5, 0.0, 1.0);
//  slider2d6.setLimitsY(0.5, 0.0, 1.0);
//  slider2d6.setNumberFormat(G4P.DECIMAL, 2);
//  slider2d6.setOpaque(false);
//  slider2d6.addEventHandler(this, "slider2d6_change1");
//  slider2d7 = new GSlider2D(window1, 244, 192, 104, 104);
//  slider2d7.setLimitsX(0.5, 0.0, 1.0);
//  slider2d7.setLimitsY(0.5, 0.0, 1.0);
//  slider2d7.setNumberFormat(G4P.DECIMAL, 2);
//  slider2d7.setOpaque(false);
//  slider2d7.addEventHandler(this, "slider2d7_change1");
//  slider2d8 = new GSlider2D(window1, 360, 192, 104, 104);
//  slider2d8.setLimitsX(0.5, 0.0, 1.0);
//  slider2d8.setLimitsY(0.5, 0.0, 1.0);
//  slider2d8.setNumberFormat(G4P.DECIMAL, 2);
//  slider2d8.setOpaque(false);
//  slider2d8.addEventHandler(this, "slider2d8_change1");
//  window1.loop();
//}

//// Variable declarations 
//// autogenerated do not edit
//GWindow window1;
//GToggleGroup onOffToggle; 
//GOption optOn; 
//GOption optOff; 
//GOption optSuspend; 
//GLabel chanLabel; 
//GKnob veloKnob; 
//GLabel velocityLabel; 
//GDropList dropList1; 
//GLabel label3; 
//GLabel labelATC; 
//GLabel label5; 
//GSlider2D slider2d2; 
//GKnob velocityKnob; 
//GLabel velocityVal; 
//GDropList dropList2; 
//GSlider2D slider2d1; 
//GSlider2D slider2d3; 
//GSlider2D slider2d4; 
//GLabel noteLabel1; 
//GLabel portLabel; 
//GLabel secLabel1; 
//GSlider2D slider2d5; 
//GLabel percentLabel1; 
//GKnob channelKnob; 
//GLabel channelLabel; 
//GLabel channelVal; 
//GDropList portDropList; 
//GSlider2D slider2d6; 
//GSlider2D slider2d7; 
//GSlider2D slider2d8; 