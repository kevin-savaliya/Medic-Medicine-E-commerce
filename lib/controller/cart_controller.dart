// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names, unrelated_type_equality_checks

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medic/model/credit_card_model.dart';
import 'package:medic/model/discount_data_model.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/model/order_data.dart';
import 'package:medic/model/order_with_medicine.dart';
import 'package:medic/model/prescription_model.dart';
import 'package:medic/model/review_data_model.dart';
import 'package:medic/model/user_address.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/utils/utils.dart';

class CartController extends GetxController {
  final RxList cartItems = [].obs;
  RxInt qty = 1.obs;
  RxDouble rating = RxDouble(0);

  RxList<String> preRequireList = <String>[].obs;

  TextEditingController expDateController = TextEditingController();

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

  final CollectionReference cardRef =
      FirebaseFirestore.instance.collection("cards");

  final Rx<DiscountDataModel?> selectedDiscount = Rx<DiscountDataModel?>(null);
  RxString discountName = "".obs;
  RxDouble discountPercentage = 0.0.obs;
  RxDouble discountAmount = 0.0.obs;
  RxString discountCode = "".obs;

  RxDouble shippingFee = 100.0.obs;

  String prescriptionId = "";

  TextEditingController disCodeController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardHolderController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  RxString selectedMonth = '01'.obs;
  RxString selectedYear = DateTime.now().year.toString().obs;

  List<String> get months => List<String>.generate(
      12, (index) => (index + 1).toString().padLeft(2, '0'));

  List<String> get years => List<String>.generate(
      50, (index) => (DateTime.now().year + index).toString());

  RxInt cartQty = 1.obs;

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

