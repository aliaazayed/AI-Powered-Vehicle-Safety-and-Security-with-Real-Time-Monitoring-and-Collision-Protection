import 'package:flutter/material.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/widgets/control_card.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.notifications_on_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'Notifications',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.052),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(color: AppColors.textPrimary, thickness: 1),
              const SizedBox(height: 8),
              ControlCard(
                icon: Icons.child_care,
                title: 'Child Detection Alert',
                subtitle: 'child detected in car ... please check !',
                //time: '23:57',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              ControlCard(
                icon: Icons.pets,
                title: 'Pet Detection Alert',
                subtitle: 'Pet detected in car ... please check !',
                //time: '23:54',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              ControlCard(
                icon: Icons.lock,
                title: 'Unauthorized Access',
                subtitle: 'Attempted access without permission.  ',
                //time: '23:49',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
