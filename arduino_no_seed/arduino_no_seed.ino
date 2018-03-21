#include <SimpleDHT.h>
#define dht_apin A1

#include <Servo.h>
Servo myServo;
// variable to hold sensor value
int sensorValue;
// variable to calibrate low value
int sensorLow;
// variable to calibrate high value
int sensorHigh;
// LED pin
const int ledPin = 13;
SimpleDHT11 dht11;
int angle;
int moistureValue;
const int motorPin = 9;
const int drySoil = 100;
    byte temperature;
  byte humidity;

void setup() {
  // Make the LED pin an output and turn it on
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
 // myServo.attach(8);

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
  
  //moistureValue = Serial.read();
  //Then print it out (also sends it on the Serial for processing)
 // Serial.print("Moisture value is: ");
 // Serial.println(moistureValue);
  //read the input from the light sensor and store it in a variable
  sensorValue = analogRead(A0);
  // Then print it to the Serial console
  Serial.print("a");
  Serial.println(sensorValue);
  // If the soil isn't wet enough, turn the "Sprinkler" on
  checkMotor();
  
  // Declare the start values for the humidty sensor

  int err = SimpleDHTErrSuccess;
  //dht11.read is the function to read in the values, just printing at the moment
  if ((err = dht11.read(dht_apin, &temperature, &humidity, NULL)) != SimpleDHTErrSuccess) {
   // Serial.print("Read DHT11 failed, err="); Serial.println(err);delay(1000);
   // return;
  }

  // Print out the temperature and the humidity
  //Serial.print("Sample OK: "); // This can be deleted once we are reading into processing
  Serial.print("a");
  Serial.println((int)temperature);
  Serial.print("a");// Serial.print(" *C, "); 
  Serial.println((int)humidity);// Serial.println(" H");
  
  
  // has to be 2 seconds or the dht won't work properly
  delay(2000);
}

void checkMotor()
{
  if(moistureValue > drySoil)
  {
 //   digitalWrite(motorPin, HIGH);
  }
  else
  {
//    digitalWrite(motorPin, LOW);
  }
}

