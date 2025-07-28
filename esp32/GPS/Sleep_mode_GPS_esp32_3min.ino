#include <WiFi.h>
#include <PubSubClient.h>
#include <WiFiClientSecure.h>
#include <SoftwareSerial.h>

// Configuration
const char* ssid = "Perfect-K";
const char* password = "Aqua0777#A";
const char* mqttServer = "006cdd2efa0e4690b47674aced123803.s1.eu.hivemq.cloud";
const int mqttPort = 8883;  // TLS port for HiveMQ Cloud
const char* topic = "IRIS/Tracking";
const char* mqttClientId = "006cdd2efa0e4690b47674aced123803";

// HiveMQ Cloud credentials
const char* mqttUsername = "hivemq.webclient.1751455473639";
const char* mqttPassword = "vN4kaFT:5zj0xG;.X8H?";

// WiFi and MQTT clients
WiFiClientSecure espClient;
PubSubClient client(espClient);

// SIM808 Configuration
HardwareSerial sim808(1);
const int RX_PIN = 16;
const int TX_PIN = 17;
const char* phone = "01147248877";

// Sleep configuration - CHANGED TO 3 MINUTES
#define SLEEP_TIME_SECONDS 180   // Sleep for 3 minutes (180 seconds)
#define MAX_GPS_ATTEMPTS 10      // Maximum attempts to get GPS fix
#define GPS_TIMEOUT 60000        // 60 seconds timeout for GPS fix

// Global variables
String latitude, longitude;
bool taskCompleted = false;

void setup() {
  Serial.begin(115200);
  delay(1000);
  Serial.println("\n\nStarting GPS Tracker (3-minute cycle mode)...");
  
  // Initialize SIM808
  initSim808();
  
  // Get GPS location with retries
  bool gpsSuccess = getGpsLocationWithRetries();
  
  if (gpsSuccess) {
    Serial.println("GPS fix obtained, proceeding with tasks...");
    
    // Connect to WiFi
    connectWiFi();
    
    // Setup MQTT with TLS
    espClient.setInsecure();
    client.setServer(mqttServer, mqttPort);
    connectMQTT();
    
    // Perform all tasks
    performAllTasks();
    
    Serial.println("All tasks completed successfully!");
  } else {
    Serial.println("Failed to get GPS fix after maximum attempts");
    // Still proceed to sleep and try again in 3 minutes
  }
  
  // Cleanup and prepare for sleep
  cleanup();
  
  // Enter deep sleep for 3 minutes
  enterDeepSleep();
}

void loop() {
  // This will never be reached due to deep sleep
  // But included for completeness
  delay(1000);
}

bool getGpsLocationWithRetries() {
  Serial.println("Attempting to get GPS fix...");
  
  for (int attempt = 1; attempt <= MAX_GPS_ATTEMPTS; attempt++) {
    Serial.printf("GPS attempt %d/%d\n", attempt, MAX_GPS_ATTEMPTS);
    
    gps_location();
    
    if (latitude.length() > 5 && longitude.length() > 5) {
      Serial.printf("GPS fix obtained on attempt %d\n", attempt);
      return true;
    }
    
    if (attempt < MAX_GPS_ATTEMPTS) {
      Serial.println("Waiting 10 seconds before next GPS attempt...");
      delay(10000);
    }
  }
  
  return false;
}

void performAllTasks() {
  // Task 1: Send SMS with location
  Serial.println("=== Task 1: Sending SMS ===");
  sms_send();
  delay(2000);  // Brief delay between tasks
  
  // Task 2: Make call
  Serial.println("=== Task 2: Making call ===");
  make_call();
  delay(2000);
  
  // Task 3: Send to MQTT server
  Serial.println("=== Task 3: Publishing to MQTT ===");
   // Create Google Maps link
      String googleMapsLink = "https://maps.google.com/?q=" + latitude + "," + longitude;
      
      // Publish to MQTT with Google Maps link
      String msg = "{\"lat\": \"" + latitude + "\", \"lon\": \"" + longitude + "\", \"maps_link\": \"" + googleMapsLink + "\"}";
  
  // Retry MQTT publish up to 3 times
  bool mqttSuccess = false;
  for (int i = 0; i < 3; i++) {
    if (client.connected() && client.publish(topic, msg.c_str())) {
      Serial.println("MQTT published successfully: " + msg);
      mqttSuccess = true;
      break;
    } else {
      Serial.printf("MQTT publish attempt %d failed, retrying...\n", i + 1);
      if (!client.connected()) {
        connectMQTT();
      }
      delay(1000);
    }
  }
  
  if (!mqttSuccess) {
    Serial.println("Failed to publish to MQTT after 3 attempts");
  }
  
  taskCompleted = true;
}

