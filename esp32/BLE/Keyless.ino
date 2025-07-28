/*
 * Date : 5 July 2025
 */
/*   Library    */
#include <NimBLEDevice.h>
#include <EEPROM.h>
#include "mbedtls/aes.h" 
#include <WiFi.h> 
#include <HTTPClient.h>

/* WiFi Info */
const char* ssid = "Aya Ramadan";
const char* password = "ayaramadan22";
/* Azure Storage Blob URL with SAS Token */
/*Send Usar And Action History*/
const char* azureBlobUrl = 
"https://espconfigs123.blob.core.windows.net/esp32/User_History.json?sp=aw&st=2025-07-02T16:14:16Z&se=2025-07-30T00:14:16Z&spr=https&sv=2024-11-04&sr=b&sig=6X0BpcOlkIhDuxCdzWI89CaN3zLYpTlEKdMXr%2B5tnFA%3D&comp=appendblock";
/*Receive Keys*/
const char* blobUrl =
"https://espconfigs123.blob.core.windows.net/keys-container/carkey.txt?sp=racwdyti&st=2025-07-05T15:01:46Z&se=2025-07-29T23:01:46Z&spr=https&sv=2024-11-04&sr=b&sig=d%2FrNjb6ZbESVQGGnHZo9TsiWZoFIg141MRtGP9sVmeQ%3D"; 

/*   Services  */
#define ACTION_CONTROL_SERVICE_UUID    "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define KEY_CONTROL_SERVICE_UUID       "d90ae11e-0fcf-465e-9345-23b2860a8222"
/* Action Control characterisitic */
#define DOOR_UUID                      "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define Trunk_UUID                    "39143cb9-215a-4b35-87f1-34fc317df350"
/* Key Control characterisitics */
#define ENTER_KEY_UUID                 "86b5eacb-e6d0-479c-98fd-a7a6ef66a1ba"
/* EEPROM */
#define EEPROM_SIZE                    512
/* KEY specification */
#define KEY_COUNT                      85
#define KEY_LENGTH                     6
/* Door State */
#define DOOR_UNLOCK                    "1"
#define DOOR_LOCK                      "0"
/* Bag State */
#define BAG_UNLOCK                     "3"
#define BAG_LOCK                       "2"
/* UART */
#define UART_RX                         16
#define UART_TX                         17
/*-------------------------------------------------------------------------------------------------------------------*/
/* Variables */
String DoorState="" ,BagState="", User="",action="" ;
bool once_user=false,fetchedKeysOnce = false;
bool deviceConnected = false,authintication = false;
short int UserNumber=0,frist_control=0;
NimBLECharacteristic *pDoorCharacteristic =NULL ,*pBagCharacteristic=NULL  ,*pEnterCharacterisitic=NULL;
static NimBLEServer* pServer;
/* Functions */
/*-------------------------------------------------------------------------------------------------------------------*/
/* WiFi Connection Function */ 
void ConnectToWiFi() {
 WiFi.begin(ssid, password); 
while (WiFi.status() != WL_CONNECTED) 
{ 
  delay(500); 
}  
}
/*-------------------------------------------------------------------------------------------------------------------*/
/*Function to send user to Azure Blob */
void sendUserToAzure(String user, String action) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(azureBlobUrl);

    http.addHeader("Content-Type", "application/json");

    String payload = "[{\"user\":\"" + user + "\" , \"action\":\"" + action + "\"}]\n"; /* After every user new line */

    int httpResponseCode = http.sendRequest("PUT", (uint8_t *)payload.c_str(), payload.length());
    http.end();
  } 
  }
}
/*-------------------------------------------------------------------------------------------------------------------*/
void readKeysFromAzureAndSave() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(blobUrl);  
    
    int httpCode = http.GET();
    if (httpCode > 0) 
    {
      String payload = http.getString();

      int keyIndex = 0;
      int start = 0;
      
      while (start < payload.length()) 
      {
        int end = payload.indexOf('\n', start);
        if (end == -1) 
          {
            end = payload.length();
          }
        String key = payload.substring(start, end);
        key.trim();

        if (key.length() > 0 )
        {
          key = "\"" + key + "\"";  

          if( ! IsKeyExists (key))
          {
            Add_Key(key);
          }
          keyIndex++;
        }
        start = end + 1;
      }
      EEPROM.commit();
    } 
    http.end();
  } 
}

/*-------------------------------------------------------------------------------------------------------------------*/
void clear_eeprom()
{
  for(int i=0;i< EEPROM_SIZE ;i++)
  {
    EEPROM.write(i , 0);
  }
  EEPROM.commit();
}
/*------------------------------------------------------------------------------------------------------------------*/
/*function to check that Key is found or not*/
bool IsKeyExists ( String key)
{
  for(int i=0; i< UserNumber;++i)
  {
    String storedKey = ReadKeyFromEeprom(i); 
    if( storedKey == key)
    { 
      return true;
    }   
  }
  return false;
}

