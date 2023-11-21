import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:medic/_dart/_init.dart';
import 'package:medic/controller/home_controller.dart';
import 'package:medic/controller/user_repository.dart';
import 'package:medic/model/category_data.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/model/review_data_model.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class MedicineController extends GetxController {
  RxString selectedPaymentMethod = "".obs;

  RxList<Map<String, dynamic>> favouriteMedicines =
      <Map<String, dynamic>>[].obs;

  RxList<String> favMedicinesIds = <String>[].obs;

  RxList<UserModel> allUsers = <UserModel>[].obs;

  final CollectionReference categoryref =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference medicineRef =
      FirebaseFirestore.instance.collection('medicines');
  final CollectionReference favRef =
      FirebaseFirestore.instance.collection('favourites');
  final CollectionReference reviewRef =
      FirebaseFirestore.instance.collection("reviews");

  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  UserModel? loggedInUser = Get.find<HomeController>().loggedInUser.value;

  final firebaseuser = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    fetchFavourite();
    // fetchFavouriteMedicine();
    fetchAllUser();
  }

  List medicineCategoryImageList = [
    AppIcons.allopathy,
    AppIcons.ayurveda,
    AppIcons.homeo,
    AppIcons.skin,
    AppIcons.dental,
    AppIcons.child,
    AppIcons.mental,
    AppIcons.digestive,
    AppIcons.sexual,
    AppIcons.cardio,
    AppIcons.nerves,
    AppIcons.diabetic,
    AppIcons.bones,
    AppIcons.eye,
    AppIcons.urinary,
    AppIcons.kidney,
  ];

  List popularColorList = [
    AppColors.listColor1,
    AppColors.listColor2,
    AppColors.listColor3,
    AppColors.listColor4,
  ];

  List medicineImageList = [
    AppImages.medicineBox1,
    AppImages.medicineBox2,
    AppImages.medicineBox3,
  ];

  List paymentMethod = [
    ConstString.creditCard,
    ConstString.orangeMoney,
    ConstString.afriMoney
  ];

  List paymentMethodIcon = [
    AppIcons.creditCard,
    AppIcons.orangeMoney,
    AppIcons.africell,
  ];

  Stream<List<CategoryData>> fetchCategory() {
    var data = categoryref.snapshots().map((event) {
      return event.docs.map((e) {
        return CategoryData.fromMap(e.data() as Map<String, dynamic>);
      }).toList();
    });
    return data;
  }

  Stream<List<MedicineData>> fetchPopularMedicines() {
    var data = medicineRef
        .where('ratings', isGreaterThanOrEqualTo: '3.5')
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return MedicineData.fromMap(e.data() as Map<String, dynamic>);
      }).toList();
    });
    return data;
  }

  Stream<List<MedicineData>> fetchMedicines() {
    var data = medicineRef.snapshots().map((event) {
      return event.docs.map((e) {
        return MedicineData.fromMap(e.data() as Map<String, dynamic>);
      }).toList();
    });
    return data;
  }

  Stream<List<MedicineData>> getCategoryWiseMedicine(String categoryId) {
    var data = medicineRef
        .where('categoryId', isEqualTo: categoryId.trim())
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return MedicineData.fromMap(e.data() as Map<String, dynamic>);
      }).toList();
    });
    return data;
  }

  fetchFavourite() async {
    DocumentSnapshot doc = await favRef.doc(currentUserId).get();

    var fetchedMedicine =
        (doc.data() as Map<String, dynamic>? ?? {})['medicines'] ?? [];

    favouriteMedicines.value = List<Map<String, dynamic>>.from(fetchedMedicine);

    favMedicinesIds.value = favouriteMedicines
        .map((medicine) => medicine['medicineId'] as String)
        .toList();
    update();
  }

  bool isFavourite(String medicineId) {
    return favouriteMedicines
        .any((medicine) => medicine['medicineId'] == medicineId);
  }

  Future<void> addFavourite(String medicineId) async {
    DocumentReference favDocRef = favRef.doc(currentUserId);

    DocumentSnapshot snapshot = await favDocRef.get();

    Map<String, dynamic> favMedicine = {
      'medicineId': medicineId,
      'timestamp': DateTime.now()
    };

    if (!snapshot.exists) {
      favouriteMedicines.add(favMedicine);
      favMedicinesIds.add(medicineId);
      await favRef.doc(currentUserId).set({'medicines': favouriteMedicines});
    } else {
      favouriteMedicines.add(favMedicine);
      favMedicinesIds.add(medicineId);
      await favRef.doc(currentUserId).update({
        'medicines': FieldValue.arrayUnion([favMedicine])
      });
    }
  }

  Future<void> removeFavourite(String medicineId) async {
    Map<String, dynamic> medicineToRemove = favouriteMedicines.firstWhere(
      (medicine) => medicine['medicineId'] == medicineId,
      orElse: () => {},
    );

    favouriteMedicines.remove(medicineToRemove);
    favMedicinesIds.remove(medicineId);
    await favRef.doc(currentUserId).update({
      'medicines': FieldValue.arrayRemove([medicineToRemove])
    });
    fetchFavourite();
  }

  Stream<List<MedicineData>> fetchFavouriteMedicine() {
    if (favouriteMedicines.isEmpty) {
      return const Stream.empty();
    }
    var data = medicineRef
        .where('id', whereIn: favMedicinesIds)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return MedicineData.fromMap(e.data() as Map<String, dynamic>);
      }).toList();
    });
    return data;
  }

  Stream<List<ReviewDataModel>> getReview(String medicineId) {
    var data = FirebaseFirestore.instance
        .collection('reviews')
        .where('medicineId', isEqualTo: medicineId)
        .orderBy('createdTime', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return ReviewDataModel.fromMap(e.data());
      }).toList();
    });
    return data;
  }

  fetchAllUser() {
    try {
      UserRepository.instance.streamAllUser().listen((updatedUserData) async {
        print(
            'updatedUserData fetchAllUser hasData ${updatedUserData.isNotEmpty}');
        if (updatedUserData.isNotEmpty) {
          allUsers.value = updatedUserData;
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  UserModel findSingleUserFromAllUser(String userId) {
    UserModel user = allUsers.firstWhere((element) => element.id == userId);
    return user;
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM, yyyy');
    return formatter.format(dateTime);
  }

  Stream<Map<int, int>> reviewRatingCounts(String medicineId) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore
        .collection('reviews')
        .where('medicineId', isEqualTo: medicineId)
        .snapshots()
        .map((snapshot) {
      Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

      for (var doc in snapshot.docs) {
        var data = doc.data();
        int rating = data['rating']?.round() ?? 0;
        if (rating >= 1 && rating <= 5) {
          ratingCounts[rating] = (ratingCounts[rating] ?? 0) + 1;
        }
      }

      return ratingCounts;
    });
  }
}
