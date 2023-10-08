import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medic/utils/assets.dart';

class AddressController extends GetxController {
  RxList<String> addressList =
      RxList<String>(["Home", "Work", "Hotel", "Other"]);

  RxList<String> addressImgList = RxList<String>(
      [AppIcons.homeAdd, AppIcons.work, AppIcons.hotel, AppIcons.other]);

  RxString selectAdd = "".obs;

  TextEditingController saveAsController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();

  @override
  void onInit() {
    selectAdd.value = addressList.first;
    super.onInit();
  }
}
