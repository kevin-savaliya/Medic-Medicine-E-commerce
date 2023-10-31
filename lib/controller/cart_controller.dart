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

  Rx<OrderData> orderData = OrderData(medicineId: {}).obs;

  // Future<void> addToCart(MedicineData medicine, [int qty = 1]) async {
  //   // Extend the medicine's map with the quantity
  //   Map<String, dynamic> medicineWithQty = medicine.toMap();
  //   medicineWithQty['qty'] = qty;
  //
  //   await cartRef.doc(medicine.id).set(medicineWithQty);
  // }

  Future<void> addToCart(MedicineData medicine) async {
    // orderData.value = orderData.value.copyWith(medicineId: [
    //   ...orderData.value.medicineId,
    //   {orderData.value.medicineId.length.toString(): medicine.id}
    // ]);

    // add medicine to orderData
    if (!orderData.value.medicineId.values.toList().contains(medicine.id)) {
      orderData.value.medicineId
          .addAll({orderData.value.medicineId.length.toString(): medicine.id});
    }

    orderData.value.medicineData ??= [];
    List<MedicineData> list = orderData.value.medicineData!
        .where((element) => element.id == medicine.id)
        .toList();
    if (list.isEmpty) {
      orderData.value.medicineData?.add(medicine);
    } else {
      list[0].quantity = list[0].quantity! + 1;
    }
    orderData.value.medicineData?.add(medicine);
  }

  Future<void> _addToCart(MedicineData medicine, [int qty = 2]) async {
    Map<String, dynamic> medicineQty = medicine.toMap();
    medicineQty['quantity'] = qty;
    await cartRef.doc(medicine.id).set(medicineQty);
  }

  Future<void> removeFromCart(String medicineId) async {
    if (orderData.value.medicineId.values.toList().isNotEmpty) {
      orderData.value.medicineId.values
          .toList()
          .removeWhere((element) => element == medicineId);
    }
    if (orderData.value.medicineData != null &&
        orderData.value.medicineData!.isNotEmpty) {
      orderData.value.medicineData
          ?.removeWhere((element) => element.id == medicineId);
    }
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

    final Map<String, dynamic> medicineIds = {};
    for (int i = 0; i < cartSnapshot.docs.length; i++) {
      medicineIds[i.toString()] = cartSnapshot.docs[i].id;
    }
    /*for (final doc in cartSnapshot.docs) {
      medicineIds.add({'id': doc.id});
    }*/

    String id = orderRef.doc().id;

    final _orderData = orderData.value
        .copyWith(id: id, creatorId: currentUser, medicineId: medicineIds);

    await orderRef.doc(id).set(_orderData.toMap());

    Get.back();
    for (final doc in cartSnapshot.docs) {
      await cartRef.doc(doc.id).delete();
    }

    showInSnackBar("Order Placed Successfully",
        isSuccess: true, title: "The Medic");
  }
}