void cleanup() {
  Serial.println("Performing cleanup...");
  
  // Disconnect MQTT
  if (client.connected()) {
    client.disconnect();
  }
  
  // Disconnect WiFi
  WiFi.disconnect(true);
  WiFi.mode(WIFI_OFF);
  
  // Power down GPS
  sendATCommand("AT+CGNSPWR=0", "OK", 3000);
  
  // Put SIM808 to sleep mode (optional)
 // sendATCommand("AT+CSCLK=2", "OK", 3000);  // Enable auto sleep mode
  
  Serial.println("Cleanup completed");
}

void enterDeepSleep() {
  Serial.printf("Entering deep sleep for %d seconds (3 minutes)...\n", SLEEP_TIME_SECONDS);
  Serial.println("Device will restart after sleep period and repeat the cycle");
  Serial.flush();  // Ensure all serial output is sent
  
  // Configure wake up timer
  esp_sleep_enable_timer_wakeup(SLEEP_TIME_SECONDS * 1000000ULL);  // Convert to microseconds
  
  // Enter deep sleep
  esp_deep_sleep_start();
}

void initSim808() {
  Serial.println("Initializing SIM808 module...");
  sim808.begin(9600, SERIAL_8N1, RX_PIN, TX_PIN);
  delay(3000);  // Give more time for module initialization
  
  // Send test AT command with retries
  bool sim808Ready = false;
  for (int i = 0; i < 5; i++) {
    if (sendATCommand("AT", "OK", 3000)) {
      Serial.println("SIM808 is responsive");
      sim808Ready = true;
      break;
    }
    Serial.printf("SIM808 not responding, attempt %d/5\n", i + 1);
    delay(2000);
  }
  
  if (!sim808Ready) {
    Serial.println("Warning: SIM808 failed to respond after 5 attempts");
  }
  
  // Power on GPS with retry
  Serial.println("Powering GPS...");
  for (int i = 0; i < 3; i++) {
    if (sendATCommand("AT+CGNSPWR=1", "OK", 3000)) {
      break;
    }
    delay(1000);
  }
  
  // Set GPS output format
  sendATCommand("AT+CGNSSEQ=\"RMC\"", "OK", 3000);
  delay(2000);  // Give GPS time to start up
}

void connectWiFi() {
  Serial.print("Connecting to WiFi");
  WiFi.begin(ssid, password);
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 40) {
    delay(500);
    Serial.print(".");
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\nWiFi connected");
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println("\nWiFi connection failed");
  }
}

void connectMQTT() {
  Serial.print("Connecting to MQTT broker");
  
  int attempts = 0;
  while (!client.connected() && attempts < 5) {
    Serial.print(".");
    
    String clientId = String(mqttClientId) + String(random(10000));
    
    if (client.connect(clientId.c_str(), mqttUsername, mqttPassword)) {
      Serial.println("\nConnected to HiveMQ Cloud");
    } else {
      Serial.print("Failed: ");
      Serial.print(client.state());
      Serial.println(" - retrying in 2s");
      delay(2000);
      attempts++;
    }
  }
  
  if (!client.connected()) {
    Serial.println("\nMQTT connection failed after 5 attempts");
  }
}

