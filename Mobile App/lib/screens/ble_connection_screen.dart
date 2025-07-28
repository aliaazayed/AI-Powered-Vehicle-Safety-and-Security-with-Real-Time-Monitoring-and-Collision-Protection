import 'dart:async';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/provider/ble_connection_provider.dart';
import 'package:test2zfroma/provider/connect_vehicle_provider.dart';
import 'package:test2zfroma/widgets/control_card.dart';
import 'package:test2zfroma/widgets/ellipse_button.dart';

class BleConnectionScreen extends StatefulWidget {
  const BleConnectionScreen({super.key});

  @override
  State<BleConnectionScreen> createState() => _BleConnectionScreenState();
}

class _BleConnectionScreenState extends State<BleConnectionScreen> {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  late Stream<DiscoveredDevice> _scanStream;
  final List<DiscoveredDevice> _devicesList = [];
  final TextEditingController _keypassController = TextEditingController();

  final _aesKey = encrypt.Key.fromUtf8('1234567890abcdef');

  final Uuid keypassServiceUuid =
      Uuid.parse("d90ae11e-0fcf-465e-9345-23b2860a8222");
  final Uuid keypassCharUuid =
      Uuid.parse("86b5eacb-e6d0-479c-98fd-a7a6ef66a1ba");
  final Uuid controlServiceUuid =
      Uuid.parse("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
  final Uuid doorCharUuid = Uuid.parse("beb5483e-36e1-4688-b7f5-ea07361b26a8");
  final Uuid trunkCharUuid = Uuid.parse("39143cb9-215a-4b35-87f1-34fc317df350");
  StreamSubscription<ConnectionStateUpdate>? _connectionSub;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBluetoothReminderDialog();
    });
  }

  Future<void> _checkPermissions() async {
    await [
      Permission.locationWhenInUse,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
  }

  void _startScan() {
    _devicesList.clear();
    _scanStream = _ble.scanForDevices(withServices: []).distinct();
    _scanStream.listen((device) {
      if (!_devicesList.any((d) => d.id == device.id)) {
        setState(() => _devicesList.add(device));
      }
    }, onError: (err) {
      debugPrint("Scan error: $err");
    });
  }

  void _connectToDevice(DiscoveredDevice device) {
    _connectionSub = _ble.connectToDevice(id: device.id).listen((state) async {
      if (state.connectionState == DeviceConnectionState.connected) {
        final services = await _ble.discoverServices(device.id);

        QualifiedCharacteristic? keypassChar;
        QualifiedCharacteristic? doorChar;
        QualifiedCharacteristic? trunkChar;

        for (final service in services) {
          if (service.serviceId == keypassServiceUuid) {
            for (final c in service.characteristics) {
              if (c.characteristicId == keypassCharUuid) {
                keypassChar = QualifiedCharacteristic(
                  deviceId: device.id,
                  serviceId: service.serviceId,
                  characteristicId: c.characteristicId,
                );
              }
            }
          }

          if (service.serviceId == controlServiceUuid) {
            for (final c in service.characteristics) {
              if (c.characteristicId == doorCharUuid) {
                doorChar = QualifiedCharacteristic(
                  deviceId: device.id,
                  serviceId: service.serviceId,
                  characteristicId: c.characteristicId,
                );
              }
              if (c.characteristicId == trunkCharUuid) {
                trunkChar = QualifiedCharacteristic(
                  deviceId: device.id,
                  serviceId: service.serviceId,
                  characteristicId: c.characteristicId,
                );
              }
            }
          }
        }

        if (keypassChar == null || doorChar == null || trunkChar == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Required characteristics not found."),
                backgroundColor: AppColors.error),
          );
          return;
        }

        Provider.of<BleConnectionProvider>(context, listen: false)
            .updateConnection(
          connected: true,
          name: device.name,
          id: device.id,
          keypassChar: keypassChar,
          doorChar: doorChar,
          trunkChar: trunkChar,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connected to ${device.name}'),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (state.connectionState == DeviceConnectionState.disconnected) {
        Provider.of<BleConnectionProvider>(context, listen: false).disconnect();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Disconnected from ${device.name}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });
  }

  void _disconnectFromDevice() {
    _connectionSub?.cancel();
    _connectionSub = null;
    Provider.of<BleConnectionProvider>(context, listen: false).disconnect();
  }

  Future<void> _promptAndSendKeypass() async {
    //نقارن مع keypass بتاعت الدخول
    final provider =
        Provider.of<ConnectVehicleProvider>(context, listen: false);
    final keypassSave = provider.savedKeypass;

    final entered = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: AppColors.primary,
        shadowColor: AppColors.primary,
        title: const Text(
          'Enter Keypass',
          style: TextStyle(color: AppColors.primary),
        ),
        content: TextField(
          controller: _keypassController,
          obscureText: true,
          cursorColor: AppColors.primary,
          decoration: const InputDecoration(hintText: 'Keypass'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, _keypassController.text.trim()),
            child: const Text(
              'Send',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
// check that the keypass correct

    if (entered != null && entered.isNotEmpty) {
      if (entered != keypassSave) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong keypass'),
            backgroundColor: AppColors.error,
          ),
        );
        return; // خروج مبكر وعدم إرسال
      }

      final p = context.read<BleConnectionProvider>();
      p.updateKeypass(entered);

      if (!p.isConnected || p.keypassCharacteristic == null) return;

      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(_aesKey));
      final encrypted = encrypter.encrypt(entered, iv: iv);

      final message = <int>[...iv.bytes, ...encrypted.bytes];

      try {
        await _ble.writeCharacteristicWithResponse(
          p.keypassCharacteristic!,
          value: message,
        );
        p.markKeypassSent();
        _keypassController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Keypass sent')),
        );
      } catch (e) {
        debugPrint('Error sending keypass: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send keypass')),
        );
      }
    }
  }

  Future<void> _sendCommand(
      QualifiedCharacteristic? char, String command, String label) async {
    final p = context.read<BleConnectionProvider>();
    if (!p.isConnected || char == null || !p.hasSentKeypass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Send keypass first')),
      );
      return;
    }

    try {
      await _ble.writeCharacteristicWithResponse(char,
          value: command.codeUnits);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('✅ $label')));
    } catch (e) {
      debugPrint('BLE write error: $e');
    }
  }

  void _showBluetoothReminderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        // surfaceTintColor: AppColors.primary,
        title: const Text(
          'Bluetooth Required',
          style: TextStyle(color: AppColors.primary),
        ),
        content: const Text(
          'Please make sure your Bluetooth is turned on.',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double ellipseHeight = screenHeight * 0.06;
    double ellipseWidth = screenWidth * 0.42;
    double ellipseFont = screenHeight * 0.025;

    double ellipseFontSmall = screenHeight * 0.018;
    double ellipseHeightSmall = screenHeight * 0.045;
    double ellipseWeightSmall = screenWidth * 0.3;

    final bleProvider = context.watch<BleConnectionProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.bluetooth, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text('BLE Connection', style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            const Divider(
              color: AppColors.textPrimary,
              height: 1,
              thickness: 1,
            ),
            SizedBox(height: screenHeight * 0.02),
            EllipseButton(
              text: 'Start Scan',
              onTap: _startScan,
              height: ellipseHeight,
              width: ellipseWidth,
              fontSize: ellipseFont,
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: bleProvider.isConnected
                    ? _devicesList
                        .where((d) => d.id == bleProvider.deviceId)
                        .length
                    : _devicesList.length,
                itemBuilder: (context, index) {
                  final filteredList = bleProvider.isConnected
                      ? _devicesList
                          .where((d) => d.id == bleProvider.deviceId)
                          .toList()
                      : _devicesList;
                  final device = filteredList[index];
                  final isConnectedDevice = bleProvider.deviceId == device.id &&
                      bleProvider.isConnected;

                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(device.name.isNotEmpty
                                      ? device.name
                                      : 'Unknown Device'),
                                  Text(device.id,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700])),
                                ],
                              ),
                            ),
                            EllipseButton(
                              text:
                                  isConnectedDevice ? 'Disconnect' : 'Connect',
                              onTap: () {
                                if (isConnectedDevice) {
                                  _disconnectFromDevice();
                                } else {
                                  _connectToDevice(device);
                                }
                              },
                              height: ellipseHeightSmall,
                              width: ellipseWeightSmall,
                              fontSize: ellipseFontSmall,
                            ),
                          ],
                        ),
                      ),
                      if (isConnectedDevice) ...[
                        SizedBox(height: screenHeight * 0.01),
                        EllipseButton(
                            text: ("Control"),
                            onTap: () => (),
                            height: ellipseHeight,
                            fontSize: ellipseFont,
                            width: ellipseWidth),
                        SizedBox(height: screenHeight * 0.02),
                        Center(
                          child: ControlCard(
                            icon: Icons.vpn_key_outlined,
                            title: 'Enter Keypass',
                            subtitle: 'Authenticate to enable control',
                            onTap: _promptAndSendKeypass,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Row(
                          children: [
                            Expanded(
                              child: ControlCard(
                                icon: Icons.door_back_door_outlined,
                                title: 'Open Door',
                                subtitle: 'Unlock vehicle door',
                                onTap: () => _sendCommand(
                                  bleProvider.doorCharacteristic,
                                  '1',
                                  'Door opened',
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.015),
                            Expanded(
                              child: ControlCard(
                                icon: Icons.door_front_door_outlined,
                                title: 'Close Door',
                                subtitle: 'Lock the vehicle door',
                                onTap: () => _sendCommand(
                                  bleProvider.doorCharacteristic,
                                  '0',
                                  'Door closed',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Row(
                          children: [
                            Expanded(
                              child: ControlCard(
                                icon: Icons.car_rental_outlined,
                                title: 'Open Trunk',
                                subtitle: 'Access the trunk',
                                onTap: () => _sendCommand(
                                  bleProvider.trunkCharacteristic,
                                  '3',
                                  'Trunk opened',
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.015),
                            Expanded(
                              child: ControlCard(
                                icon: Icons.car_rental,
                                title: 'Close Trunk',
                                subtitle: 'Secure the trunk',
                                onTap: () => _sendCommand(
                                  bleProvider.trunkCharacteristic,
                                  '2',
                                  'Trunk closed',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ]
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectionSub?.cancel();
    _keypassController.dispose();
    super.dispose();
  }
}
