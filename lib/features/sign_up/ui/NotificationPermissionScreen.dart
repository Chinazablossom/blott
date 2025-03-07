import 'package:blott/core/utils/constants/Colors.dart';
import 'package:blott/core/utils/constants/assetsPaths.dart';
import 'package:blott/features/sign_up/controller/SignUpController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPermissionScreen extends StatelessWidget {
  NotificationPermissionScreen({super.key});

  final SignUpController signUpController = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(notifIcon), fit: BoxFit.contain),
            Text(
              "Get the most out of Blott ✅",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Allow notifications to stay in the loop with your payments, requests and groups.",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            Get.dialog(
              Center(child: CircularProgressIndicator()),
              barrierDismissible: false,
            );

            try {
              await signUpController.requestNotificationPermission();
              Get.back();
              signUpController.setHasSeenNotificationScreen(true);
              Get.offAllNamed('/main');
            } catch (e) {
              Get.back();
              print('Error requesting notification: $e');
              signUpController.setHasSeenNotificationScreen(true);
              Get.offAllNamed('/main');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.all(10),
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text("Continue", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
