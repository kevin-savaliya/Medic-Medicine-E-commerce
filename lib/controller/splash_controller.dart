import 'package:get/get.dart';
import 'package:medic/screen/intro_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Get.offAll(const IntroScreen());
    });
  }
}
