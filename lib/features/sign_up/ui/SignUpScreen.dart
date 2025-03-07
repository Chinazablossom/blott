import 'package:blott/core/utils/constants/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/SignUpController.dart';
import 'NotificationPermissionScreen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController controller = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() => SizedBox(
            height: 60,
            width: 60,
            child: FloatingActionButton.large(
              onPressed: controller.isFormValid.value
                  ? () {
                      controller.saveUserData();
                      Get.to(() => NotificationPermissionScreen());
                    }
                  : null,
              shape: CircleBorder(),
              backgroundColor: controller.isFormValid.value
                  ? primaryColor
                  : Color(0xffaea6ea),
              child: Icon(CupertinoIcons.forward, color: Colors.white),
            ),
          )),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your legal name",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "We need to know a bit about you so that we can create your account.",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: controller.firstNameController,
                decoration: InputDecoration(
                  hintText: "First name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: controller.lastNameController,
                decoration: InputDecoration(
                  hintText: "Last name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
