// Test code for Grove - Moisture Sensor 
int sensorPin = A0; // select the input pin for the potentiometer
int sensorValue = 0; // variable to store the value coming from the sensor7

void setup() {
    // declare the ledPin as an OUTPUT:
    Serial.begin(9600);
}
void loop() {
    // read the value from the sensor:
    sensorValue = analogRead(sensorPin);
    // Write the value into the Serial line to be read by the 
    // UNO
    Serial.write(sensorValue);
 //   Serial.print("sensor = " );
 //   Serial.println(sensorValue);
 // Delay to give the UNO a chance to receive the data before sending again
    delay(1000);
}
