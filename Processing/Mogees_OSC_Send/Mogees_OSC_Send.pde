import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress mogeesDeviceAddress;

int currentMidiNote;


void setup() {
 
  size(400, 400);
  ellipseMode(CENTER);
  
  /* start oscP5, listening for incoming messages at port 7000 */
  oscP5 = new OscP5(this, 7000);
  
  /* Set the address of Mogees iDevice. App listens on port 7001 by default */
  mogeesDeviceAddress = new NetAddress("127.0.0.1", 7001);
}

void draw() {
  
  background(currentMidiNote);
}

void mousePressed() {
  
  sendMidiNote(midiNoteFromMousePos(mouseY));
}

void mouseDragged() {
  
  sendMidiNote(midiNoteFromMousePos(mouseY));
}


void sendMidiNote(int midiNote) {
  
  println("MIDI Note: " + midiNote);
 
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage noteMessage = new OscMessage("/note");
  noteMessage.add(midiNote); /* add a MIDI note to the osc message */
  oscP5.send(noteMessage, mogeesDeviceAddress);   /* send the message */ 
}

int midiNoteFromMousePos(int mouseY) {
  
  currentMidiNote = 127 - (int)(((float)mouseY/(float)height) * 127);
  currentMidiNote = constrain(currentMidiNote, 0, 127);
 
 return currentMidiNote; 
}
  
