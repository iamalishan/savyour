import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_web/screens/add_brand/view/add_brand_screen.dart';
import 'package:ecommerce_web/screens/add_brand/view/add_coupon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/brand_model.dart';

class PasswordAlertController extends GetxController {
  int _tapCount = 0;
  Timer? _tapTimer;

  void handleTap(BuildContext context, String type, Brand? brand) {
    _tapCount++;

    _tapTimer?.cancel();
    _tapTimer = Timer(const Duration(seconds: 2), () {
      _tapCount = 0;
    });

    if (_tapCount == 5) {
      _tapCount = 0;
      _tapTimer?.cancel();
      showPasswordAlert(context, type, brand);
    }
  }

  void showPasswordAlert(BuildContext context, String type, Brand? brand) {
    showDialog(
      context: context,
      builder: (_) {
        final TextEditingController passwordController = TextEditingController();

        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final inputPassword = passwordController.text.trim();
                final bool isValid = await _validatePassword(inputPassword);

                if (isValid) {
                  Get.back();
                  if (type == 'addBrand') {
                    Get.to(() => AddBrandScreen());
                  } else if (type == 'addCoupon' && brand != null) {
                    Get.to(() => AddCouponScreen(brand: brand));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect Password!')),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _validatePassword(String inputPassword) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('admin')
          .doc('password')
          .get();

      final storedPassword = doc.data()?['passkey'];
      return storedPassword == inputPassword;
    } catch (e) {
      print("Error fetching password from Firestore: $e");
      return false;
    }
  }

  @override
  void onClose() {
    _tapTimer?.cancel();
    super.onClose();
  }
}
