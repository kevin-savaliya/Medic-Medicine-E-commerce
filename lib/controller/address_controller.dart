import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medic/model/user_address.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/utils.dart';

class AddressController extends GetxController {
  RxList<String> addressList =
      RxList<String>(["Home", "Work", "Hotel", "Other"]);

  RxList<String> addressImgList = RxList<String>(
      [AppIcons.homeAdd, AppIcons.work, AppIcons.hotel, AppIcons.other]);

  RxString selectAdd = "".obs;

  TextEditingController saveAsController = TextEditingController();
  TextEditingController addController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String currentUser = FirebaseAuth.instance.currentUser!.uid;

  final CollectionReference addRef =
      FirebaseFirestore.instance.collection("addresses");

  @override
  void onInit() {
    selectAdd.value = addressList.first;
    super.onInit();
  }

  bool validateData() {
    if (selectAdd == "".obs) {
      showInSnackBar("Please address type",
          title: 'Required!', isSuccess: false);
      return false;
    } else if (addController.text.trim().isEmpty) {
      showInSnackBar("Please enter address.",
          title: 'Required!', isSuccess: false);
      return false;
    } else if (areaController.text.trim().isEmpty) {
      showInSnackBar("Please enter area,sector,location.",
          title: 'Required!', isSuccess: false);
      return false;
    }
    return true;
  }

  clearController() {
    addController.clear();
    selectAdd = "".obs;
    areaController.clear();
    landmarkController.clear();
  }

  Stream<List<UserAddress>> fetchAddress() {
    return addRef.doc(currentUser).snapshots().map((doc) {
      if (doc.exists) {
        List addressList = doc["addresses"] as List;
        List<UserAddress> addresses = addressList.map((address) {
          return UserAddress.fromMap(address);
        }).toList();
        return addresses;
      }
      return [];
    });
  }

  addAddress(UserAddress userAddress) async {
    final addDocRef = addRef.doc(currentUser);
    final doc = await addDocRef.get();

    List<dynamic> addressList = [];

    if (doc.exists) {
      Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;
      addressList = userData != null
          ? (userData['addresses'] as List<dynamic>?) ?? []
          : [];
      if (addressList.isNotEmpty) {
        Map<String, dynamic> lastAddress =
            addressList.last as Map<String, dynamic>;
        lastAddress['isActive'] = false;
        addressList[addressList.length - 1] = lastAddress;
      }
    }

    addressList.add(userAddress.copyWith(isActive: true).toMap());

    if (doc.exists) {
      await addDocRef.update({'addresses': addressList});
    } else {
      await addDocRef.set({'addresses': addressList});
    }

    Get.back();
    Get.back();
    clearController();
    showInSnackBar("Address Added Successfully",
        isSuccess: true, title: "The Medic");
  }
}
