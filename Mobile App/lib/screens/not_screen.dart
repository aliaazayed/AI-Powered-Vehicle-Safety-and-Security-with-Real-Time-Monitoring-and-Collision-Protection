import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test2zfroma/constants/app_color.dart';
import 'package:xml/xml.dart';

class NotificationModel {
  final String timestamp;
  final String alertType;
  final String message;
  final double elapsedTimeSeconds;
  final String severity;
  final String location;
  final String notificationId;
  final String fileName; // Add this to track the actual filename

  NotificationModel({
    required this.timestamp,
    required this.alertType,
    required this.message,
    required this.elapsedTimeSeconds,
    required this.severity,
    required this.location,
    required this.notificationId,
    required this.fileName,
  });

  factory NotificationModel.fromJson(
      Map<String, dynamic> json, String fileName) {
    return NotificationModel(
      timestamp: json['timestamp'] ?? '',
      alertType: json['alert_type'] ?? '',
      message: json['message'] ?? '',
      elapsedTimeSeconds: (json['elapsed_time_seconds'] ?? 0).toDouble(),
      severity: json['severity'] ?? '',
      location: json['location'] ?? '',
      notificationId: json['notification_id'] ?? '',
      fileName: fileName, // Store the actual filename
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationModel> notifications = [];
  bool isLoading = false;
  String? error;

  final String baseUrl =
      'https://ai321.blob.core.windows.net/childnotofication';
  final String sasToken =
      'sp=racwdli&st=2025-07-03T17:21:56Z&se=2025-08-01T01:21:56Z&spr=https&sv=2024-11-04&sr=c&sig=kIZJ%2BfAk7tYC7tQdTItm3tTWBcAFFruD7t6iJ2g3Ojc%3D';

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final listUrl = '$baseUrl?restype=container&comp=list&$sasToken';
      final listResponse = await http.get(Uri.parse(listUrl));

      if (listResponse.statusCode == 200) {
        final document = XmlDocument.parse(listResponse.body);
        final blobs = document.findAllElements('Name');

        List<NotificationModel> fetchedNotifications = [];

        for (var blob in blobs) {
          final fileName = blob.text;
          if (fileName.endsWith('.json')) {
            try {
              final fileUrl = '$baseUrl/$fileName?$sasToken';
              final fileResponse = await http.get(Uri.parse(fileUrl));

              if (fileResponse.statusCode == 200) {
                final jsonData = json.decode(fileResponse.body);
                // Pass the actual filename to the model
                final notification =
                    NotificationModel.fromJson(jsonData, fileName);
                fetchedNotifications.add(notification);
              }
            } catch (e) {
              print('Error parsing file $fileName: $e');
            }
          }
        }

        fetchedNotifications.sort((a, b) =>
            DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

        setState(() {
          notifications = fetchedNotifications;
          isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to fetch blob list: ${listResponse.statusCode}');
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching notifications: $e';
        isLoading = false;
      });
    }
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    // Show confirmation dialog
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Notification'),
          content: Text('Are you sure you want to delete this notification?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    try {
      // Delete using the actual filename stored in the model
      final deleteUrl = '$baseUrl/${notification.fileName}?$sasToken';
      final response = await http.delete(Uri.parse(deleteUrl));

      if (response.statusCode == 202) {
        // Remove from local list using the notification object, not index
        setState(() {
          notifications.removeWhere((n) => n.fileName == notification.fileName);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete file: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting notification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }

  Color getAlertColor(String alertType) {
    switch (alertType.toLowerCase()) {
      case 'situation_resolved':
        return AppColors.primary;
      case 'warning':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      case 'info':
        return AppColors.textSecondary;
      default:
        return AppColors.inputBackground;
    }
  }

  IconData getAlertIcon(String alertType) {
    switch (alertType.toLowerCase()) {
      case 'situation_resolved':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'critical':
        return Icons.error;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.notifications_active_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'Notifactions',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchNotifications,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          error!,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchNotifications,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : notifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_off,
                                size: 64, color: AppColors.textSecondary),
                            SizedBox(height: 16),
                            Text(
                              'No notifications found',
                              style: TextStyle(
                                  fontSize: 18, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];

                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: getAlertColor(notification.alertType),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                leading: Icon(
                                  getAlertIcon(notification.alertType),
                                  color: getAlertColor(notification.alertType),
                                  size: 30,
                                ),
                                title: Text(
                                  notification.message,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 6),
                                    Text(
                                      'Type: ${notification.alertType}',
                                      style: TextStyle(
                                          color: AppColors.textSecondary),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      formatTimestamp(notification.timestamp),
                                      style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () =>
                                      deleteNotification(notification),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
