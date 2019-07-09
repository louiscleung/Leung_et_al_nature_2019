//Relay program for single relay
long waitInterval;
long delayInterval;
long onOffInterval;
long randNumber;
int relayPin = 8;// use 13 in setup so you can see the output on LED.

void setup() {
  
  pinMode(relayPin, OUTPUT);
  
}

void loop() {
  //random number of strikes
  randNumber = random(2,10); 
  for (int i=0; i<=randNumber; i++) {
     //actuator strike
     digitalWrite(relayPin, HIGH);
     //random interstrike intervals
     onOffInterval = random(400,700); 
     delay(onOffInterval); 
     //actuator retract
     digitalWrite(relayPin, LOW);
     delayInterval=random(100,250);
     delay(delayInterval);
  }
  
  //random gap between strike bouts
  waitInterval=random(30000,45000); 
  delay(waitInterval); 
}
