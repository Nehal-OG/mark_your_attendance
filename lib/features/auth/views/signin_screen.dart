import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mark_your_attendance/features/auth/controllers/auth_controller.dart';
import 'package:pinput/pinput.dart';

class SignInScreen extends GetView<AuthController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/splash_logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 48),
              Obx(() => controller.verificationId.isEmpty
                  ? _buildPhoneInput()
                  : _buildOtpInput()),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      children: [
        TextField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: '9334567890',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.sendOTP(isLogin: false),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('Send OTP'),
            )),
        if (controller.error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              controller.error.value,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Column(
      children: [
        const Text(
          'Enter OTP sent to your phone',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Pinput(
          length: 6,
          controller: controller.otpController,
          onCompleted: (pin) => controller.verifyOTP(isLogin: false),
        ),
        const SizedBox(height: 16),
        Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.verifyOTP(isLogin: false),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('Verify OTP'),
            )),
        if (controller.error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              controller.error.value,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
} 