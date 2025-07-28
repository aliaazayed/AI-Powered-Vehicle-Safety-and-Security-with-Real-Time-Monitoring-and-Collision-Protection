import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:test2zfroma/constants/app_color.dart';


class ConnectVehicleProvider extends ChangeNotifier {

  bool _isRegistration = true;

  final TextEditingController carIdController = TextEditingController(text: "CAR001");
  final TextEditingController keypassController = TextEditingController(text: "abcxyz");

  bool get isRegistration => _isRegistration;

  TextEditingController get carId => carIdController;
  TextEditingController get keypass => keypassController;



  // Guest mode
  bool _isGuest = false;
  bool get isGuest => _isGuest;
  void setGuest(bool value) {
    _isGuest = value;
    if (value) _isRegistration = false; // invitation mode
    notifyListeners();
  }


  // loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // to save data
  String? _savedCarId;
  String? _savedKeypass;
  String? _savedUserName;

  String? get savedCarId => _savedCarId;
  String? get savedKeypass => _savedKeypass;
  String? get savedUserName => _savedUserName;

  void saveCredentials(String carId, String keypass,String name) {
    _savedCarId = carId;
    _savedKeypass = keypass;
    _savedUserName=name;
    notifyListeners();
  }

  // change mood
  void toggleMode(bool registrationMode) {
    _isRegistration = registrationMode;
    notifyListeners();
  }

 // clearFields
  void clearFields() {
    carIdController.clear();
    keypassController.clear();
    notifyListeners();
  }

  Future<void> checkInvitation(BuildContext context) async {
    final String carId = carIdController.text.trim();
    final String keypass = keypassController.text.trim();
    print(" Sending request with carId: $carId, keypass: $keypass بصي ");

    final url = Uri.parse(
        'https://car-access-app-gee6hqezhddjg6g8.northeurope-01.azurewebsites.net/invitation');
    setLoading(true);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": 'application/json'},
        body: jsonEncode({'carId': carId, 'keypass': keypass}),
      );

      print('StatusCode : ${response.statusCode}');
      print('Body : ${response.body}');

      final data = jsonDecode(response.body);
      print('Decoded JSON: $data');

      if (response.statusCode == 200) {
        print("✅ البيانات صحيحة");
        final name = data['user']?['name'] ?? 'User';
        final message = isGuest
            ? 'Hi $name! You can control the car "$carId" only once.'
            : 'Hi $name! You’ve been invited to access the car "$carId".';

        saveCredentials(carId, keypass,name); // save data

        Navigator.pushReplacementNamed(context, '/home'); //  go to home

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        print('❌ البيانات غير صحيحة');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid Car ID or Keypass. Please try again.'),
              backgroundColor: AppColors.error,
            ),
        );
      }
      print(data);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something wrong .. please try again. '),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> checkRegistration(BuildContext context) async {
    final String carId = carIdController.text.trim();
    final String keypass = keypassController.text.trim();
    print("Sending request with carId: $carId, keypass: $keypass");

    final url = Uri.parse(
        'https://car-access-app-gee6hqezhddjg6g8.northeurope-01.azurewebsites.net/Registration');
    setLoading(true);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": 'application/json'},
        body: jsonEncode({'carId': carId, 'keypass': keypass}),
      );

      print('StatusCode : ${response.statusCode}');
      print('Body : ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("✅ البيانات صحيحة");
        final name = data['user']?['name'] ?? 'Owner';

        saveCredentials(carId, keypass ,name); // ✅save data

        Navigator.pushReplacementNamed(context, '/home'); // ✅ go to home

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hi $name! You are now registered as the owner of the car "$carId".'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        print('❌ البيانات غير صحيحة');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid Car ID or Keypass. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }

      print(data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something wrong .. please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setLoading(false);
    }
  }


  Future<void> checkGuestAccess(BuildContext context) async {
    final String carId = carIdController.text.trim();
    final String keypass = keypassController.text.trim();
    print("🔑 Guest access check with carId: $carId, keypass: $keypass");

    final url = Uri.parse(
        'https://car-access-app-gee6hqezhddjg6g8.northeurope-01.azurewebsites.net/guest');
    setLoading(true);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": 'application/json'},
        body: jsonEncode({'carId': carId, 'keypass': keypass}),
      );

      print('🔄 StatusCode: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      final data = jsonDecode(response.body);
      print('🧾 Decoded JSON: $data');

      if (response.statusCode == 200) {
        print("$response.massage");
        final guest = data['guest'];
        final name = guest['name'] ?? 'Guest';

        final message =
            'Hi $name! You can control the car "$carId" one time only.';

        saveCredentials(carId, keypass, name); //  احفظ البيانات

        Navigator.pushReplacementNamed(context, '/home'); //  روح للصفحة الرئيسية

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        print('❌ Guest access denied');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials or access denied for guest.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      print('⚠️ Error during guest access check: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again later.'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    carIdController.dispose();
    keypassController.dispose();
    super.dispose();
  }

}
