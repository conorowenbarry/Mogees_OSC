import oscP5.*;
import netP5.*;

OscP5 oscP5;

int NUM_VOICES = 5;

int []midiNotes = new int[NUM_VOICES];
float []onsetValues = new float[NUM_VOICES];

void setup() {
 
  size(800, 600);
  ellipseMode(CENTER);
  
  /* start oscP5, listening for incoming messages at port 7000 */
  oscP5 = new OscP5(this, 7000);
}


void draw () {
  
  stroke(0);
  background(255);
  
  for(int i = 0; i < NUM_VOICES; i++) {
    fill(midiNotes[i]);
    
    int size = (int)(onsetValues[i] * 200);
    
    ellipse((i + 1) * width/(NUM_VOICES + 1), height * .5, size, size);  
  }
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  
  // NOTE - (int gestureId, int midiNoteValue) 
  if (theOscMessage.checkAddrPattern("/note")==true) {
    if(theOscMessage.checkTypetag("ii")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int gestureId = theOscMessage.get(0).intValue();  
      int midiNote = theOscMessage.get(1).intValue();
      
      midiNotes[gestureId - 1] = midiNote;
    
      println("Gesture Id: "+gestureId+" Note: "+midiNote);
      return;
    }  
  }
  
  // ONSET - (int gestureId, float rms) 
  if (theOscMessage.checkAddrPattern("/onset")==true) {
    if(theOscMessage.checkTypetag("if")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int gestureId = theOscMessage.get(0).intValue();  
      float rms = theOscMessage.get(1).floatValue();
      
      onsetValues[gestureId - 1] = rms;
    
      println("Gesture Id: "+gestureId+" Onset rms: "+rms);
      return;
    }  
  }
  
  
  // GLOBAL RMS - (float rms) 
  if (theOscMessage.checkAddrPattern("/rms")==true) {
    if(theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */  
      float rms = theOscMessage.get(0).floatValue();
    
      println("RMS: "+rms);
      return;
    }  
  }
}
