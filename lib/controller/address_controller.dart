import 'dart:developer';

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
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Rx<UserAddress?> currentEditing = Rx<UserAddress?>(null);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String? currentUser = FirebaseAuth.instance.currentUser?.uid;

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
    saveAsController.clear();
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

  // addAddress(UserAddress userAddress) async {
  //   final addDocRef = addRef.doc(currentUser);
  //   final doc = await addDocRef.get();
  //
  //   List<dynamic> addressList = [];
  //
  //   if (doc.exists) {
  //     Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;
  //     addressList = userData != null
  //         ? (userData['addresses'] as List<dynamic>?) ?? []
  //         : [];
  //     if (addressList.isNotEmpty) {
  //       Map<String, dynamic> lastAddress =
  //           addressList.last as Map<String, dynamic>;
  //       lastAddress['isActive'] = false;
  //       addressList[addressList.length - 1] = lastAddress;
  //     }
  //   }
  //
  //   addressList.add(userAddress.copyWith(isActive: true).toMap());
  //
  //   if (doc.exists) {
  //     await addDocRef.update({'addresses': addressList});
  //   } else {
  //     await addDocRef.set({'addresses': addressList});
  //   }
  //
  //   Get.back();
  //   Get.back();
  //   clearController();
  //   showInSnackBar("Address Added Successfully",
  //       isSuccess: true, title: "The Medic");
  // }

  addAddress(UserAddress userAddress) async {
    final addDocRef = addRef.doc(currentUser);
    final doc = await addDocRef.get();

    List<dynamic> addressList = [];

    if (doc.exists) {
      Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;
      addressList = userData != null
          ? (userData['addresses'] as List<dynamic>?) ?? []
          : [];

      for (var i = 0; i < addressList.length; i++) {
        (addressList[i] as Map<String, dynamic>)['isActive'] = false;
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


  editAddress(UserAddress userAddress) async {
    final addDocRef = addRef.doc(currentUser);
    final doc = await addDocRef.get();

    if (!doc.exists) return;

    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    List<dynamic> addressList =
        data != null ? (data['addresses'] as List<dynamic>?) ?? [] : [];

    int editIndex = addressList.indexWhere(
        (address) => (address as Map<String, dynamic>)['id'] == userAddress.id);

    if (editIndex != -1) {
      for (var i = 0; i < addressList.length; i++) {
        (addressList[i] as Map<String, dynamic>)['isActive'] = false;
      }
      addressList[editIndex] = userAddress.copyWith(isActive: true).toMap();

      await addDocRef.update({'addresses': addressList});
    }

    Get.back();
    Get.back();
    clearController();
    showInSnackBar("Address Edited Successfully",
        isSuccess: true, title: "The Medic");
  }

  // deleteAddress(String addressId) async {
  //   final addDocRef = addRef.doc(currentUser);
  //   final doc = await addDocRef.get();
  //
  //   if (!doc.exists) return;
  //
  //   Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;
  //   List<dynamic> addressList =
  //       userData != null ? (userData['addresses'] as List<dynamic>?) ?? [] : [];
  //
  //   Map<String, dynamic>? deletedAddress;
  //   addressList = addressList.where((address) {
  //     bool shouldKeep = (address as Map<String, dynamic>)['id'] != addressId;
  //     if (!shouldKeep) deletedAddress = address;
  //     return shouldKeep;
  //   }).toList();
  //
  //   if (deletedAddress != null &&
  //       deletedAddress!['isActive'] == true &&
  //       addressList.isNotEmpty) {
  //     Map<String, dynamic> newLastActive =
  //         addressList.last as Map<String, dynamic>;
  //     newLastActive['isActive'] = true;
  //     addressList[addressList.length - 1] = newLastActive;
  //   }
  //
  //   await addDocRef.update({'addresses': addressList});
  // }

  deleteAddress(String addressId) async {
    final addDocRef = addRef.doc(currentUser);
    final doc = await addDocRef.get();

    if (!doc.exists) return;

    Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;
    List<dynamic> addressList =
        userData != null ? (userData['addresses'] as List<dynamic>?) ?? [] : [];

    Map<String, dynamic>? deletedAddress;
    addressList = addressList.where((address) {
      bool shouldKeep = (address as Map<String, dynamic>)['id'] != addressId;
      if (!shouldKeep) deletedAddress = address;
      return shouldKeep;
    }).toList();

    if (deletedAddress != null &&
        deletedAddress!['isActive'] == true &&
        addressList.isNotEmpty) {
      for (var i = 0; i < addressList.length; i++) {
        (addressList[i] as Map<String, dynamic>)['isActive'] = false;
      }
      (addressList.last as Map<String, dynamic>)['isActive'] = true;
    }

    await addDocRef.update({'addresses': addressList});
  }

  Future<void> updateAddressStatus(String? addressId, bool isActive) async {
    if (addressId == null) {
      throw ArgumentError("Address ID cannot be null");
    }

    DocumentReference addressDoc = addRef.doc(currentUser);

    DocumentSnapshot docSnapshot = await addressDoc.get();
    if (docSnapshot.exists) {
      List<dynamic> addresses = docSnapshot.get('addresses');

      List<Map<String, dynamic>> updatedAddresses = addresses.map((a) {
        Map<String, dynamic> addressMap = Map<String, dynamic>.from(a);
        if (addressMap['id'] == addressId) {
          addressMap['isActive'] = isActive;
        } else {
          addressMap['isActive'] = false;
        }
        return addressMap;
      }).toList();

      await addressDoc.update({'addresses': updatedAddresses});
    }
  }
}
