import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  static Future<bool> requestAllPermissions() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.camera,
      Permission.photos,
      Permission.location,
      Permission.locationWhenInUse,
      Permission.notification,
      Permission.contacts,
      Permission.microphone,
      Permission.storage,
    ].request();

    bool allGranted = true;
    permissions.forEach((permission, status) {
      if (status != PermissionStatus.granted) {
        allGranted = false;
      }
    });

    return allGranted;
  }

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestPhotosPermission() async {
    final status = await Permission.photos.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestContactsPermission() async {
    final status = await Permission.contacts.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  static Future<void> showPermissionDialog(BuildContext context, String permission) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$permission Permission Required'),
        content: Text('This app needs $permission permission to work properly. Please grant permission in settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  static Future<bool> checkPermissionStatus(Permission permission) async {
    final status = await permission.status;
    return status == PermissionStatus.granted;
  }
}