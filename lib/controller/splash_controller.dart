import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:medic/controller/user_controller.dart';
import 'package:medic/screen/home_screen.dart';
import 'package:medic/screen/intro_screen.dart';
import 'package:medic/screen/phone_login_screen.dart';
import 'package:medic/utils/app_storage.dart';

class SplashController extends GetxController {
  RxBool isUpdatingData = false.obs;
  RxBool timerCompleted = false.obs;

  final AppStorage appStorage = AppStorage();

  @override
  void onInit() {
    super.onInit();
    updateUserTokenToFirebase().then((value) {
      isUpdatingData.value = true;
      _checkNavigation();
    });

    Timer(const Duration(seconds: 3), () {
      timerCompleted.value = true;
      _checkNavigation();
    });
  }

  void _checkNavigation() {
    if (isUpdatingData.value && timerCompleted.value) {
      _redirectToNextScreen();
    }
  }

  Future<void> updateUserTokenToFirebase() async {
    // if user is logged in then update token to firebase
    if (Get.find<UserController>().firebaseUser != null) {
      final String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(Get.find<UserController>().loggedInUser.value!.id)
              .update({'fcmToken': token});
        } catch (e) {
          print(e);
        }
      }
      return;
    }
    return;
  }

  Future<void> _redirectToNextScreen() async {
    if (appStorage.checkLoginAndUserData()) {
      await Get.offAll(() => const HomeScreen());
    } else {
      if (appStorage.isBoardWatched()) {
        await Get.offAll(() => const PhoneLoginScreen());
      } else {
        await Get.offAll(() => const IntroScreen());
      }
    }
  }
}
