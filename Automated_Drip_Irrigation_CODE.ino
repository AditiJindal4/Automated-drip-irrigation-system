#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

const int sensorPin=A0;
LiquidCrystal_I2C lcd(0x27,16,2);
//connect sda of lcd to a4 and scl to a5//*

void setup()
{
  pinMode(13,OUTPUT);
  lcd.init();
  lcd.backlight(); 
  Serial.begin(9600);
  pinMode(sensorPin, INPUT);
  digitalWrite(13,LOW);
}

void loop()
{
  int sensorValue;
  
  sensorValue = analogRead(sensorPin);
  sensorValue=map(sensorValue,1023,0,0,100);
  lcd.setCursor(1,0);
  lcd.print("Moisture: ");
  lcd.print(sensorValue);
  lcd.print("                 ");
  lcd.setCursor(1,1);
  
  Serial.print("moisture:");
  Serial.print(sensorValue);
  Serial.println("%");
  
  if (sensorValue>=20 && sensorValue<=40)
  {
    Serial.println("this plant is watered properly");
    lcd.print("watering          ");
    delay(500);
    digitalWrite(13,HIGH);
  } 

   if (sensorValue>=40 && sensorValue<=55)
  {
    Serial.println("this plant is watered properly");
    lcd.print("watered          ");
    delay(500);
    digitalWrite(13,LOW);
  } 
  
  else if (sensorValue>55)
  { 
      Serial.println("this plant is overwatered");
      lcd.print("overwatered        ");
      delay(500);
      digitalWrite(13,LOW);
  } 
  else if(sensorValue<15) 
  {
      Serial.println("this plant is thirsty");
      lcd.print("thirsty          ");
      delay(500);
      digitalWrite(13,HIGH);
  }
   delay(1000);
}