void sms_send() {
  Serial.println("Sending SMS...");
  
  // Set SMS text mode
  if (!sendATCommand("AT+CMGF=1", "OK", 2000)) {
    Serial.println("Failed to set SMS text mode");
    return;
  }
  
  // Set recipient number
  sim808.print("AT+CMGS=\"");
  sim808.print(phone);
  sim808.println("\"");
  delay(1000);
  
  // SMS content
  sim808.print("GPS Location Alert!\n");
  sim808.print("Latitude: ");
  sim808.println(latitude);
  sim808.print("Longitude: ");
  sim808.println(longitude);
  sim808.print("Time: ");
  sim808.println(millis());
  delay(500);
  
  // End SMS with Ctrl+Z
  sim808.write(26);
  delay(5000);
  
  Serial.println("SMS sent");
}

void make_call() {
  Serial.println("Making call...");
  
  // Make a call
  sim808.print("ATD");
  sim808.print(phone);
  sim808.println(";");
  
  delay(10000);  // Call duration
  
  // Hang up
  sendATCommand("ATH", "OK", 2000);
  
  Serial.println("Call completed");
}

void gps_location() {
  Serial.println("Requesting GPS data...");
  
  // Clear old data
  latitude = "";
  longitude = "";
  
  // Clear input buffer
  while (sim808.available()) {
    sim808.read();
  }
  
  // Request GPS info
  sim808.println("AT+CGNSINF");
  
  // Read response with timeout
  String gpsData = readResponse(5000);
  Serial.println("Raw GPS Data: " + gpsData);
  
  // Parse GPS data
  if (parseGpsData(gpsData)) {
    Serial.println("GPS data parsed successfully");
  } else {
    Serial.println("Failed to parse GPS data or no GPS fix");
  }
}

bool parseGpsData(String gpsData) {
  int startIndex = gpsData.indexOf("+CGNSINF: ");
  if (startIndex == -1) {
    Serial.println("GPS data format error: +CGNSINF not found");
    return false;
  }
  
  String dataSection = gpsData.substring(startIndex + 10);
  
  int commaPositions[10];
  int commaCount = 0;
  
  int searchPos = 0;
  for (int i = 0; i < 6 && searchPos < dataSection.length(); i++) {
    searchPos = dataSection.indexOf(',', searchPos);
    if (searchPos == -1) break;
    commaPositions[commaCount++] = searchPos;
    searchPos++;
  }
  
  if (commaCount < 5) {
    Serial.println("GPS data format error: not enough data sections");
    return false;
  }
  
  int runStatus = dataSection.substring(0, commaPositions[0]).toInt();
  int fixStatus = dataSection.substring(commaPositions[0] + 1, commaPositions[1]).toInt();
  
  if (fixStatus != 1) {
    Serial.println("No GPS fix available");
    return false;
  }
  
  latitude = dataSection.substring(commaPositions[2] + 1, commaPositions[3]);
  longitude = dataSection.substring(commaPositions[3] + 1, commaPositions[4]);
  
  if (latitude.length() < 4 || longitude.length() < 4) {
    Serial.println("Invalid coordinates received");
    return false;
  }
  
  Serial.println("Latitude: " + latitude);
  Serial.println("Longitude: " + longitude);
  return true;
}

bool sendATCommand(const char* command, const char* expectedResponse, unsigned long timeout) {
  Serial.print("Sending: ");
  Serial.println(command);
  
  sim808.println(command);
  
  String response = readResponse(timeout);
  
  if (response.indexOf(expectedResponse) != -1) {
    Serial.println("Response OK");
    return true;
  } else {
    Serial.print("Expected: ");
    Serial.println(expectedResponse);
    Serial.print("Got: ");
    Serial.println(response);
    return false;
  }
}

String readResponse(unsigned long timeout) {
  String response = "";
  unsigned long startTime = millis();
  
  while (millis() - startTime < timeout) {
    if (sim808.available()) {
      char c = sim808.read();
      response += c;
    }
    
    if (response.length() > 0 && !sim808.available()) {
      unsigned long startWait = millis();
      while (millis() - startWait < 500) {
        if (sim808.available()) {
          break;
        }
        delay(10);
      }
      if (!sim808.available()) {
        break;
      }
    }
  }
  
  return response;
}
