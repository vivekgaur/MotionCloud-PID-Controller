
import java.util.ArrayList;
import java.util.List;
import processing.net.*;
import processing.serial.*;

char START_CHAR = '~';
char END_CHAR = '%';
char NEWLINE = '\n';

Queue<IMUData> queue = new Queue<IMUData>();

// The enumeration should match with Arduino 
final int CALLIBRATION_MSG = 0;
final int EULER_MSG = 1;
final int ACCELEROMETER_MSG = 2;
final int QUATERNION_MSG = 3;
final int TEMPERATURE_MSG = 4;


int mode = 0; // "SERIAL";
//int mode = 1; //"TCP";
StringBuffer strBuffer = new StringBuffer();
// Sensitivity scale for movements 
float sensitivityScale = 1;//0.01;
int frameSensitivity = 10;
int AXIS_SCALE_FACTOR = 10;
int TOO_FAR = -300;
int TOO_CLOSE = 300;
Server server;
Serial serial;
// Main processing logic 
// The Above code will be refactored efficiently later 

double startx = 10;
double starty = 10;
double startz = 0;
int directionx = 1;
int directiony = 1;
int directionz = 1;

IMUData prevFrame;
Quaternion quat;
int frameCount = 0;
void setup() {
  size(800,600,P3D);  
  server = new Server(this, 8080);
  serial = new Serial(this, "/dev/tty.usbmodem1421", 9600);
  //  Store the number of data points  
  queue.setLimit(100);
  frameRate(100);
}

void draw() {
  background(0);
  fill(51);
  stroke(255);
  
  rotateX(PI);
  translate(0,-height,0);
  
  Object p =  readData();
  
  if (p instanceof IMUData) {
    if (prevFrame == null) prevFrame = (IMUData) p;
  
    if(p != null) { 
      drawMovement((IMUData) p);
      prevFrame = (IMUData) p;
    }
    
  } else if (p instanceof Quaternion) {
  } else if(prevFrame != null) drawMovement(prevFrame); 
  else {
  }
  
  
}

Object readData() {
 String str = getData();
 
 try {
   if(str != null && !str.equalsIgnoreCase("")) {
     println("Str :" + str);
     String[] IMUData =  str.split(",");
     switch(Integer.valueOf(IMUData[0])) {
        case  CALLIBRATION_MSG: 
               println(" System = " + Double.valueOf(IMUData[1]) + " Gyro = " + Double.valueOf(IMUData[2])  + 
                       " Accelerometer = " + Double.valueOf(IMUData[3])  + " Mag = " + Double.valueOf(IMUData[4]) + 
                       " Elapsed Time = " + Double.valueOf(IMUData[5]));
               // Do something with the CALLIBRATION Data 
               return null;
              
        case TEMPERATURE_MSG: 
               println(" Temperature = " + Double.valueOf(IMUData[1]) + 
                       " Elapsed Time = " + Double.valueOf(IMUData[2]));
               // Do something with the Temperature  Data 
               return null;
               
        case  QUATERNION_MSG: 
               println(" W = " + Double.valueOf(IMUData[1]) + " X = " + Double.valueOf(IMUData[2])  + 
                       " Y = " + Double.valueOf(IMUData[3])  + " Z = " + Double.valueOf(IMUData[4]) + 
                       " Elapsed Time = " + Double.valueOf(IMUData[5]));
               // Do something with the QUATERNION Data 
               /* return new Quaternion(Double.valueOf(IMUData[1]),
                        Double.valueOf(IMUData[2]),
                        Double.valueOf(IMUData[3]), 
                        Double.valueOf(IMUData[4]),
                        Long.valueOf(IMUData[5])); */
              return null;
        case  ACCELEROMETER_MSG: 
               println(" X = " + Double.valueOf(IMUData[1]) + " Y = " + Double.valueOf(IMUData[2])  + 
                       " Z = " + Double.valueOf(IMUData[3])  + 
                       " Elapsed Time = " + Double.valueOf(IMUData[4]));
               // Do something with the Accelerometer Data 
               return null;
               
        case  EULER_MSG: 
               println(" X = " + Double.valueOf(IMUData[1]) + " Y = " + Double.valueOf(IMUData[2])  + 
                       " Z = " + Double.valueOf(IMUData[3])  + 
                       " Elapsed Time = " + Double.valueOf(IMUData[4]));
               return new IMUData(Double.valueOf(IMUData[1]),
                        Double.valueOf(IMUData[2]),
                        Double.valueOf(IMUData[3]), 
                        Long.valueOf(IMUData[4]));
       default: 
              println("Invalid message, don't know how to process it !!!!");
              return null;
     }               
   }
   return null;
 }
 catch (Exception e) {
   println(e);
   return null;
 }
}


String getData() {
   
  if (mode == 1) {
    Client client = server.available();
  
    if(client != null) {
      return client.readString();
    }
  } else if (mode == 0) {
   
   
    boolean callibration_data = false;
    // Skip all the calibration information from the sensor and ignore them by just printing it on the screen 
    // this is help understand the start of actual data transmission 
    while(serial.available() > 0) {
       char inByte = (char ) serial.read();    
       if(inByte == START_CHAR) {
          continue;
       }
       else if(inByte == NEWLINE) {
         continue;
       }
       else if(inByte == END_CHAR) {
         // Reached end of line check if the data received is callibation data if yes print and skip
         String str = strBuffer.toString();
         strBuffer = new StringBuffer();
         if (callibration_data) { 
           println(str);
           return null;
         }
         else {
           
           return str;
         }
       } else strBuffer.append(inByte);
    }
    return null;
  }
  
  
  return null;
}
void draw3Dgraph(Quaternion q) {
  if (q != null) {
    pushMatrix();
    rotateX(radians(180));
    translate(0, height);
    point((float) q.x, (float) q.y, (float) q.z);
    popMatrix();
    
  }
}

void drawMovement(IMUData iMUData) {
 
    rectMode(CENTER);
    //println("Scale "  + millis() + " " + iMUData.getZ() / 100);
    //println(iMUData);
    //scale((float) iMUData.getZ() / 200);
    //rect((float) iMUData.getX(), (float) iMUData.getY(),  100,100);
    //scale(0);
    pushMatrix();
    translate(width/2, height/2);
    //rotateX(radians(180/2));
    //rotateZ(-PI/4);
    rotateX(radians((float) iMUData.getX() * sensitivityScale));
    rotateY(radians((float) iMUData.getY() * sensitivityScale));
    rotateZ(radians((float) iMUData.getZ() * sensitivityScale));
    box(100);
    popMatrix(); 
}

void drawVibrations(IMUData iMUData) {
    translate(width/2, -height/2);
    //rotateX(PI/2);
    rotateX((float) iMUData.getX() * sensitivityScale);
    rotateY((float) iMUData.getY() * sensitivityScale);
    rotateZ((float) iMUData.getZ() * sensitivityScale);
    line(0,0,100,100);
}