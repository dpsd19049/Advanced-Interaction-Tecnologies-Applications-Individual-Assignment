/*
 TUIO 1.1 Demo for Processing
 Copyright (c) 2005-2014 Martin Kaltenbrunner <martin@tuio.org>
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
*/

// import the TUIO library
import TUIO.*;
// declare a TuioProcessing client
TuioProcessing tuioClient;
PImage img; 

// these are some helper variables which are used
// to create scalable graphical feedback

float object_size = 200;
float table_size = 560;
float scale_factor = 1;
PFont font;
//int imagewidth, imageheight;
float black;
float zoom = 50;
boolean loadImage= false ;
boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks

void setup()
{
  // GUI setup
  noCursor();
  size(720,480);
  noStroke();
  fill(0);
   img = loadImage("skull1.jpg");
  // periodic updates
  if (!callback) {
    frameRate(60);
    loop();
  } else noLoop(); // or callback updates 
  
  font = createFont("Arial", 18);
  scale_factor = height/table_size;
  
  // finally we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods in this class (see below)
  tuioClient  = new TuioProcessing(this);
}

// within the draw method we retrieve an ArrayList of type <TuioObject>, <TuioCursor> or <TuioBlob>
// from the TuioProcessing client and then loops over all lists to draw the graphical feedback.
void draw()
{
  background(255);
  textFont(font,18*scale_factor);
  float obj_size = object_size*scale_factor; 
 

 ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0;i<tuioObjectList.size();i++) {

   
     TuioObject tobj = tuioObjectList.get(i);
      if(tobj.getSymbolID() == 0)
    {
     stroke(0);
     fill(0,0,0);
     pushMatrix();
     translate(tobj.getScreenX(width),tobj.getScreenY(height));
     rotate(tobj.getAngle());
     image(img, -obj_size/2,-obj_size/2,obj_size,obj_size);
   
     popMatrix();
     fill(255);
   
   }
   
    if (loadImage)
    {
      
      if (tobj.getSymbolID()==1)
      {
  
       black = map(tobj.getAngle(), 0,6 , 255, 0 );
       tint(black);
       
      }
      if (tobj.getSymbolID()==2)
      {
        
        zoom =constrain(zoom +tobj.getRotationSpeed()*3, 10, 150 );
       object_size = int((img.width+img.height)* zoom/1000); 
      }
       
    }
  }
   
 
}

// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
if (tobj.getSymbolID()==0)
  {
    loadImage= true;
  }
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
if (tobj.getSymbolID()==0)
  {
    loadImage= false;
  }
 
   if (tobj.getSymbolID()==1)
  {
      black=255;
      tint(black);
     
  }
    if (tobj.getSymbolID()==2)
  {
  object_size = 200 ;

  }
  
}

// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}
