import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

class GPSPage extends StatefulWidget {
  const GPSPage({super.key});

  @override
  _GPSPageState createState() => _GPSPageState();
}

class _GPSPageState extends State<GPSPage> {
  // Updated MQTT configuration to match your HiveMQ Cloud setup
  final String broker = '006cdd2efa0e4690b47674aced123803.s1.eu.hivemq.cloud';
  final int port = 8883; // TLS port for HiveMQ Cloud
  final String topic = 'asmaa/gps';
  final String clientId = '006cdd2efa0e4690b47674aced123803';
  final String username = 'hivemq.webclient.1751455473639';
  final String password = 'vN4kaFT:5zj0xG;.X8H?';

  MqttServerClient? client;
  double? latitude;
  double? longitude;
  String? urlMessage; // Added to store URL from MQTT message
  GoogleMapController? _mapController;

  // Connection status
  bool isConnected = false;
  String connectionStatus = 'Connecting...';

  @override
  void initState() {
    super.initState();
    connectToMQTT();
  }

  Future<void> connectToMQTT() async {
    try {
      setState(() {
        connectionStatus = 'Connecting to MQTT broker...';
      });

      // Create client with TLS support for HiveMQ Cloud
      client = MqttServerClient.withPort(broker, clientId, port);
      client!.secure = true; // Enable TLS for HiveMQ Cloud
      client!.logging(on: false); // Set to true for debugging
      client!.onDisconnected = onDisconnected;
      client!.onConnected = onConnected;
      client!.keepAlivePeriod = 60;

      // Configure connection message with authentication
      final connMessage = MqttConnectMessage()
          .withClientIdentifier(clientId)
          .withWillTopic('willtopic')
          .withWillMessage('GPS client disconnected')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);

      // Add authentication for HiveMQ Cloud
      if (username.isNotEmpty && password.isNotEmpty) {
        connMessage.authenticateAs(username, password);
      }

      client!.connectionMessage = connMessage;

      // Attempt connection
      final connResult = await client!.connect();

      if (connResult?.state != MqttConnectionState.connected) {
        print('Failed to connect: ${connResult?.state}');
        setState(() {
          connectionStatus = 'Connection failed: ${connResult?.state}';
          isConnected = false;
        });
        client!.disconnect();
        return;
      }

      print('Connected to MQTT broker successfully');
      setState(() {
        isConnected = true;
        connectionStatus = 'Connected';
      });

      // Subscribe to GPS topic
      client!.subscribe(topic, MqttQos.atLeastOnce);
      print('Subscribed to topic: $topic');

      // Listen for incoming messages
      client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
        if (c == null || c.isEmpty) return;

        final recMess = c[0].payload as MqttPublishMessage;
        final message =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        print('Received GPS data: $message');
        parseAndUpdateLocation(message);
      });
    } catch (e) {
      print('MQTT connection error: $e');
      setState(() {
        connectionStatus = 'Connection error: $e';
        isConnected = false;
      });
      client?.disconnect();
    }
  }

  void parseAndUpdateLocation(String message) {
    try {
      // Try to parse as JSON first
      final data = json.decode(message);

      double? lat;
      double? lon;
      String? url;

      // Handle different possible JSON structures
      if (data is Map<String, dynamic>) {
        // Try common field names for latitude and longitude
        lat = _parseCoordinate(
            data['latitude'] ?? data['lat'] ?? data['Latitude'] ?? data['LAT']);
        lon = _parseCoordinate(data['longitude'] ??
            data['lon'] ??
            data['lng'] ??
            data['Longitude'] ??
            data['LON']);

        // Extract URL from the message - expanded to handle more variations
        url = data['url'] ??
            data['URL'] ??
            data['link'] ??
            data['Link'] ??
            data['website'] ??
            data['Website'] ??
            data['webUrl'] ??
            data['web_url'] ??
            data['maps_link'] ??
            data['Maps_Link'] ??
            data['MapsLink'];
      }

      if (lat != null && lon != null && _isValidCoordinate(lat, lon)) {
        setState(() {
          latitude = lat;
          longitude = lon;
          urlMessage = url; // Store the URL
          connectionStatus = 'GPS data received';
        });

        // Animate camera to new position with a slight delay to ensure map is ready
        Future.delayed(Duration(milliseconds: 500), () {
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(lat!, lon!),
                zoom: 16.0,
              ),
            ),
          );
        });

        print('Updated location: Lat: $lat, Lon: $lon, URL: $url');
      } else {
        print('Invalid coordinates received: Lat: $lat, Lon: $lon');
      }
    } catch (e) {
      print('Error parsing GPS data: $e');
      // Try parsing as comma-separated values (fallback)
      _parseCommaSeparatedData(message);
    }
  }

  double? _parseCoordinate(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  bool _isValidCoordinate(double lat, double lon) {
    return lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180;
  }

  void _parseCommaSeparatedData(String message) {
    try {
      // Try parsing as "lat,lon,url" format
      final parts = message.split(',');
      if (parts.length >= 2) {
        final lat = double.tryParse(parts[0].trim());
        final lon = double.tryParse(parts[1].trim());
        final url = parts.length > 2 ? parts[2].trim() : null;

        if (lat != null && lon != null && _isValidCoordinate(lat, lon)) {
          setState(() {
            latitude = lat;
            longitude = lon;
            urlMessage = url; // Store the URL from CSV format
            connectionStatus = 'GPS data received';
          });

          // Fixed syntax error here - was missing 'Duration(' constructor
          Future.delayed(Duration(milliseconds: 500), () {
            _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(lat, lon),
                  zoom: 16.0,
                ),
              ),
            );
          });
        }
      }
    } catch (e) {
      print('Error parsing comma-separated GPS data: $e');
    }
  }

  // Function to launch URL - Enhanced with better error handling
  Future<void> _launchURL() async {
    if (urlMessage != null && urlMessage!.isNotEmpty) {
      try {
        String urlToLaunch = urlMessage!;

        // Add https:// if no protocol is specified
        if (!urlToLaunch.startsWith('http://') &&
            !urlToLaunch.startsWith('https://')) {
          urlToLaunch = 'https://$urlToLaunch';
        }

        final Uri url = Uri.parse(urlToLaunch);

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          _showSnackBar('Opening website: $urlToLaunch');
        } else {
          _showSnackBar('Could not launch $urlToLaunch');
        }
      } catch (e) {
        print('Error launching URL: $e');
        _showSnackBar('Invalid URL: $urlMessage');
      }
    } else {
      _showSnackBar('No URL available');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  void onDisconnected() {
    print('MQTT Disconnected');
    setState(() {
      isConnected = false;
      connectionStatus = 'Disconnected';
    });

    // Attempt to reconnect after a delay
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        connectToMQTT();
      }
    });
  }

  void onConnected() {
    print('MQTT Connected');
    setState(() {
      isConnected = true;
      connectionStatus = 'Connected';
    });
  }

  void reconnect() {
    client?.disconnect();
    connectToMQTT();
  }

  @override
  void dispose() {
    client?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Responsive padding and spacing
    final horizontalPadding = width * 0.04; // 4% of screen width
    final verticalSpacing = height * 0.01; // 1% of screen height

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Icon(Icons.location_on_outlined,
                color: AppColors.primary,
                size: width * 0.06), // 6% of screen width
            SizedBox(width: width * 0.02),
            Expanded(
              child: Text(
                'GPS Location',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.045, // Responsive font size
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Connection status indicator
          Container(
            margin: EdgeInsets.only(right: horizontalPadding),
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.008,
            ),
            decoration: BoxDecoration(
              color: isConnected ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(width * 0.06),
            ),
            child: Text(
              isConnected ? 'Connected' : 'Offline',
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.03,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Divider
          Container(
            height: 1,
            color: AppColors.textPrimary.withOpacity(0.3),
            margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
          ),

          // Status information card
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(horizontalPadding),
            padding: EdgeInsets.all(width * 0.04),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(width * 0.03),
              border: Border.all(color: Colors.grey[300]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Status: $connectionStatus',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!isConnected)
                      ElevatedButton(
                        onPressed: reconnect,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.005,
                          ),
                          minimumSize: Size(width * 0.2, height * 0.04),
                        ),
                        child: Text('Reconnect',
                            style: TextStyle(fontSize: width * 0.03)),
                      ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                Text(
                  'Topic: $topic',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: width * 0.035,
                  ),
                ),
                if (latitude != null && longitude != null) ...[
                  SizedBox(height: height * 0.01),
                  Text(
                    'Coordinates:',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    '${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                // Show URL if available - Enhanced display
                if (urlMessage != null && urlMessage!.isNotEmpty) ...[
                  SizedBox(height: height * 0.01),
                  Text(
                    'Website URL:',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  GestureDetector(
                    onTap: _launchURL,
                    child: Text(
                      urlMessage!,
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Map container
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                // Adjust bottom margin based on whether URL button is shown
                urlMessage != null && urlMessage!.isNotEmpty
                    ? height * 0.01
                    : horizontalPadding,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.03),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(width * 0.03),
                child: latitude != null && longitude != null
                    ? GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                          // Set initial camera position after map is created
                          Future.delayed(Duration(milliseconds: 1000), () {
                            if (latitude != null && longitude != null) {
                              controller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(latitude!, longitude!),
                                    zoom: 16.0,
                                  ),
                                ),
                              );
                            }
                          });
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(latitude!, longitude!),
                          zoom: 16.0,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId('gps_location'),
                            position: LatLng(latitude!, longitude!),
                            infoWindow: InfoWindow(
                              title: 'GPS Location',
                              snippet:
                                  'Lat: ${latitude!.toStringAsFixed(6)}, Lon: ${longitude!.toStringAsFixed(6)}',
                            ),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRed),
                          )
                        },
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        compassEnabled: true,
                        mapToolbarEnabled: true,
                        zoomGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                      )
                    : Container(
                        color: Colors.grey[100],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 3,
                              ),
                              SizedBox(height: height * 0.02),
                              Text(
                                'Waiting for GPS data from cloud...',
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: height * 0.01),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.1),
                                child: Text(
                                  'Make sure your device is publishing to: $topic',
                                  style: TextStyle(
                                    fontSize: width * 0.032,
                                    color: Colors.grey[500],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),

          // URL Launch Button - Enhanced design and functionality
          if (urlMessage != null && urlMessage!.isNotEmpty)
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(horizontalPadding),
              child: ElevatedButton.icon(
                onPressed: _launchURL,
                icon: Icon(Icons.launch, size: width * 0.05),
                label: Text(
                  'Open Website',
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.015,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                  elevation: 2,
                  shadowColor: AppColors.primary.withOpacity(0.3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
