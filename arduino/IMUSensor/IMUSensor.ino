#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

#define START_CHAR "~"
#define END_CHAR "%"

#define MSG_START()     Serial.print(START_CHAR);
#define MSG_FIELD(x, y) Serial.print(x); if(y) Serial.print(",");
#define MSG_END()       Serial.print(END_CHAR);

enum MSG_TYPE {CALLIBRATION_MSG, EULER_MSG, ACCELEROMETER_MSG, QUATERNION_MSG, TEMPERATURE_MSG};

unsigned long StartTime = millis();

unsigned long startTimes[] = {
  StartTime, StartTime, StartTime, StartTime, StartTime, StartTime
};
// Turn on and off any message you want by setting the array below, default all messages are sent 

boolean messageMasks[] = {true, true, false, true, false};

/* Set the delay between fresh samples */
#define BNO055_SAMPLERATE_DELAY_MS (100)

Adafruit_BNO055 bno = Adafruit_BNO055();

unsigned long startTime = millis();
/**************************************************************************/
/*
    Arduino setup function (automatically called at startup)
*/
/**************************************************************************/
void setup(void)
{
  Serial.begin(9600);
  Serial.println("Orientation Sensor Raw Data Test"); Serial.println("");

  /* Initialise the sensor */
  if(!bno.begin())
  {
    /* There was a problem detecting the BNO055 ... check your connections */
    Serial.print("Ooops, no BNO055 detected ... Check your wiring or I2C ADDR!");
    while(1);
  }
  Serial.println("After orientation sensor ");
  delay(1000);
 
  bno.setExtCrystalUse(true);

  //Serial.println("Calibration status values: 0=uncalibrated, 3=fully calibrated");
}

/**************************************************************************/
/*
    Arduino loop function, called once 'setup' is complete (your own code
    should go here)
*/
/**************************************************************************/
void loop(void)
{
  // Possible vector values can be:
  // - VECTOR_ACCELEROMETER - m/s^2
  // - VECTOR_MAGNETOMETER  - uT
  // - VECTOR_GYROSCOPE     - rad/s
  // - VECTOR_EULER         - degrees
  // - VECTOR_LINEARACCEL   - m/s^2
  // - VECTOR_GRAVITY       - m/s^2

  
  imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_EULER);
  imu::Vector<3> accelVector = bno.getVector(Adafruit_BNO055::VECTOR_ACCELEROMETER);
  imu::Quaternion quat = bno.getQuat();
  int8_t temp = bno.getTemp();
  //sendTemperatureMessage(temp);
 
  uint8_t system, gyro, accel, mag = 0;
  bno.getCalibration(&system, &gyro, &accel, &mag);
  
 
 // All of callibration values  has to be 3 for accurate data, however for tracking hand this should 
 // be enough 
 // Still having trouble callibrating the accelerometer 
 // Accelerometer takes time to callibrate, dont send the accelerometer data unless fully callibrated 
 
 if (system >= 2 && gyro > 2 && accel >= 0 && mag > 2) {
    sendXMessage(EULER_MSG, euler);
    sendQuaternionMessage(quat);
    if(accel == 3) sendXMessage(ACCELEROMETER_MSG, accelVector);
 } else {
    sendCallibrationMessage(system , gyro, accel, mag);
 }
 sendTemperatureMessage(temp);
 delay(BNO055_SAMPLERATE_DELAY_MS);
}

void sendQuaternionMessage(imu::Quaternion quat) {
  
  if(!messageMasks[QUATERNION_MSG]) return;
    
  MSG_START();
  MSG_FIELD(QUATERNION_MSG, true);
  MSG_FIELD(quat.w(), true);
  MSG_FIELD(quat.x(), true);
  MSG_FIELD(quat.y(), true);
  MSG_FIELD(quat.z(), true);
  MSG_FIELD(elapsedTime(QUATERNION_MSG), false);
  MSG_END(); 
}

void sendXMessage(MSG_TYPE msgType, imu::Vector<3> msg) {
  
  if(!messageMasks[msgType]) return;
  
  MSG_START();
  MSG_FIELD(msgType, true);
  MSG_FIELD(msg.x(), true);
  MSG_FIELD(msg.y(), true);
  MSG_FIELD(msg.z(), true);
  MSG_FIELD(elapsedTime(msgType), false);
  MSG_END(); 
}
void sendCallibrationMessage(uint8_t system, uint8_t gyro, uint8_t accel, uint8_t mag) {
   // Print the callibration data only when not calibrated 
  if(!messageMasks[CALLIBRATION_MSG]) return;
  
  MSG_START();
  MSG_FIELD(CALLIBRATION_MSG, true);
  MSG_FIELD(system, true);
  MSG_FIELD(gyro, true);
  MSG_FIELD(accel, true);
  MSG_FIELD(mag, true);
  MSG_FIELD(elapsedTime(CALLIBRATION_MSG), false);
  MSG_END();
}
void sendTemperatureMessage(int8_t temp) {
  if(!messageMasks[TEMPERATURE_MSG]) return;
  MSG_START();
  MSG_FIELD(TEMPERATURE_MSG, true);
  MSG_FIELD(temp, true);
  MSG_FIELD(elapsedTime(TEMPERATURE_MSG), false);
  MSG_END();
}

unsigned long elapsedTime(MSG_TYPE msgType) {
  unsigned long CurrentTime = millis();
  unsigned long elapsedTime = CurrentTime - startTimes[msgType];
  startTimes[msgType] = CurrentTime;
  return elapsedTime;
}



