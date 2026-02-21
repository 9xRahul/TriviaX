import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triviax/view/screens/home_screen.dart';
import 'core/theme.dart';
import 'controllers/theme_controller.dart';

class TriviaXApp extends StatelessWidget {
  const TriviaXApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // default mode
      home: const HomeScreen(),
    );
  }
}
