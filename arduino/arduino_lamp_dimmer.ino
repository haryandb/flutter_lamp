#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

/* Put your SSID & Password */
const char *ssid = "NodeMCU";      // Enter SSID here
const char *password = "12345678"; //Enter Password here

/* Put IP Address details */
IPAddress local_ip(192, 168, 2, 1);
IPAddress gateway(192, 168, 2, 1);
IPAddress subnet(255, 255, 255, 0);

ESP8266WebServer server(80);

uint8_t LEDpin = D1;

void setup()
{
  Serial.begin(9600);
  pinMode(LEDpin, OUTPUT);

  WiFi.softAP(ssid, password);
  // WiFi.softAPConfig(local_ip, gateway, subnet);
  delay(100);

  server.on("/lamp", handleSpecificArg); //Associate the handler function to the path

  server.begin();
}

void loop()
{
  server.handleClient();
}

void handleSpecificArg()
{
  String message = "";
  String value = server.arg("value");
  if (value == "")
  {
    message = "Lamp value not found";
  }
  else
  {
    message = "Lamp value = ";
    message += value;
    if (value.toInt() >= 0 && value.toInt() <= 255)
    {
      float persent = value.toFloat() / 255.0;
      float lampu = 1024.0 * persent;
      Serial.println(lampu);
      analogWrite(LEDpin, (int)lampu);
    }
  }
  server.send(200, "text/plain", message);
}