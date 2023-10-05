import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/medicine_controller.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class MedicineCategory extends StatelessWidget {

  MedicineController controller = Get.put(MedicineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(AppIcons.back,),
          ),
        ),
        titleSpacing: 0,
        title: Text(ConstString.medicineCategory,style: Theme.of(context).textTheme.titleLarge!.copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,shadowColor: AppColors.txtGrey.withOpacity(0.2),
        actions: [
          GestureDetector(onTap: () {

          },child: SvgPicture.asset(AppIcons.search,width: 20,)),
          SizedBox(width: 12,),
          GestureDetector(onTap: () {

          },child: SvgPicture.asset(AppIcons.bag,width: 22,)),
          SizedBox(width: 15,),
        ],
      ),
      body: categoryWidget(),
    );
  }

  Container categoryWidget() {
   return Container(
     child: Padding(
       padding: const EdgeInsets.all(15.0),
       child: GridView.builder(
         padding: EdgeInsets.zero,
         physics: const NeverScrollableScrollPhysics(),
         itemCount: controller.medicineCategoryList.length,
         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 2, childAspectRatio: 3.3,mainAxisSpacing: 15,crossAxisSpacing: 15),
         itemBuilder: (context, index) {
           return Container(
             alignment: Alignment.center,
             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: AppColors.decsGrey),
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 15),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   SvgPicture.asset(controller.medicineCategoryImageList[index]),
                   SizedBox(
                     width: 15,
                   ),
                   Text(
                     controller.medicineCategoryList[index],
                     style: Theme.of(context).textTheme.titleMedium!.copyWith(
                         fontSize: 13,
                         fontFamily: AppFont.fontMedium,
                         color: AppColors.darkPrimaryColor),
                   )
                 ],
               ),
             ),
           );
         },
       ),
     ),
   );
  }
}