/*------------------------------------------------------------------------------------------------------------------*/
/*function to write  New KEY in EEPROM in didicated address*/
void WriteKeyToEeprom(int index , String key)
{
  if(key.length()< KEY_LENGTH)
  {
    key="1"+key;
  }
  int startIdx= index * KEY_LENGTH;
  for(int i=0; i< KEY_LENGTH;++i)
  {
    if( i < key.length())
    {
      EEPROM.write(startIdx+i , key[i]);
    }
    else
    {
      EEPROM.write(startIdx+i , 0);
    }
  }
  EEPROM.commit();
}
/*-------------------------------------------------------------------------------------------------------------------*/
/*function to read Key from didicated address*/
String ReadKeyFromEeprom(int index)
{
  String key="";
  int startIdx= index * KEY_LENGTH ;
  for(int i=0; i< KEY_LENGTH ;++i)
  {
    if((char)EEPROM.read(startIdx + i) == '1')
    {
      continue;
    }
    key+=(char)EEPROM.read(startIdx + i);
  }
  return key;
}
/*-------------------------------------------------------------------------------------------------------------------*/
/*function to add New Key*/
void Add_Key(String key)
{
  for(int i=0;i< KEY_COUNT ;++i)
  {
    if(ReadKeyFromEeprom(i)== "")
    {
      WriteKeyToEeprom(i,key);
      ++UserNumber;
      return ;
    }
  }
}
/*-------------------------------------------------------------------------------------------------------------------*/
/*function to remove any Exist Key*/
void Remove_Key(String key)
{
  String tempKey="";
  int startIdx= 0;
  /*read key*/
  for(int i=0; i< KEY_COUNT;++i)
  {
    tempKey=ReadKeyFromEeprom(i);
    /*compare*/
    if(tempKey == key)
    {
      int j=0;
      for( j=i;;j++)
      {
        tempKey=ReadKeyFromEeprom(j+1);
        if(tempKey == "")
        {
          /*clear eeprom*/
          j=j*KEY_LENGTH;
          for(int i=0; i< KEY_LENGTH ;++i)
          {
            EEPROM.write(j+i , 0);
          }
          EEPROM.commit();
          --UserNumber;
          return ;
        }
        WriteKeyToEeprom(j,tempKey);
      } 
    }
  }
}
/*-------------------------------------------------------------------------------------------------------------------*/
/*function to Encryption*/
void aes_ctr_decrypt(uint8_t* input, uint8_t* output, size_t len, const uint8_t* key, const uint8_t* iv)
{ 
  mbedtls_aes_context aes; 
  size_t nc_off = 0; 
  uint8_t stream_block[16];
  mbedtls_aes_init(&aes); 
  mbedtls_aes_setkey_enc(&aes, key, 128); 
  mbedtls_aes_crypt_ctr(&aes, len, &nc_off, (unsigned char*)iv, stream_block, input, output); 
  mbedtls_aes_free(&aes);
}
/*-------------------------------------------------------------------------------------------------------------------*/
class MyServerCallbacks : public NimBLEServerCallbacks {
  void onConnect(NimBLEServer* pServer, NimBLEConnInfo& connInfo) override 
  {
    deviceConnected = true;
    pServer->updateConnParams(connInfo.getConnHandle(), 24, 48, 0, 180);
  }
  void onDisconnect(NimBLEServer* pServer, NimBLEConnInfo& connInfo, int reason) override 
  {
    deviceConnected = false;
    authintication=false;
    once_user=false;
    fetchedKeysOnce = false;
    User="";
    frist_control=0;
    
    NimBLEDevice::startAdvertising();
  }
} serverCallbacks;