  var isDiscountValid = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchMedicineFromCart();
    fetchActiveAddress();
    fetchAndSelectDiscount();
    expDateController.addListener(_formatExpiryDate);
    cardNumberController.addListener(_formatCreditCardNumber);
    update();
  }

  bool checkMedicineInCart(String medicineId) {
    return orderData.value.medicineId.containsValue(medicineId);
  }

  Future<List<DiscountDataModel>> fetchAllDiscounts() async {
    var querySnapshot =
        await discountRef.where('type', isEqualTo: 'Activate').get();

    return querySnapshot.docs
        .map((doc) =>
            DiscountDataModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<DiscountDataModel?> selectRandomDiscount() async {
    List<DiscountDataModel> discounts = await fetchAllDiscounts();
    if (discounts.isNotEmpty) {
      Random random = Random();
      int randomIndex = random.nextInt(discounts.length);
      return discounts[randomIndex];
    }
    return null;
  }

  void fetchAndSelectDiscount() async {
    selectedDiscount.value = await selectRandomDiscount();
    orderData.value.discountId = selectedDiscount.value!.id;
    discountName.value = selectedDiscount.value!.discountName ?? "";
    discountPercentage.value = selectedDiscount.value!.percentage ?? 0.0;
    discountCode.value = selectedDiscount.value!.code ?? "";
    debugPrint("${selectedDiscount.value!.discountName}");
  }

  void applyDiscount(String enteredCode) {
    if (enteredCode == discountCode.value) {
      isDiscountValid.value = true;
      getTotalPrice(discountPercentage.value, isDiscountValid);
      showInSnackBar("Discount Applied Successfully",
          isSuccess: true, title: "The Medic");
    } else {
      isDiscountValid.value = false;
      showInSnackBar("Invalid Discount Code",
          isSuccess: false, title: "The Medic");
      discountAmount.value = 0.0;
    }
    disCodeController.clear();
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

    if (existMedicine != null) {
      existMedicine.quantity = (existMedicine.quantity ?? 0) + qty;
    } else {
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

  int getTotalQuantity() {
    if (orderData.value.medicineData == null) {
      return 0;
    }

    return orderData.value.medicineData!
        .fold(0, (sum, item) => sum + (item.quantity ?? 0));
  }

  double getTotalPrice(double discountPercentage, RxBool isDiscountValid) {
    if (orderData.value.medicineData == null) {
      return 0.0;
    }

    double total = orderData.value.medicineData!.fold(
        0.0,
        (sum, item) =>
            sum + ((item.quantity ?? 0) * item.medicinePrice!.toInt()));

    if (isDiscountValid.value) {
      discountAmount.value = total * (discountPercentage / 100);
      orderData.value.discountAmount = discountAmount.value;
      total -= discountAmount.value;
    }

    double totalAmount = total + shippingFee.toDouble();
    orderData.value.shippingCharge = shippingFee.value;
    orderData.value.totalAmount = totalAmount;
    orderData.value.quantity = getTotalQuantity();

    return totalAmount.toPrecision(1);
  }

  Future<void> _addToCart(MedicineData medicine, [int qty = 2]) async {
    Map<String, dynamic> medicineQty = medicine.toMap();
    medicineQty['quantity'] = qty;
    await cartRef.doc(medicine.id).set(medicineQty);
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

  Future<bool> isMedicineInApprovedPrescription(MedicineData medicine) async {
    try {
      DocumentSnapshot prescriptionDoc =
          await prescriptionRef.doc(currentUser).get();

      if (medicine.prescriptionRequire == false) {
        return true;
      } else if (prescriptionDoc.exists) {
        var data = prescriptionDoc.data() as Map<String, dynamic>;
        var prescriptionsList = data['prescriptions'] as List<dynamic>;

        for (var prescriptionMap in prescriptionsList) {
          PrescriptionData prescription =
              PrescriptionData.fromMap(prescriptionMap as Map<String, dynamic>);

          if (prescription.isApproved == true &&
              prescription.medicineList?.contains(medicine.id) == true) {
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
    bool allApproved = true;
    for (MedicineData medicine in medicineList) {
      bool isApproved = await isMedicineInApprovedPrescription(medicine);
      debugPrint("IsApproved : $isApproved");

      if (!isApproved) {
        allApproved = false;
        preRequireList.add(medicine.id!);
      }
    }
    return allApproved;
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

        return prescriptionRequired;
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
        orderDate: DateTime.now(),
        totalAmount: orderData.value.totalAmount,
        discountAmount: orderData.value.discountAmount,
        shippingCharge: orderData.value.shippingCharge,
        quantity: orderData.value.quantity);

    await orderRef.doc(orderData.value.id).set(_orderData.toMap());
    Get.back();
    showInSnackBar("Order Placed Successfully",
        isSuccess: true, title: "The Medic");
    preRequireList.clear();
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

  Future<void> editReview(ReviewDataModel review) async {
    await reviewRef.doc(review.id).update(review.toMap()).then((value) {
      Get.back();
      Get.back();
      showInSnackBar("Review Updated Successfully",
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

  Future<void> deleteReview(String reviewId) async {
    await reviewRef.doc(reviewId).delete().then((value) {
      Get.back();
      showInSnackBar("Review Deleted Successfully",
          title: "The Medic", isSuccess: true);
    });
  }

  Future<OrderData?> fetchOrderIds(String orderId) async {
    try {
      DocumentSnapshot snapshot = await orderRef.doc(orderId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return OrderData.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        print("Document Doesn't Exist");
        return null;
      }
    } catch (e) {
      print("Error Fetching Data : $e");
      return null;
    }
  }

  double countDiscount(int originalPrice, double disPercentage) {
    final discountedPrice =
        originalPrice - (originalPrice * disPercentage / 100);
    return discountedPrice;
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

  Stream<String?> fetchMedicinefromId(String medicineId) {
    return medicineRef.doc(medicineId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        MedicineData medicineData =
            MedicineData.fromMap(snapshot.data() as Map<String, dynamic>);
        return medicineData.genericName;
      }
      return null;
    });
  }

  Stream<Map<String, List<String>>> streamAllMedicineIds() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return firestore
        .collection('orders')
        .where('creatorId', isEqualTo: currentUser)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      Map<String, List<String>> allMedicineIds = {};

      for (var doc in querySnapshot.docs) {
        OrderData orderData = OrderData.fromDocumentSnapshot(doc);

        List<String> medicineIds = orderData.medicineId.values.toList();

        allMedicineIds[orderData.id!] = medicineIds;
      }

      return allMedicineIds;
    });
  }

  String OrderDateFormat(DateTime dateTime) {
    final DateFormat format = DateFormat('d MMM yyyy');
    return format.format(dateTime);
  }

  Stream<List<OrderWithMedicines>> ordersWithMedicines() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore
        .collection('orders')
        // .where('orderStatus', isNotEqualTo: "Cancelled")
        .where('creatorId', isEqualTo: currentUser)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<OrderWithMedicines> ordersWithMedicines = [];

      for (var orderDoc in querySnapshot.docs) {
        OrderData orderData = OrderData.fromDocumentSnapshot(orderDoc);

        UserAddress? address;

        if (orderData.addressId != null) {
          address = await fetchAddressById(orderData.addressId!)?.first;
        }

        List<MedicineData> medicines = [];
        for (String medicineId in orderData.medicineId.values) {
          DocumentSnapshot medicineSnapshot =
              await firestore.collection('medicines').doc(medicineId).get();
          if (medicineSnapshot.exists) {
            medicines.add(MedicineData.fromMap(
                medicineSnapshot.data() as Map<String, dynamic>));
          }
        }

        if (orderData.orderStatus != "Cancelled") {
          ordersWithMedicines.add(OrderWithMedicines(
            orderData: orderData,
            medicines: medicines,
            address: address,
          ));
        }
      }

      return ordersWithMedicines;
    });
  }

  Stream<List<OrderWithMedicines>> pastOrdersWithMedicines() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore
        .collection('orders')
        // .where('orderStatus', isNotEqualTo: "Cancelled")
        .where('creatorId', isEqualTo: currentUser)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<OrderWithMedicines> ordersWithMedicines = [];

      for (var orderDoc in querySnapshot.docs) {
        OrderData orderData = OrderData.fromDocumentSnapshot(orderDoc);

        UserAddress? address;

        if (orderData.addressId != null) {
          address = await fetchAddressById(orderData.addressId!)?.first;
        }

        List<MedicineData> medicines = [];
        for (String medicineId in orderData.medicineId.values) {
          DocumentSnapshot medicineSnapshot =
              await firestore.collection('medicines').doc(medicineId).get();
          if (medicineSnapshot.exists) {
            medicines.add(MedicineData.fromMap(
                medicineSnapshot.data() as Map<String, dynamic>));
          }
        }

        ordersWithMedicines.add(OrderWithMedicines(
          orderData: orderData,
          medicines: medicines,
          address: address,
        ));
      }

      return ordersWithMedicines;
    });
  }

  Future<void> cancelOrder(String orderId) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'orderStatus': 'Cancelled',
    });
  }

  Future<void> reorder(OrderData pastOrder) async {
    try {
      String id = orderRef.doc().id;
      Map<String, dynamic> newOrderData = {
        'id': id,
        'creatorId': pastOrder.creatorId,
        'addressId': pastOrder.addressId,
        'medicineId': pastOrder.medicineId,
        'discountId': pastOrder.discountId,
        'orderDate': FieldValue.serverTimestamp(),
        'totalAmount': pastOrder.totalAmount ?? 0.0,
        'shippingCharge': pastOrder.shippingCharge ?? 0.0,
        'discountAmount': pastOrder.discountAmount ?? 0.0,
        'prescriptionId': pastOrder.prescriptionId,
        'quantity': pastOrder.quantity ?? 1,
        'orderStatus': 'Placed',
      };

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(id)
          .set(newOrderData)
          .then((value) {
        Get.back();
        showInSnackBar("Reorder Successfull",
            isSuccess: true, title: "The Medic");
      });
    } catch (e) {
      print("Error in reordering: $e");
    }
  }

  CreditCardValidator cardValidator = CreditCardValidator();

  bool validateCardInfo() {
    if (cardHolderController.text.trim().isEmpty) {
      showInSnackBar("Please enter card holder name.",
          title: 'Required!', isSuccess: false);
      return false;
    } else if (cardNumberController.text.trim().isEmpty) {
      showInSnackBar("Please enter card number.",
          title: 'Required!', isSuccess: false);
      return false;
    } else if (expDateController.text.trim().isEmpty) {
      showInSnackBar("Please enter expiry date.",
          title: 'Required!', isSuccess: false);
      return false;
    } else if (cvvController.text.trim().isEmpty) {
      showInSnackBar("Please enter cvv number.",
          title: 'Required!', isSuccess: false);
      return false;
    }
    return true;
  }

  void _formatCreditCardNumber() {
    String text = cardNumberController.text.replaceAll(' ', '');

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      int nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    String formattedText = buffer.toString();
    if (formattedText.length > 19) {
      formattedText = formattedText.substring(0, 19);
    }

    cardNumberController.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  void _formatExpiryDate() {
    String text = expDateController.text;
    text = text.replaceAll(RegExp(r'[^0-9/]'), '');

    int cursorPosition = expDateController.selection.baseOffset;

    bool justAddedSlash = false;

    if (text.length == 2 && !text.endsWith('/')) {
      text += '/';
      justAddedSlash = true;
    }

    if (text.length > 5) {
      text = text.substring(0, 5);
    }

    if (justAddedSlash && cursorPosition == 2) {
      cursorPosition += 1;
    }

    expDateController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  void addCardDetails(CreditCard card) {
    DocumentReference userDoc = cardRef.doc(currentUser);

    cardRef.doc(currentUser).get().then((doc) {
      if (doc.exists) {
        List<dynamic> cards = List.from(doc.get('cards') ?? []);
        cards.add(card.toMap());
        userDoc.update({'cards': cards}).then((value) {
          Get.back();
          Get.back();
          showInSnackBar("Card details added successfully",
              isSuccess: true, title: "The Medic");
          cardHolderController.clear();
          cardNumberController.clear();
          expDateController.clear();
          cvvController.clear();
        });
      } else {
        userDoc.set({
          'cards': [card.toMap()]
        }).then((value) {
          Get.back();
          Get.back();
          showInSnackBar("Card details added successfully",
              isSuccess: true, title: "The Medic");
          cardHolderController.clear();
          cardNumberController.clear();
          expDateController.clear();
          cvvController.clear();
        });
      }
    }).catchError((error) {
      print("Error updating document : $error");
    });
  }

  Stream<List<CreditCard>> fetchCards() {
    return cardRef.doc(currentUser).snapshots().map((snapshot) {
      var data = snapshot.data() as Map<String, dynamic>;
      if (snapshot.exists && data.containsKey('cards')) {
        List<dynamic> cardsMap = snapshot.get('cards');
        return cardsMap.map((json) => CreditCard.fromMap(json)).toList();
      } else {
        return [];
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    expDateController.dispose();
    cardNumberController.dispose();
  }
}
