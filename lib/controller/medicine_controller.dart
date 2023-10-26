import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:medic/model/category_data.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class MedicineController extends GetxController {
  RxString selectedPaymentMethod = "".obs;

  RxList<Map<String, dynamic>> favouriteMedicines =
      <Map<String, dynamic>>[].obs;

  RxList<String> favMedicinesIds = <String>[].obs;

  final CollectionReference categoryref =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference medicineRef =
      FirebaseFirestore.instance.collection('medicines');
  final CollectionReference favRef =
      FirebaseFirestore.instance.collection('favourites');

  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchFavourite();
  }

  List medicineCategoryList = [
    "Allopathy",
    "Ayurveda",
    "Homeo",
    "Skin & Hair",
    "Dental",
    "Child",
    "Mental",
    "Digestive",
    "Sexual",
    "Cardio",
    "Nerves",
    "Diabetes",
    "Bones",
    "Eye",
    "Urinary",
    "Kidney"
  ];

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

  List popularMedicine = [
    "Tylenol",
    "Amoxicillin",
    "Atorvastatin",
    "Benadryl",
    "Nexium"
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
        // .where('ratings', isGreaterThanOrEqualTo: '3.5')
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

  fetchFavourite() async {
    DocumentSnapshot doc = await favRef.doc(currentUserId).get();

    var fetchedMedicine =
        (doc.data() as Map<String, dynamic>? ?? {})['medicines'] ?? [];

    favouriteMedicines.value = List<Map<String, dynamic>>.from(fetchedMedicine);

    favMedicinesIds.value = favouriteMedicines
        .map((medicine) => medicine['medicineId'] as String)
        .toList();
  }

  bool isFavourite(String medicineId) {
    return favouriteMedicines
        .any((medicine) => medicine['medicineId'] == medicineId);
  }

  addFavourite(String medicineId) async {
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

  removeFavourite(String medicineId) {
    Map<String, dynamic> medicineToRemove = favouriteMedicines.firstWhere(
      (medicine) => medicine['medicineId'] == medicineId,
      orElse: () => {},
    );

    favouriteMedicines.remove(medicineToRemove);
    favMedicinesIds.remove(medicineId);
    favRef.doc(currentUserId).update({
      'medicines': FieldValue.arrayRemove([medicineToRemove])
    });
  }

  Stream<List<MedicineData>> fetchFavouriteMedicine() {
    if (favouriteMedicines.isEmpty) {
      return Stream.empty();
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
}
