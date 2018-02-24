#include <SimpleDHT.h>
#define dht_apin A1
/*
  Arduino Starter Kit example
  Project 6 - Light Theremin

  This sketch is written to accompany Project 6 in the Arduino Starter Kit

  Parts required:
  - photoresistor
  - 10 kilohm resistor
  - piezo

  created 13 Sep 2012
  by Scott Fitzgerald

  http://www.arduino.cc/starterKit

  This example code is part of the public domain.
*/

#include <Servo.h>
Servo myServo;
// variable to hold sensor value
int sensorValue;
// variable to calibrate low value
int sensorLow = 1023;
// variable to calibrate high value
int sensorHigh = 0;
// LED pin
const int ledPin = 13;
SimpleDHT11 dht11;
int angle;
int moistureValue;

void setup() {
  // Make the LED pin an output and turn it on
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
  myServo.attach(8);

  // calibrate for the first five seconds after program runs
  while (millis() < 5000) {
    // record the maximum sensor value
    sensorValue = analogRead(A0);
    if (sensorValue > sensorHigh) {
      sensorHigh = sensorValue;
    }
    // record the minimum sensor value
    if (sensorValue < sensorLow) {
      sensorLow = sensorValue;
    }
  }
  // turn the LED off, signaling the end of the calibration period
  digitalWrite(ledPin, LOW);
  Serial.begin(9600);
}

void loop() {
  // First read the value from the grove sensor using Serial
  moistureValue = Serial.read();
  //Then print it out (also sends it on the Serial for processing)
  Serial.print("Moisture value is: ");
  Serial.println(moisterValue);
  //read the input from the light sensor and store it in a variable
  sensorValue = analogRead(A0);
  // Then print it to the Serial console
  Serial.print("snesVal: ");
  Serial.println(sensorValue);

  // Declare the start values for the humidty sensor
    byte temperature = 0;
  byte humidity = 0;
  int err = SimpleDHTErrSuccess;
  //dht11.read is the function to read in the values, just printing at the moment
  if ((err = dht11.read(dht_apin, &temperature, &humidity, NULL)) != SimpleDHTErrSuccess) {
    Serial.print("Read DHT11 failed, err="); Serial.println(err);delay(1000);
    return;
  }

  // Print out the temperature and the humidity
  Serial.print("Sample OK: "); // This can be deleted once we are reading into processing
  Serial.print((int)temperature); Serial.print(" *C, "); 
  Serial.print((int)humidity); Serial.println(" H");
  
  
  // wait for a moment
  delay(2000);
}
