
import 'package:blott/features/sign_up/controller/NotificationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SignUpController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final isFormValid = false.obs;
  final hasCompletedSignUp = false.obs;
  final hasGrantedNotifications = false.obs;
  final hasSeenNotificationScreen = false.obs;

  final storage = GetStorage();

  NotificationController get notificationController =>
       Get.put(NotificationController());

  @override
  void onInit() {
    super.onInit();
    checkExistingUser();

    firstNameController.addListener(validateForm);
    lastNameController.addListener(validateForm);
  }

  void validateForm() {
    isFormValid.value = firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty;
  }

  void saveUserData() {
    storage.write('firstName', firstNameController.text.trim());
    storage.write('lastName', lastNameController.text.trim());
    storage.write('hasCompletedSignUp', true);

    hasCompletedSignUp.value = true;
  }

  Future<bool> requestNotificationPermission() async {
    bool granted = await notificationController.requestNotificationPermission();
    hasGrantedNotifications.value = granted;
    return granted;
  }

  void setHasSeenNotificationScreen(bool seen) {
    storage.write('hasSeenNotificationScreen', seen);
    hasSeenNotificationScreen.value = seen;
  }

  void checkExistingUser() {
    if (storage.hasData('hasCompletedSignUp')) {
      hasCompletedSignUp.value = storage.read('hasCompletedSignUp') ?? false;
    }

    // checks notification permission status
    notificationController.checkNotificationPermission().then((granted) {
      hasGrantedNotifications.value = granted;
    });

    // checks if user has seen notification screen
    if (storage.hasData('hasSeenNotificationScreen')) {
      hasSeenNotificationScreen.value = storage.read('hasSeenNotificationScreen') ?? false;
    }
  }

  String determineInitialRoute() {
    if (!hasCompletedSignUp.value) {
      // if new user -> show signup screen
      return '/signup';
    } else if (!hasSeenNotificationScreen.value) {
      // if user has completed signup but hasn't seen notification screen
      return '/notification';
    } else {
      // if user has gone through everything
      return '/main';
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}