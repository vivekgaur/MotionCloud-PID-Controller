# IMUSensor


#### Experiment with IMU Sensor 

There are two folders in this project 

````

processing 
arduino 

````


### Processing 

####  IMUData.java	

Java helper class to store euler angles (or generically Quateranion ) from 9DOF sensors 


#### IMUTest.pde	

Main Processing sketch which listens on Socket or Serial interface to obtain IMUData from the sensor 

#### Queue.java
Queue class (helper class)to store the all the IMUData with a limit



### Arduino 

#### IMUSensor.pde 

IMUSensor BN005 transmitting data through serial interface after successfull callobration 







