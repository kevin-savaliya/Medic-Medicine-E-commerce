// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medic/model/discount_data_model.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/model/order_data.dart';
import 'package:medic/model/prescription_model.dart';
import 'package:medic/model/review_data_model.dart';
import 'package:medic/model/user_address.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/utils/utils.dart';
import 'package:path/path.dart';

class CartController extends GetxController {
  final RxList cartItems = [].obs;
  RxInt qty = 1.obs;
  RxDouble rating = RxDouble(0);

  RxList<DiscountDataModel> discounts = <DiscountDataModel>[].obs;

  RxString selectedMedicineName = "".obs;
  RxString selectedMedicineId = "".obs;
  RxList<String> medicineName = RxList<String>();
  RxMap<String, String> idToNameMap = RxMap<String, String>();

  TextEditingController reviewText = TextEditingController();

  final CollectionReference medicineRef =
      FirebaseFirestore.instance.collection("medicines");

  final CollectionReference discountRef =
      FirebaseFirestore.instance.collection("discounts");

  final CollectionReference prescriptionRef =
      FirebaseFirestore.instance.collection("prescriptions");

  final CollectionReference reviewRef =
      FirebaseFirestore.instance.collection("reviews");

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection("users");

  DiscountDataModel? selectedDiscount;
  RxString discountName = "".obs;

  String prescriptionId = "";

  late final cartRef = FirebaseFirestore.instance
      .collection("users")
      .doc(currentUser)
      .collection("cart");

  final orderRef = FirebaseFirestore.instance.collection("orders");

  final CollectionReference addRef =
      FirebaseFirestore.instance.collection("addresses");

  final String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  final firebaseUser = FirebaseAuth.instance.currentUser;

