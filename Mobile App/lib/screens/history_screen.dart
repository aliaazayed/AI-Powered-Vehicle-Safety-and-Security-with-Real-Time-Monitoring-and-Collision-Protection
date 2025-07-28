import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test2zfroma/constants/app_color.dart';
import 'package:test2zfroma/widgets/control_card.dart';

class UserHistoryScreen extends StatefulWidget {
  const UserHistoryScreen({super.key});

  @override
  _UserHistoryScreenState createState() => _UserHistoryScreenState();
}

class _UserHistoryScreenState extends State<UserHistoryScreen> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;
  String errorMessage = '';
  bool isDeleting = false;

  final String azureUrl =
      'https://espconfigs123.blob.core.windows.net/esp32/User_History.json'
      '?sp=rwd&st=2025-07-02T16:24:38Z&se=2025-07-30T00:24:38Z'
      '&spr=https&sv=2024-11-04&sr=b'
      '&sig=YqleS4x%2FApPthPyXEA%2B8%2B9XMgPRqJuh%2FKDS1ZllV7i4%3D';

  @override
  void initState() {
    super.initState();
    fetchAndParseData();
  }

  Future<void> fetchAndParseData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final response = await http.get(Uri.parse(azureUrl));

      if (response.statusCode == 200) {
        final raw = response.body.trim();
        final lines = raw.split('\n');
        List<Map<String, dynamic>> parsedUsers = [];

        for (final line in lines) {
          if (line.trim().isEmpty) continue;

          try {
            // Try parsing as single object first
            final Map<String, dynamic> userRecord = json.decode(line.trim());
            parsedUsers.add(userRecord);
          } catch (e) {
            // If that fails, try parsing as array
            try {
              final List<dynamic> jsonLine = json.decode(line.trim());
              for (var item in jsonLine) {
                if (item is Map<String, dynamic>) {
                  parsedUsers.add(item);
                }
              }
            } catch (e2) {
              print('Error parsing line: $line - $e2');
            }
          }
        }

        setState(() {
          users = parsedUsers;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch blob: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
        isLoading = false;
      });
    }
  }

  Future<void> deleteUser(int index) async {
    if (isDeleting) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Another delete operation is in progress...')),
      );
      return;
    }

    final userToDelete = users[index];

    // Create a backup of current users list
    final originalUsers = List<Map<String, dynamic>>.from(users);

    // Remove from UI immediately for better UX
    setState(() {
      users.removeAt(index);
      isDeleting = true;
      errorMessage = '';
    });

    try {
      // Step 1: Delete the entire blob
      print('Step 1: Deleting blob...');
      final deleteResponse = await http.delete(Uri.parse(azureUrl));

      if (deleteResponse.statusCode != 202) {
        throw Exception('Failed to delete blob: ${deleteResponse.statusCode}');
      }

      // Step 2: Create new append blob
      print('Step 2: Creating new append blob...');
      final createResponse = await http.put(
        Uri.parse(azureUrl),
        headers: {
          'x-ms-blob-type': 'AppendBlob',
          'Content-Length': '0',
        },
        body: '',
      );

      if (createResponse.statusCode != 201) {
        throw Exception(
            'Failed to create new blob: ${createResponse.statusCode}');
      }

      // Step 3: Append each remaining user record
      print('Step 3: Appending ${users.length} records...');
      for (int i = 0; i < users.length; i++) {
        final user = users[i];
        final recordData = '${json.encode(user)}\n';

        final appendResponse = await http.put(
          Uri.parse('$azureUrl&comp=appendblock'),
          headers: {
            'Content-Type': 'text/plain',
            'Content-Length': recordData.length.toString(),
          },
          body: recordData,
        );

        if (appendResponse.statusCode != 201) {
          throw Exception(
              'Failed to append record ${i + 1}: ${appendResponse.statusCode}');
        }

        // Update progress for large datasets
        if (users.length > 10 && i % 5 == 0) {
          print('Progress: ${i + 1}/${users.length} records appended');
        }
      }

      setState(() {
        isDeleting = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User "${userToDelete['user']}" deleted successfully'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 3),
        ),
      );

      print('Delete operation completed successfully');
    } catch (e) {
      print('Delete operation failed: $e');

      setState(() {
        // Restore original data on failure
        users = originalUsers;
        isDeleting = false;
        errorMessage = 'Failed to delete user: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete user: ${e.toString()}'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 5),
        ),
      );

      // Try to recover by refetching data
      await Future.delayed(Duration(seconds: 2));
      fetchAndParseData();
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context, int index) async {
    final user = users[index];

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissing during delete operation
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete this user?'),
              SizedBox(height: 8),
              Text('User: ${user['user'] ?? 'Unknown'}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Action: ${user['action'] ?? 'No action'}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Text('Warning',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            )),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'This will recreate the entire blob. The operation may take several seconds.',
                      style: TextStyle(
                          fontSize: 12, color: Colors.orange.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isDeleting ? null : () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isDeleting
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      deleteUser(index);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: isDeleting
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.description_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'History',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          if (isDeleting)
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: isDeleting ? null : fetchAndParseData,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.052),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: AppColors.textPrimary, thickness: 1),
            if (isDeleting)
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Deleting user and recreating blob...',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  color: AppColors.error, size: 48),
                              SizedBox(height: 16),
                              Text(
                                errorMessage,
                                style: TextStyle(color: AppColors.error),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: fetchAndParseData,
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : users.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inbox,
                                      color: AppColors.inputBackground,
                                      size: 48),
                                  SizedBox(height: 16),
                                  Text('No users found.',
                                      style: TextStyle(
                                          color: AppColors.textSecondary)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return ControlCardWithDelete(
                                  icon: Icons.person_outline_rounded,
                                  title: 'User: ${user['user'] ?? 'Unknown'}',
                                  subtitle:
                                      'Action: ${user['action'] ?? 'No action'}',
                                  time: null,
                                  onDelete: isDeleting
                                      ? () {}
                                      : () => _showDeleteConfirmation(
                                          context, index),
                                  onTap: () {},
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
