
## System Overview
This project implements a smart car access system with the following capabilities:
- Keyless entry via mobile app
- User recognition for authorized access
- Shared access management for multiple users
- Live GPS tracking
- Remote door/trunk unlock
- Child/pet monitoring alerts
- Unauthorized access detection
- ADAS functionalities

## Hardware Components
Our system operates across three key hardware platforms:

### ESP32
- **BLE Module**: Handles keyless entry communication with the mobile app
- **GPS Module**: Provides real-time vehicle location tracking
- **Communication**: Acts as a bridge between mobile app and vehicle systems

### STM32
- **Door Control Systems**: Physical mechanisms for locking/unlocking
- **ADAS Systems**: Advanced driver assistance functionalities

### Raspberry Pi
- **Recognition System**: Processes user recognition via facial/iris recognition
- **Monitoring System**: Analyzes sensor data for child/pet detection
- **Security Monitoring**: Detects and alerts unauthorized access attempts

## Mobile Application
- User authentication and profile management
- Dashboard for vehicle control and status
- Settings for managing shared access via invitations
- Notification center for alerts and system messages

## Data Flow Architecture
1. **User Authentication Flow**
   - App authentication → Backend validation → Raspberry Pi recognition
   - Authorization transmitted to STM32 for physical access

2. **Vehicle Access Flow**
   - BLE request from app → ESP32 receives → STM32 verification → Door unlock

3. **Monitoring Alert Flow**
   - Sensors → STM32 processing → Raspberry Pi analysis → ESP32 transmission → App notification

4. **User Invitation Flow**
   - Owner generates code in app → Backend creates limited access → New user registers → Raspberry Pi adds to recognition database