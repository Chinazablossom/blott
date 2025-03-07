import 'package:blott/features/main/ui/screens/MainScreen.dart';
import 'package:blott/features/sign_up/controller/NotificationController.dart';
import 'package:blott/features/sign_up/controller/SignUpController.dart';
import 'package:blott/features/sign_up/ui/NotificationPermissionScreen.dart';
import 'package:blott/features/sign_up/ui/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final signUpController = Get.put(SignUpController());
    Get.put(NotificationController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blott App',
      themeMode: ThemeMode.system,
      initialRoute: signUpController.determineInitialRoute(),
      getPages: [
        GetPage(name: '/signup', page: () => SignUpScreen()),
        GetPage(name: '/notification', page: () => NotificationPermissionScreen()),
        GetPage(name: '/main', page: () => MainScreen()),
      ],
    );
  }
}
