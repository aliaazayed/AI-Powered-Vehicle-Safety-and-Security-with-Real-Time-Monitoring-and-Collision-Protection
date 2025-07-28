import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/models/once_user.dart';
import 'package:test2zfroma/models/permanent_user.dart';

class PermanentUserCard extends StatelessWidget {
  final PermanentUser user;
  final int index;
  final void Function() onRemove;

  const PermanentUserCard({
    required this.user,
    required this.index,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: AppColors.primary,
          width: 1,
        ),
      ),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Icon(Icons.vpn_key_outlined, color: AppColors.primary),
        title: Text(user.name, style: TextStyle(fontSize: 18)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Access : permanent'),
            Text('Auth: BLE'),
            Text('Car ID: ${user.carId}'),
            Row(
              children: [
                Text('Keypass: ${user.keypass}',
                    style: TextStyle(color: AppColors.textPrimary)),
                IconButton(
                  icon: Icon(Icons.copy, size: 18, color: AppColors.primary),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: user.keypass));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Keypass copied'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                title: const Text(
                  'Confirm Deletion',
                  style: TextStyle(color: AppColors.primary),
                ),
                content:
                    const Text('Are you sure you want to remove this user?'),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: const Text('Remove',
                        style: TextStyle(color: Colors.red)),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              onRemove();
            }
          },
        ),
      ),
    );
  }
}

class OneUserCard extends StatelessWidget {
  final OnceUser user;
  final int index;
  final void Function() onRemove; // إزالة من الواجهة فقط

  const OneUserCard({
    required this.user,
    required this.index,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //final isFaceAuth = user.auth == 'face';
    final isFaceAuth = user.auth.toLowerCase() == 'face';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: isFaceAuth
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: user.image != null
                    ? Image.file(
                        // من الجهاز مباشرة
                        user.image!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      )
                    : (user.imageUrl != null
                        ? Image.network(
                            // من الإنترنت
                            user.imageUrl!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.face,
                            color: AppColors.primary)), // لا يوجد صورة
              )
            : const Icon(Icons.vpn_key_outlined, color: AppColors.primary),
        title: Row(
          children: [
            Text(user.name, style: const TextStyle(fontSize: 18)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Auth: ${isFaceAuth ? 'Face' : 'BLE'}'),
            Text('Car ID: ${user.carId}'),
            if (!isFaceAuth && user.keypass != null)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Keypass: ${user.keypass}',
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy,
                        size: 18, color: AppColors.primary),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: user.keypass!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Keypass copied'),
                            backgroundColor: AppColors.success),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                title: const Text('Confirm Deletion'),
                content:
                    const Text('Are you sure you want to remove this user?'),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: const Text('Remove',
                        style: TextStyle(color: Colors.red)),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            );

            print(' ركزي user.imageUrl: ${user.imageUrl}');
            print('user.imageركزي : ${user.image}');

            if (confirm == true) {
              onRemove();
            }
          },
        ),
      ),
    );
  }
}
