import 'package:get/get.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class HomeController extends GetxController {
  RxInt pageIndex = 0.obs;

  pageUpdateOnHomeScreen(int index) {
    pageIndex.value = index;
    update();
  }

  List categoryImageList = [
    AppImages.analgesics,
    AppImages.antivirus,
    AppImages.antibiotic,
    AppImages.antacids,
    AppImages.analgesics,
  ];

  List categoryList = [
    ConstString.Analgesics,
    ConstString.Antivirals,
    ConstString.Antibiotics,
    ConstString.Antacids,
    ConstString.Abilify,
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
