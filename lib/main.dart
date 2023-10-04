import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medic/screen/splash_screen.dart';
import 'package:medic/theme/colors_theme.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        enableLog: true,
        initialRoute: '/',
        useInheritedMediaQuery: true,
        title: 'Medic',
        theme: ThemeColor.mThemeData(context),
        darkTheme: ThemeColor.mThemeData(context, isDark: true),
        // initialBinding: GlobalBindings(),
        defaultTransition: Transition.cupertino,
        opaqueRoute: Get.isOpaqueRouteDefault,
        popGesture: Get.isPopGestureEnable,
        transitionDuration: const Duration(milliseconds: 500),
        defaultGlobalState: true,
        themeMode: ThemeMode.light,
        home: SplashScreen());
  }
}
