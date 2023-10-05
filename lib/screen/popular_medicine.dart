import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/medicine_controller.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class PopularMedicine extends StatelessWidget {

  MedicineController controller = Get.put(MedicineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(
              AppIcons.back,
            ),
          ),
        ),
        titleSpacing: 0,
        title: Text(ConstString.popularMedicine,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
        actions: [
          GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                AppIcons.search,
                width: 20,
              )),
          SizedBox(
            width: 12,
          ),
          GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                AppIcons.bag,
                width: 22,
              )),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: popularMedicineWidget(),
    );
  }

  Container popularMedicineWidget() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.popularMedicine.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1.1,mainAxisSpacing: 15,crossAxisSpacing: 15),
          itemBuilder: (context, index) {
            return Container(
              height: 130,
              width: 130,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: controller.popularColorList[
                index % (controller.popularColorList.length)],
              ),
              child: Stack(
                children: [
                  SvgPicture.asset(AppImages.designVector),
                  Positioned(
                      top: 20,
                      left: 15,
                      child: Text(
                        controller.popularMedicine[index],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: AppColors.white),
                      )),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        controller.medicineImageList[index %
                            (controller.medicineImageList.length)],
                        height: 70,
                      ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