  Rx<OrderData> orderData = OrderData(medicineId: {}).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchDiscount();
    fetchMedicineFromCart();
    fetchActiveAddress();
    update();
  }

  void fetchDiscount() {
    discountRef.snapshots().listen((snapshot) {
      discounts.assignAll(snapshot.docs.map((doc) {
        return DiscountDataModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList());
    });
  }

  void applyDiscount() {
    if (discounts.isNotEmpty) {
      final randomIndex = Random().nextInt(discounts.length);
      selectedDiscount = discounts[randomIndex];
      orderData.value.discountId = selectedDiscount!.id;
      discountName.value = selectedDiscount?.discountName ?? "";
      print("Applied Discount : ${selectedDiscount!.discountName}");
    } else {
      print("No Discount Available");
    }
  }

  Future<void> addToCart(MedicineData medicine, {int qty = 1}) async {
    if (!orderData.value.medicineId.values.toList().contains(medicine.id)) {
      orderData.value.medicineId.addAll({
        orderData.value.medicineId.length.toString(): medicine.id.toString()
      });
    }

    orderData.value.medicineData ??= [];

    MedicineData? existMedicine;
    try {
      existMedicine = orderData.value.medicineData!
          .firstWhere((element) => element.id == medicine.id);
    } catch (e) {
      if (e is! StateError) {
        rethrow;
      }
    }

    if (existMedicine == null) {
      orderData.value.medicineData?.add(medicine.copyWith(quantity: qty));
    }
    update();
  }

  void incrementQuantity(String medicineId) {
    var updatedMedicines =
        List<MedicineData>.from(orderData.value.medicineData ?? []);
    var medicine = updatedMedicines.firstWhere((m) => m.id == medicineId);
    medicine.quantity = (medicine.quantity ?? 0) + 1;

    orderData.value.medicineData = updatedMedicines;
    update();
  }

  void decrementQuantity(String medicineId) {
    var updatedMedicines =
        List<MedicineData>.from(orderData.value.medicineData ?? []);
    var medicine = updatedMedicines.firstWhere((m) => m.id == medicineId);
    if (medicine.quantity! > 0) {
      medicine.quantity = (medicine.quantity ?? 0) - 1;
    }

    orderData.value.medicineData = updatedMedicines;
    update();
  }

  Future<void> _addToCart(MedicineData medicine, [int qty = 2]) async {
    Map<String, dynamic> medicineQty = medicine.toMap();
    medicineQty['quantity'] = qty;
    await cartRef.doc(medicine.id).set(medicineQty);
  }

  Future<void> removeFromCart(String medicineId) async {
    if (orderData.value.medicineId.isNotEmpty) {
      Map<String, String> updatedMedicineIds =
          Map.from(orderData.value.medicineId);
      updatedMedicineIds.removeWhere((key, value) => value == medicineId);
      orderData.value.medicineId = updatedMedicineIds;
    }

    if (orderData.value.medicineData != null &&
        orderData.value.medicineData!.isNotEmpty) {
      List<MedicineData> updatedMedicineData =
          List.from(orderData.value.medicineData!);
      updatedMedicineData.removeWhere((element) => element.id == medicineId);
      orderData.value.medicineData = updatedMedicineData;
    }
    update();
  }

  Future<void> _removeFromCart(String medicineId) async {
    await cartRef.doc(medicineId).delete();
  }

  Stream<List<MedicineData>> fetchMedicineFromCart() {
    return cartRef.snapshots().map((event) {
      return event.docs.map((e) {
        print('e.data() ${e.data()}');
        return MedicineData.fromMap(e.data());
      }).toList();
    });
  }

  Stream<UserAddress?> fetchActiveAddress() {
    final firestore = FirebaseFirestore.instance;
    final addDocRef = firestore.collection('addresses').doc(currentUser);

    return addDocRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        List<dynamic> addressList = snapshot.data()?['addresses'] ?? [];
        for (final address in addressList) {
          Map<String, dynamic> addressMap = address as Map<String, dynamic>;
          if (addressMap['isActive'] == true) {
            return UserAddress.fromMap(addressMap);
          }
        }
      }
      return null;
    });
  }

  Stream<PrescriptionData?> fetchPrescriptionData() {
    return prescriptionRef.doc(currentUser).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic> prescriptions = snapshot.get('prescriptions');
        var prescriptionMap = prescriptions.firstWhere((prescription) =>
            prescription['id'] == "${orderData.value.prescriptionId}");
        if (prescriptionMap != null) {
          return PrescriptionData.fromMap(prescriptionMap);
        }
      }
      return null;
    });
  }

  Future<bool> isMedicineInApprovedPrescription(String medicineId) async {
    try {
      DocumentSnapshot prescriptionDoc =
          await prescriptionRef.doc(currentUser).get();

      if (prescriptionDoc.exists && prescriptionDoc.data() != null) {
        var data = prescriptionDoc.data() as Map<String, dynamic>;
        var prescriptionsList = data['prescriptions'] as List<dynamic>;

        for (var prescriptionMap in prescriptionsList) {
          PrescriptionData prescription =
              PrescriptionData.fromMap(prescriptionMap as Map<String, dynamic>);

          if (prescription.isApproved == true &&
              prescription.medicineList?.contains(medicineId) == true) {
            prescriptionId = prescription.id!;
            orderData.value.prescriptionId = prescription.id!;
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print('An error occurred while checking prescriptions: $e');
      return false;
    }
  }

  Future<bool> checkPrescriptionOrder(List<MedicineData> medicineList) async {
    for (MedicineData medicine in medicineList) {
      bool isApproved = await isMedicineInApprovedPrescription(medicine.id!);

      if (!isApproved) {
        return false;
      }
    }
    return true;
  }

  Future<bool> checkPrescriptionStatus(
      String medicineId, BuildContext context) async {
    final CollectionReference prescriptionsRef =
        FirebaseFirestore.instance.collection('prescriptions');

    try {
      final DocumentSnapshot userPrescriptionDoc =
          await prescriptionsRef.doc(currentUser).get();

      if (userPrescriptionDoc.exists && userPrescriptionDoc.data() != null) {
        if (await checkMedicinePrescriptionRequirement(medicineId)) {
          var data = userPrescriptionDoc.data() as Map<String, dynamic>;
          var prescriptionList = data['prescriptions'] as List<dynamic>;

          for (var prescriptionMap in prescriptionList) {
            PrescriptionData prescription = PrescriptionData.fromMap(
                prescriptionMap as Map<String, dynamic>);

            if (prescription.isApproved != true &&
                prescription.medicineList?.contains(medicineId) == true) {
              return true;
            }
          }
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      print('Error checking prescription status: $e');
      return false;
    }
  }

  Future<bool> checkMedicinePrescriptionRequirement(String medicineId) async {
    final CollectionReference medicinesRef =
        FirebaseFirestore.instance.collection('medicines');

    try {
      final DocumentSnapshot medicineDoc =
          await medicinesRef.doc(medicineId).get();

      if (medicineDoc.exists && medicineDoc.data() != null) {
        var data = medicineDoc.data() as Map<String, dynamic>;
        var prescriptionRequired = data['prescriptionRequire'] as bool;

        return prescriptionRequired ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking medicine prescription requirement: $e');
      return false;
    }
  }

  Future<void> placeOrder() async {
    orderData.value.id = orderRef.doc().id;

    final _orderData = orderData.value.copyWith(
        id: orderData.value.id,
        creatorId: currentUser,
        medicineId: orderData.value.medicineId,
        prescriptionId: orderData.value.prescriptionId,
        addressId: orderData.value.addressId,
        orderDate: DateTime.now());

    await orderRef.doc(orderData.value.id).set(_orderData.toMap());
    Get.back();
    showInSnackBar("Order Placed Successfully",
        isSuccess: true, title: "The Medic");
  }

  Future<void> uploadReview(ReviewDataModel review) async {
    await reviewRef.doc(review.id).set(review.toMap()).then((value) {
      Get.back();
      Get.back();
      showInSnackBar("Review Added Successfully",
          isSuccess: true, title: "The Medic");
      rating.value = 0.0;
      reviewText.clear();
      selectedMedicineName.value = "";
      selectedMedicineId.value = "";
      idToNameMap = RxMap<String, String>();
      medicineName = RxList<String>();
    }).onError((error, stackTrace) {
      showInSnackBar("Error : $error");
    });
  }

  Future<OrderData?> fetchOrderIds() async {
    try {
      DocumentSnapshot snapshot = await orderRef.doc(orderData.value.id).get();

      if (snapshot.exists && snapshot.data() != null) {
        return OrderData.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        showInSnackBar("Document Doesn't Exist");
        return null;
      }
    } catch (e) {
      print("Error Fetching Data : $e");
      return null;
    }
  }

  Stream<UserModel?> fetchUserById(String userid) {
    return userRef.doc(userid).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  Stream<PrescriptionData?>? fetchPrescriptionById(String prescriptionId) {
    try {
      return prescriptionRef.doc(currentUser).snapshots().map((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          List<dynamic> prescriptions = snapshot.get('prescriptions');
          var prescriptionMap = prescriptions.firstWhere(
              (prescription) => prescription['id'] == prescriptionId);
          if (prescriptionMap != null) {
            return PrescriptionData.fromMap(prescriptionMap);
          }
        }
        return null;
      });
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Stream<UserAddress?>? fetchAddressById(String addressId) {
    try {
      return addRef.doc(currentUser).snapshots().map((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          List<dynamic> addresses = snapshot.get('addresses');
          var addressMap =
              addresses.firstWhere((address) => address['id'] == addressId);
          if (addressMap != null) {
            return UserAddress.fromMap(addressMap);
          }
        }
        return null;
      });
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  void fetchMedicineNames(List<String?> medicineIds) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference medicineCollection =
        firestore.collection('medicines');
    for (String? id in medicineIds) {
      DocumentSnapshot snapshot = await medicineCollection.doc(id).get();
      if (snapshot.exists) {
        String name = snapshot['genericName'];
        idToNameMap[id!] = name;
        medicineName.add(name);
      }
    }
  }

  void selectedReviewMedicine(String name) {
    selectedMedicineName.value = name;
    selectedMedicineId.value =
        idToNameMap.keys.firstWhere((id) => idToNameMap[id] == name);
  }
}
