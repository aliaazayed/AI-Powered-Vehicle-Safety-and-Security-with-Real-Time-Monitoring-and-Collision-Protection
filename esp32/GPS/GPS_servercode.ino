
#include <SoftwareSerial.h>
#include <WiFi.h>
#include <PubSubClient.h>

const char* ssid = "WE_35C004";
const char* password = "qa650858";

const char* mqttServer = "broker.hivemq.com";
const int mqttPort = 1883;
const char* topic = "aya/distance";

WiFiClient espClient;
PubSubClient client(espClient);
char phone[] = "01018246498";

SoftwareSerial sim808(16, 17);  // RX, TX

String latitude, longitude;

void setup() {
  Serial.begin(9600);
  sim808.begin(9600);

  sim808.println("AT+CGNSPWR=1");
  delay(2000);
  sim808.println("AT+CGNSSEQ="RMC"");
  delay(2000);

  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi connected");

  client.setServer(mqttServer, mqttPort);
  Serial.print("Connecting to MQTT");
  while (!client.connected()) {
    Serial.print(".");
    if (client.connect("ESP32ClientAya")) {
      Serial.println("\nConnected to MQTT broker");
    } else {
      Serial.print("Failed: ");
      Serial.println(client.state());
      delay(1000);
    }
  }
}

void loop() {
  gps_location();

  if (latitude.length() > 5 && longitude.length() > 5) {
    sms_send();
    String msg = "{\"lat\": \"" + latitude + "\", \"lon\": \"" + longitude + "\"}";
    client.publish(topic, msg.c_str());
    Serial.println("MQTT published: " + msg);
  } else {
    Serial.println("Skipping MQTT and SMS — invalid data.");
  }

  client.loop();
  delay(5000);
}

void sms_send() {
  sim808.println("AT+CMGF=1");
  delay(100);
  sim808.print("AT+CMGS=\"");
  sim808.print(phone);
  sim808.println("\"");
  delay(1000);
  sim808.print("latitude = ");
  sim808.println(latitude);
  sim808.print(",");
  sim808.print("longitude = ");
  sim808.println(longitude);
  delay(500);
  sim808.println((char)26);  // Ctrl+Z to send SMS
  delay(100);
  Serial.println("Message is sent");
  delay(100);
}

void gps_location() {
  latitude = "";
  longitude = "";

  sim808.flush();
  sim808.println("AT+CGNSINF");

  String gpsData = "";
  long timeout = millis();
  while (millis() - timeout < 2000) {
    while (sim808.available()) {
      gpsData += (char)sim808.read();
    }
  }

  Serial.println("Raw GPS Data: " + gpsData);

  int start = gpsData.indexOf("+CGNSINF: ");
  if (start == -1) return;

  gpsData = gpsData.substring(start + 10);

  String fix = gpsData.substring(9, 10);
  if (fix != "1") {
    Serial.println("Waiting for GPS fix...");
    return;
  }

  int latIndex = nthIndexOf(gpsData, ',', 3);
  int latEnd = nthIndexOf(gpsData, ',', 4);
  int lonIndex = nthIndexOf(gpsData, ',', 4);
  int lonEnd = nthIndexOf(gpsData, ',', 5);

  if (latIndex == -1 || latEnd == -1 || lonIndex == -1 || lonEnd == -1) {
    Serial.println("GPS data incomplete");
    return;
  }

  latitude = gpsData.substring(latIndex + 1, latEnd);
  longitude = gpsData.substring(lonIndex + 1, lonEnd);

  Serial.println("latitude = " + latitude);
  Serial.println("longitude = " + longitude);
}

int nthIndexOf(String str, char c, int n) {
  int pos = -1;
  for (int i = 0; i < n; i++) {
    pos = str.indexOf(c, pos + 1);
    if (pos == -1) break;
  }
  return pos;
}
