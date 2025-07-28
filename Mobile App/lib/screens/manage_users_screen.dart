import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/models/once_user.dart';
import 'package:test2zfroma/models/permanent_user.dart';
import 'package:test2zfroma/provider/once_user_provider.dart';
import 'package:test2zfroma/provider/permanent_user_provider.dart';

import '../widgets/user_card_widgets.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final TextEditingController _permanentNameController =
      TextEditingController();
  final TextEditingController _permanentKeyController = TextEditingController();
  final TextEditingController _permanentCarIdController =
      TextEditingController();
  final TextEditingController _onceNameController = TextEditingController();
  final TextEditingController _onceKeyController = TextEditingController();
  final TextEditingController _onceCarIdController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  bool _isPermanent = false;
  bool _isOnce = false;

  bool _isBLE = false;
  bool _isFace = false;
  String? _generatedKey;
  String? _generatedOnceKey;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PermanentUserProvider>().loadFromHive();
      //context.read<OnceUserProvider>().loadFromHive();
    });
    Future.microtask(() =>
        Provider.of<OnceUserProvider>(context, listen: false).initLocalUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.people_outline_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text('Manage Users', style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Divider
            const Divider(
              color: AppColors.textPrimary,
              height: 1,
              thickness: 1,
            ),

            const SizedBox(height: 16),

            // Manage Notifications Card
            // _buildManageNotificationsCard(),
            const SizedBox(height: 16),

            // Add New User Card
            _buildAddNewUserCard(),

            // Conditional forms based on selection
            if (_isPermanent) ...[
              const SizedBox(height: 16),
              _buildPermanentUserForm(),
            ],

            if (_isOnce) ...[const SizedBox(height: 16), _buildOnceUserForm()],

            const SizedBox(height: 16),

            // Remove User Card
            _buildRemoveUserCard(),

            // Add some bottom padding
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewUserCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.primary),
      ),
      color: AppColors.inputBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New User',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 16),

            // Selection buttons
            LayoutBuilder(
              builder: (context, constraints) {
                // Use different layouts based on available width
                if (constraints.maxWidth > 300) {
                  // Side by side layout for wider screens
                  return Row(
                    children: [
                      Expanded(child: _buildPermanentButton()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildOnceButton()),
                    ],
                  );
                } else {
                  // Stacked layout for narrow screens
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPermanentButton(),
                      const SizedBox(height: 8),
                      _buildOnceButton(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnceButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isOnce = true;
          _isPermanent = false;
          _isBLE = false;
          _isFace = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _isOnce ? AppColors.primary : AppColors.primary.withOpacity(0.8),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: const Text('Once', style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildOnceUserForm() {
    final media = MediaQuery.of(context).size;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.primary),
      ),
      color: AppColors.inputBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Car ID
            TextFormField(
              controller: _onceCarIdController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.directions_car_outlined,
                    color: AppColors.primary),
                labelText: 'Car ID',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              cursorColor: AppColors.primary,
            ),

            const SizedBox(height: 16),

            // Name
            TextFormField(
              controller: _onceNameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person, color: AppColors.primary),
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              cursorColor: AppColors.primary,
            ),

            const SizedBox(height: 16),

            // اختيار طريقة المصادقة

            Text(
              'Choose Authentication Method:',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            LayoutBuilder(
              builder: (context, constraints) {
                return constraints.maxWidth > 250
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [_buildBLEButton(), _buildFaceButton()],
                      )
                    : Column(
                        children: [
                          _buildBLEButton(),
                          const SizedBox(height: 8),
                          _buildFaceButton(),
                        ],
                      );
              },
            ),

            const SizedBox(height: 16),

            // محتوى BLE
            if (_isBLE) ...[
              SizedBox(
                height: media.height * 0.065,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final newKey = _generateRandomKey(5);
                    setState(() {
                      _onceKeyController.text = newKey;
                      _generatedOnceKey = newKey;
                    });
                  },
                  icon: const Icon(Icons.sync),
                  label: const Text('Generate Keypass'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_generatedOnceKey != null)
                Container(
                  height: media.height * 0.07,
                  padding: EdgeInsets.symmetric(horizontal: media.width * 0.04),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.vpn_key_outlined,
                          color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _generatedOnceKey!,
                          style: TextStyle(
                            fontSize: media.width * 0.042,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy,
                            size: 20, color: AppColors.primary),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: _generatedOnceKey!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Keypass copied'),
                                backgroundColor: AppColors.success),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
            ],

            // محتوى Face
            if (_isFace) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.add_a_photo_outlined,
                            size: 48, color: AppColors.primary),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.upload),
                      label: const Text('Choose Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // زر الإضافة
            if (_isBLE || _isFace)
              Center(
                child: SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: _handleOnceUserSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleOnceUserSubmit() async {
    final carId = _onceCarIdController.text.trim();
    final name = _onceNameController.text.trim();
    final key = _onceKeyController.text.trim();

    if (carId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a car ID'),
        backgroundColor: AppColors.error,
      ));
      return;
    }
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a name'),
        backgroundColor: AppColors.error,
      ));
      return;
    }

    if (_isBLE && key.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a key'),
        backgroundColor: AppColors.error,
      ));
      return;
    }

    if (_isFace && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please choose a photo'),
        backgroundColor: AppColors.error,
      ));
      return;
    }

    if ((_isBLE && _isFace) || (!_isBLE && !_isFace)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose only one authentication method'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    final keypass = _isBLE ? key : null;
    final imageFile = _isFace ? _selectedImage : null;
    print('🔎 هل في صورة؟ ${_selectedImage != null}');
    print('🔎 هل في مفتاح؟ ${_onceKeyController.text}');

    final onceUser = OnceUser(
      carId: carId,
      name: name,
      keypass: keypass,
      image: imageFile,
    );

    final onceUserProvider = context.read<OnceUserProvider>();
    await onceUserProvider.addOnceUser(onceUser);

    // Reset UI
    _onceNameController.clear();
    _onceCarIdController.clear();
    _onceKeyController.clear();
    _selectedImage = null;

    setState(() {
      _isOnce = false;
      _isPermanent = false;
      _isFace = false;
      _isBLE = false;
      _generatedOnceKey = null;
    });

    final message = onceUserProvider.responseMessage ?? "Done.";
    final isSuccess =
        message.toLowerCase().contains("success") || message == "Done.";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          //style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: isSuccess ? AppColors.success : AppColors.error,
        //duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildPermanentButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isPermanent = true;
          _isOnce = false;
          _isBLE = false;
          _isFace = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isPermanent
            ? AppColors.primary
            : AppColors.primary.withOpacity(0.8),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: const Text(
        'Permanent',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildPermanentUserForm() {
    final media = MediaQuery.of(context).size;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.primary),
      ),
      color: AppColors.inputBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Car ID
            TextFormField(
              controller: _permanentCarIdController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.directions_car_outlined,
                    color: AppColors.primary),
                labelText: 'Car ID',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              cursorColor: AppColors.primary,
            ),

            const SizedBox(height: 16),

            // Name
            TextFormField(
              controller: _permanentNameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person, color: AppColors.primary),
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              cursorColor: AppColors.primary,
            ),

            const SizedBox(height: 16),

            // Generate Key button + display
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: media.height * 0.065,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final newKey = _generateRandomKey(6);
                      setState(() {
                        _permanentKeyController.text = newKey;
                        _generatedKey = newKey;
                      });
                    },
                    icon: const Icon(Icons.sync),
                    label: const Text('Generate Keypass'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (_generatedKey != null)
                  Container(
                    height: media.height * 0.07,
                    padding:
                        EdgeInsets.symmetric(horizontal: media.width * 0.04),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.vpn_key_outlined,
                            color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _generatedKey!,
                            style: TextStyle(
                              fontSize: media.width * 0.042,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy,
                              size: 20, color: AppColors.primary),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: _generatedKey!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Keypass copied'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Add button
            buildAddButton(
              onPressed: () async {
                final carId = _permanentCarIdController.text.trim();
                final name = _permanentNameController.text.trim();
                final key = _permanentKeyController.text.trim();

                if (name.isEmpty || key.isEmpty || carId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                final provider = context.read<PermanentUserProvider>();

                await provider.addPermanentUser(
                  PermanentUser(
                    carId: carId,
                    name: name,
                    keypass: key,
                  ),
                );

                if (provider.responseMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to add user.'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Permanent user added.'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }

                // Clear inputs
                _permanentNameController.clear();
                _permanentKeyController.clear();
                setState(() {
                  _isPermanent = false;
                  _isOnce = false;
                  _generatedKey = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBLEButton() {
    return SizedBox(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isBLE = true;
            _isFace = false;
            _selectedImage = null; // ← امسح الصورة
            _onceKeyController.clear(); // ← امسح أي مفتاح قديم
            _generatedOnceKey = null;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isBLE ? AppColors.primary : AppColors.primary.withOpacity(0.8),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bluetooth_connected_outlined,
              size: 28,
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            const Text('BLE', style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildFaceButton() {
    return SizedBox(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isFace = true;
            _isBLE = false;
            _onceKeyController.clear(); // ← امسح المفتاح
            _generatedOnceKey = null;
            _selectedImage = null; // ← امسح الصورة اللي اترفعت قبل كده
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isFace ? AppColors.primary : AppColors.primary.withOpacity(0.8),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, size: 28, color: Colors.white),
            const SizedBox(height: 4),
            const Text('Face', style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoveUserCard() {
    final permanentUserProvider = context.watch<PermanentUserProvider>();
    final permanentUsers = permanentUserProvider.permanentUsers;

    final onceUserProvider = context.watch<OnceUserProvider>();
    final onceUsers = onceUserProvider.localUsers;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.primary),
      ),
      color: AppColors.inputBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Users',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 12),

            //  Permanent Users Section
            Text(
              'Permanent Users',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            if (permanentUsers.isEmpty)
              Center(
                child: Text(
                  'No permanent users added.',
                  style: TextStyle(color: Colors.black),
                ),
              )
            else
              ListView.builder(
                itemCount: permanentUsers.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = permanentUsers[index];
                  return PermanentUserCard(
                    user: user,
                    index: index,
                    onRemove: () {
                      permanentUserProvider.deleteUserLocally(index);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(' User removed successfully'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      });
                    },
                  );
                },
              ),

            const SizedBox(height: 20),
            //  Once Users Section
            Text(
              'One-Time Users',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            if (onceUsers.isEmpty)
              Center(
                child: Text(
                  'No one-time users added.',
                  style: TextStyle(color: Colors.black),
                ),
              )
            else
              ListView.builder(
                itemCount: onceUsers.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = OnceUser.fromLocal(onceUsers[index]);
                  return OneUserCard(
                      user: user,
                      index: index,
                      onRemove: () {
                        onceUserProvider.deleteUserLocally(index);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User removed successfully'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        });
                      });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget buildAddButton({required VoidCallback onPressed}) {
    return Center(
      child: SizedBox(
        width: 140,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Add',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }
}

String _generateRandomKey(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz';
  final rand = Random.secure();
  return List.generate(
    length,
    (index) => chars[rand.nextInt(chars.length)],
  ).join();
}
