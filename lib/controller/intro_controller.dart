import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medic/model/intro_model.dart';

class IntroController extends GetxController {
  var selectedPageIndex = 0.obs;

  var pageController = PageController().obs;

  List<IntroModel> introList = [
    IntroModel(
        "", 'Welcome To The Medic', 'Your Trusted Online Medicine Partner'),
    IntroModel("", 'Search & Discover \nMedicines Easily.',
        'Our vast catalog helps you find the right \nmedication every time.'),
    IntroModel("", 'Upload Prescriptions \nHassle-free',
        'Securely upload your prescriptions for swift \nverification'),
    IntroModel("", 'Timely Medicine \nReminders.',
        'Never miss a dose with our timely \nreminders.')
  ];
}
