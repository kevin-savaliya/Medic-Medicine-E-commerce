import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/model/order_data.dart';
import 'package:medic/model/user_address.dart';
import 'package:medic/utils/utils.dart';

class CartController extends GetxController {
  final RxList cartItems = [].obs;

  final CollectionReference medicineRef =
      FirebaseFirestore.instance.collection("medicines");

  late final cartRef = FirebaseFirestore.instance
      .collection("users")
      .doc(currentUser)
      .collection("cart");

  final orderRef = FirebaseFirestore.instance.collection("orders");

  final CollectionReference addRef =
      FirebaseFirestore.instance.collection("addresses");

  final String currentUser = FirebaseAuth.instance.currentUser!.uid;

  // Future<void> addToCart(MedicineData medicine, [int qty = 1]) async {
  //   // Extend the medicine's map with the quantity
  //   Map<String, dynamic> medicineWithQty = medicine.toMap();
  //   medicineWithQty['qty'] = qty;
  //
  //   await cartRef.doc(medicine.id).set(medicineWithQty);
  // }

  Future<void> addToCart(MedicineData medicine,[int qty = 2]) async {
    Map<String,dynamic> medicineQty = medicine.toMap();
    medicineQty['qty'] = qty;
    await cartRef.doc(medicine.id).set(medicineQty);
  }

  Future<void> removeFromCart(String medicineId) async {
    await cartRef.doc(medicineId).delete();
  }

  Stream<List<MedicineData>> fetchMedicineFromCart() {
    return cartRef.snapshots().map((event) {
      return event.docs.map((e) {
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
            return UserAddress.fromMap(
                addressMap); // This returns the active address
          }
        }
      }
      return null; // Return null if no active address found or document doesn't exist
    });
  }

  Future<void> placeOrder() async {
    final cartSnapshot = await cartRef.get();

    if (cartSnapshot.docs.isEmpty) {
      showInSnackBar("No items in cart to place order");
    }

    final List<Map<String, dynamic>> medicineIds = [];
    for (final doc in cartSnapshot.docs) {
      medicineIds.add({'id': doc.id});
    }

    String id = orderRef.doc().id;

    final orderData = OrderData(
        id: id,
        creatorId: currentUser,
        addressId: "addressId",
        reviewId: "reviewId",
        medicineId: medicineIds,
        categoryId: "categoryId");

    await orderRef.doc(id).set(orderData.toMap());

    Get.back();
    showInSnackBar("Order Placed Successfully",
        isSuccess: true, title: "The Medic");

    for (final doc in cartSnapshot.docs) {
      await cartRef.doc(doc.id).delete();
    }
  }
}
