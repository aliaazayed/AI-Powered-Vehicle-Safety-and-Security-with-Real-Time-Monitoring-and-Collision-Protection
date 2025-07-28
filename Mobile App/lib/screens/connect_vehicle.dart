import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/provider/connect_vehicle_provider.dart';
import 'package:test2zfroma/provider/user_type_provider.dart';

class ConnectVehicle extends StatefulWidget {
  const ConnectVehicle({super.key});

  @override
  State<ConnectVehicle> createState() => _ConnectVehicleState();
}

class _ConnectVehicleState extends State<ConnectVehicle> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final provider = Provider.of<ConnectVehicleProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.directions_car,
                color: AppColors.primary, size: media.width * 0.06),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Connect your Vehicle',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: media.width * 0.045,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(media.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(
                color: AppColors.textPrimary, height: 1, thickness: 1),
            SizedBox(height: media.height * 0.02),
            provider.isGuest
                ? const SizedBox()
                : _buildTabSelector(media, provider),
            SizedBox(height: media.height * 0.02),
            _buildForm(
              title: provider.isRegistration
                  ? 'Vehicle Registration'
                  : 'Join by Invitation',
              subtitle: 'Enter the car ID and the keypass',
              media: media,
              provider: provider,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector(Size media, ConnectVehicleProvider provider) {
    return Container(
      height: media.height * 0.06,
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(media.width * 0.01),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              Icons.vpn_key_outlined,
              'Registration',
              provider.isRegistration,
              () => provider.toggleMode(true),
              media,
            ),
          ),
          Expanded(
            child: _buildTabButton(
              Icons.people_alt_outlined,
              'Invitation',
              !provider.isRegistration,
              () => provider.toggleMode(false),
              media,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(IconData icon, String text, bool isSelected,
      VoidCallback onTap, Size media) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: media.height * 0.05,
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.35),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              )
            : BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: media.width * 0.05,
                color: isSelected ? AppColors.primary : Colors.grey),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: media.width * 0.035,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm({
    required String title,
    required String subtitle,
    required Size media,
    required ConnectVehicleProvider provider,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
        ),
        SizedBox(height: media.height * 0.01),
        Text(
          subtitle,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: media.height * 0.03),
        _buildTextField(Icons.directions_car_filled_outlined, 'CAR ID', false,
            media, provider.carId),
        SizedBox(height: media.height * 0.02),
        _buildTextField(
            Icons.vpn_key_outlined, 'KEYPASS', true, media, provider.keypass),
        SizedBox(height: media.height * 0.04),
        SizedBox(
          width: double.infinity,
          height: media.height * 0.06,
          child: ElevatedButton(
            onPressed: () async {
              final connectProvider =
                  Provider.of<ConnectVehicleProvider>(context, listen: false);
              final userTypeProvider =
                  Provider.of<UserTypeProvider>(context, listen: false);

              // 🟨 حدد نوع المستخدم
              final userType = connectProvider.isRegistration
                  ? 'owner'
                  : connectProvider.isGuest
                      ? 'once'
                      : 'permanent';

              await userTypeProvider.setUserType(userType);

              // 🟦 تابع حسب نوع الدخول
              if (connectProvider.isGuest) {
                connectProvider.checkGuestAccess(context);
              } else if (!connectProvider.isRegistration) {
                connectProvider.checkInvitation(context);
              } else {
                connectProvider.checkRegistration(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              provider.isRegistration ? 'Connect Vehicle' : 'Join Vehicle',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: media.width * 0.045,
              ),
            ),
          ),
        ),
        SizedBox(height: media.height * 0.02),
      ],
    );
  }

  Widget _buildTextField(IconData icon, String label, bool isPassword,
      Size media, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.primary,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon:
            Icon(icon, color: AppColors.primary, size: media.width * 0.06),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
