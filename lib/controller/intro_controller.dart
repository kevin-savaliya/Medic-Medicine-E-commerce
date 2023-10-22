import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medic/model/intro_model.dart';
import 'package:medic/screen/phone_login_screen.dart';
import 'package:medic/utils/app_storage.dart';

class IntroController extends GetxController {
  var selectedPageIndex = 0.obs;

  var pageController = PageController().obs;

  final AppStorage appStorage = AppStorage();

  List<IntroModel> introList = [
    IntroModel("asset/intro1.png", 'Welcome To The Medic',
        'Your Trusted Online Medicine Partner'),
    IntroModel("asset/intro2.png", 'Search & Discover \nMedicines Easily.',
        'Our vast catalog helps you find the right \nmedication every time.'),
    IntroModel("asset/intro3.png", 'Upload Prescriptions \nHassle-free',
        'Securely upload your prescriptions for swift \nverification'),
    IntroModel("asset/intro4.png", 'Timely Medicine \nReminders.',
        'Never miss a dose with our timely \nreminders.')
  ];

  Future<void> redirectToLogin() async {
    appStorage.write(StorageKey.kIsBoardWatched, true);
    Get.offAll(() => const PhoneLoginScreen());
  }
}
