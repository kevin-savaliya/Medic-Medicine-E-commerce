import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medic/model/category_data.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class MedicineController extends GetxController {
  RxString selectedPaymentMethod = "".obs;

  RxString frequencyValue = "".obs;

  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController timeController = TextEditingController();

  final CollectionReference categoryref =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference medicineRef =
      FirebaseFirestore.instance.collection('medicines');

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
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

  List<String> frequencyList = ["Everyday", "Weekly", "Monthly", "Yearly"];

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
}
