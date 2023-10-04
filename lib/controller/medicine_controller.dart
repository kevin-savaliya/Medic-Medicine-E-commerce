import 'package:get/get.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/assets.dart';

class MedicineController extends GetxController {
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
}
