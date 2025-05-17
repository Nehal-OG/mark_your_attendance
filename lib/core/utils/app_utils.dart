import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AppUtils {
  static StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  static bool _isShowingConnectivityMessage = false;

  static Future<bool> ensureLocationAccess() async {
    try {
      // Check location permission
      final status = await Permission.location.status;
      if (status.isDenied) {
        final result = await Permission.location.request();
        if (result.isDenied) {
          Get.snackbar(
            'Location Permission Required',
            'Please enable location permission to use this feature.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            mainButton: TextButton(
              onPressed: () => openAppSettings(),
              child: const Text(
                'Open Settings',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
          return false;
        }
      }

      if (status.isPermanentlyDenied) {
        Get.snackbar(
          'Location Permission Required',
          'Please enable location permission in app settings.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () => openAppSettings(),
            child: const Text(
              'Open Settings',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return false;
      }

      // Check if location services are enabled
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        Get.dialog(
          AlertDialog(
            title: const Text('Location Services Disabled'),
            content: const Text(
                'Please enable location services to use this feature.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  await Geolocator.openLocationSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        return false;
      }

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to access location services: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  static Future<bool> ensureInternetAccess() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _showConnectivityMessage(false);
        return false;
      }
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check internet connectivity: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  static void startConnectivityListener() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _showConnectivityMessage(result != ConnectivityResult.none);
    });
  }

  static void stopConnectivityListener() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  static void _showConnectivityMessage(bool isConnected) {
    if (_isShowingConnectivityMessage) {
      Get.closeCurrentSnackbar();
    }

    if (!isConnected) {
      _isShowingConnectivityMessage = true;
      Get.snackbar(
        'No Internet Connection',
        'You are offline. Please turn on Internet.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(days: 1), // Keep showing until connected
        isDismissible: false,
      );
    } else if (_isShowingConnectivityMessage) {
      _isShowingConnectivityMessage = false;
      Get.snackbar(
        'Connected',
        'Internet connection restored',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
} 