/*-------------------------------------------------------------------------------------------------------------------*/
class DoorControlCharacteristicCallbacks: public NimBLECharacteristicCallbacks
{
  void onWrite(NimBLECharacteristic *pControlCharacteristic, NimBLEConnInfo& connInfo) override
  {
    if(deviceConnected && authintication )
    {
      DoorState=pControlCharacteristic->getValue();
      if(DoorState == DOOR_UNLOCK &&  fetchedKeysOnce)
      {
        Serial1.print('1');
        action="DOOR UNLOCK";
        frist_control+=1;
      }
      else if(DoorState == DOOR_LOCK && fetchedKeysOnce )
      {
        Serial1.print('0');
        action="DOOR LOCK";
        frist_control+=1;
      }
    }
  }
}doorControlCharacteristicCallbacks;
/*-------------------------------------------------------------------------------------------------------------------*/
class BagControlCharacteristicCallbacks: public NimBLECharacteristicCallbacks
{
  void onWrite(NimBLECharacteristic *pControlCharacteristic, NimBLEConnInfo& connInfo) override
  {
    if(deviceConnected && authintication)
    {
      BagState=pControlCharacteristic->getValue();
      if(BagState == BAG_UNLOCK && fetchedKeysOnce )
      {
        Serial1.print('a');
        action="Trunk UNLOCK";
        frist_control+=1;
      }
      else if(BagState == BAG_LOCK && fetchedKeysOnce )
      {
        Serial1.print('b');
        action="Trunk LOCK";
        frist_control+=1;
      }
    }
  }
}bagControlCharacteristicCallbacks;
/*-------------------------------------------------------------------------------------------------------------------*/
class EnterKeyCharacteristicCallbacks: public NimBLECharacteristicCallbacks { 
  void onWrite(NimBLECharacteristic* pChar, NimBLEConnInfo& info) override 
  { 
    std::string value = pChar->getValue(); 
    if (value.length() < 16 + 6) 
      return;  // 16 IV + at least 6 encrypted bytes
    uint8_t iv[16];
    memcpy(iv, value.data(), 16);
    size_t encrypted_len = value.length() - 16;
    uint8_t encrypted[encrypted_len];
    uint8_t decrypted[encrypted_len];
    memcpy(encrypted, value.data() + 16, encrypted_len);
    uint8_t key[16] = {0};
    memcpy(key, "1234567890abcdef", 16); // Your pre-shared 6-byte key
    aes_ctr_decrypt(encrypted, decrypted, encrypted_len, key, iv);
    
    // to complete function
    String receivedKey = "";
    for (int i = 0; isPrintable(decrypted[i]) &&decrypted[i] != '\n'; ++i) 
    {
      receivedKey+= (char)decrypted[i];
    }
    
    if(receivedKey != "")
    {
      authintication=false;
      frist_control = 0;
      if(  IsKeyExists ( receivedKey )  )
      {
         if(receivedKey.length()== 5)
         {
           once_user = true;
         }
        User = receivedKey ;
        authintication=true;
      }
      if(authintication == true && once_user == true)
      {
        once_user = false;
        Remove_Key(receivedKey);
      }
    }
  } 
}enterKeyCharacteristicCallbacks;


void setup()
{
   Serial.begin(115200);
   ConnectToWiFi();
  Serial1.begin(115200,SERIAL_8N1,UART_RX,UART_TX);
  /*EEPROM initi*/
  EEPROM.begin(EEPROM_SIZE);
  /*EEPROM clear*/
  clear_eeprom();
  /*Owner KeyPass*/
  Add_Key("abcxyz");
  /*Device name */
  NimBLEDevice::init("CAR001");
  /*create server */
  pServer = NimBLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
  /*-------------------------------------------------------------------------------------------------------------------*/
  /*create control service*/
  NimBLEService *pControlService = pServer->createService( ACTION_CONTROL_SERVICE_UUID );
  /*create Key service*/
  NimBLEService *pKeyService     = pServer->createService( KEY_CONTROL_SERVICE_UUID    );
  /*-------------------------------------------------------------------------------------------------------------------*/
  /*create Control Door Characteristics */
  pDoorCharacteristic = pControlService->createCharacteristic(
      DOOR_UUID,
      NIMBLE_PROPERTY::WRITE 
  );
  pDoorCharacteristic->setCallbacks(new DoorControlCharacteristicCallbacks());
  /*-------------------------------------------------------------------------------------------------------------------*/
  /*create Control Bag Characteristics */
  pBagCharacteristic = pControlService->createCharacteristic(
      Trunk_UUID,
      NIMBLE_PROPERTY::WRITE  
  );
  pBagCharacteristic->setCallbacks(new BagControlCharacteristicCallbacks());
/*-------------------------------------------------------------------------------------------------------------------*/
  /*create Enter Key Characteristic */
  pEnterCharacterisitic = pKeyService->createCharacteristic(
      ENTER_KEY_UUID  ,
     NIMBLE_PROPERTY::WRITE 
  );
  pEnterCharacterisitic->setCallbacks(new EnterKeyCharacteristicCallbacks());
  /*-------------------------------------------------------------------------------------------------------------------*/
  /* start services */
  pControlService->start();
  pKeyService    ->start();
  /*start advertising */
  NimBLEAdvertising* pAdvertising = NimBLEDevice::getAdvertising();
  pAdvertising->setName("CAR001");
  pAdvertising->enableScanResponse(true);
  pAdvertising->start();

}
void loop() {
  // put your main code here, to run repeatedly:
  /* If Any Device Connect To CAR Esp Read UPdate Keys From Server*/
  if (deviceConnected && !fetchedKeysOnce) 
  {
       readKeysFromAzureAndSave();
       fetchedKeysOnce = true;
  }
  /* If Any User Connect To CAR And Take Action Send to Server*/
  else if( fetchedKeysOnce && frist_control == 1)
      {
        sendUserToAzure(User,action);
        frist_control=0;
        Serial.println("send to Server"); 
      }
  delay(1000);
  
}