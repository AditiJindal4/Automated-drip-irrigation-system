#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

const int sensorPin=A0;                           //A0 is the input pin for the soil moisture sensor//
const int motorPin=13;                            //digital 13 is the output pin for the motor//
LiquidCrystal_I2C lcd(0x27,16,2);                 //connect SDA of LCD to A4 and SCL to A5//

void setup()
{
  pinMode(motorPin,OUTPUT);                      // setup motorPin as output//
  pinMode(sensorPin, INPUT);                    // set up sensorPin as input//
  lcd.init();                                   // initialize LCD//
  lcd.backlight();                              // setup LCD backlight//
  Serial.begin(9600);                           //setup serial monitor//
  digitalWrite(13,LOW);                         // initialize motor by keeping it off//
}

void loop()
{
  int sensorValue;                              //sensorValue- a variable to store input value of the sensor //
  
  sensorValue = analogRead(sensorPin);          // read the input value of the sensor //
  sensorValue=map(sensorValue,1023,0,0,100);    // input value are 1023-0 hence mapped them to 0-100 range//
  lcd.setCursor(1,0);                           // set cursor of lcd to 1st column and 0 row//
  lcd.print("Moisture: ");                      // print moisture on lcd//
  lcd.print(sensorValue);
  lcd.print("                 ");
  lcd.setCursor(1,1);                           // set cursor of lcd to 1st column and 1st row//
  
  Serial.print("moisture:");                    // print moisture on serial monitor if connected to the laptop //
  Serial.print(sensorValue);
  Serial.println("%");
  
  if (sensorValue>=20 && sensorValue<=55)
  {
    Serial.println("this plant is watered properly");
    lcd.print("watered    ");
    delay(500);
    digitalWrite(motorPin,LOW);                 // keep motor off as water isnt needed//
  } 
  
  else if (sensorValue>55)
  { 
      Serial.println("this plant is overwatered");
      lcd.print("overwatered");
      delay(500);
      digitalWrite(motorPin,LOW);              // keep motor off as water isnt needed//
  } 
  else if(sensorValue<20) 
  {
      Serial.println("this plant is thirsty");
      lcd.print("thirsty    ");
      delay(500);
      digitalWrite(motorPin,HIGH);            // switch motor on as plants need more water //
  }
   delay(1000);                               // taking input every second//
}
