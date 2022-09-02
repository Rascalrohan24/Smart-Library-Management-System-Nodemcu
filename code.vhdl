#include <LiquidCrystal_I2C.h>

#include <ESP8266WiFi.h>
#include<Wire.h>

 
String apiKey = "ZBE86I39N97CADRV";     //  Enter your Write API key from ThingSpeak
 
const char *ssid =  "kankitjha";  // name of your wifi
const char *pass =  "kankitjha";  // password of your wifi
const char* server = "api.thingspeak.com";
 
int pir_sensor =  D1; 
int pir_sensor2 =  D2;
LiquidCrystal_I2C lcd(0x27, 16, 2);
 
WiFiClient client;
 
void setup() 
{
       Serial.begin(115200);
       delay(10);
       pinMode(pir_sensor,INPUT);
       pinMode(pir_sensor2,INPUT);
       lcd.begin();
       
       Serial.println("Connecting to ");
       Serial.println(ssid);
 
       WiFi.begin(ssid, pass);
 
      while (WiFi.status() != WL_CONNECTED) 
     {
            delay(500);
            Serial.print(".");
     }
      Serial.println("");
      Serial.println("WiFi connected");
 
}
 
void loop() 
{
  
int pir = digitalRead(pir_sensor);
int pir2 = digitalRead(pir_sensor2);
int count1=0,count2=0,final;

if(pir==HIGH)count1++;
if(pir2==HIGH)count2++;
final=abs(count1-count2);
lcd.print(final);

   
   if (client.connect(server,80))   //   "184.106.153.149" or api.thingspeak.com
    {  
      
      String postStr = apiKey;
       
       postStr +="&field1=";
       postStr += String(pir);
       
       
       postStr +="&field2=";
       postStr += String(pir2);

       postStr +="&field3=";
       postStr += String(final);
       

       postStr +="&field4=";
       postStr += String(count1);
       
       
       postStr +="&field5=";
       postStr += String(count2);
       postStr += "\r\n\r\n";
       

       client.print("POST /update HTTP/1.1\n");
       client.print("Host: api.thingspeak.com\n");
       client.print("Connection: close\n");
       client.print("X-THINGSPEAKAPIKEY: "+apiKey+"\n");
       client.print("Content-Type: application/x-www-form-urlencoded\n");
       client.print("Content-Length: ");
       //client.print(postStr.length());
       
       client.print("\n\n");
       client.print(postStr);

       Serial.print("motion : ");
       Serial.print(pir);
       Serial.println(" , incoming..");
       
       Serial.print("motion : ");
       Serial.print(pir2);
       Serial.println(" , outgoing..");
    }
   client.stop();
  
  // thingspeak needs minimum 15 sec delay between updates
  delay(1000);
}