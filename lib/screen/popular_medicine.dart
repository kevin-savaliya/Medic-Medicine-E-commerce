// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/home_controller.dart';
import 'package:medic/controller/medicine_controller.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/screen/cart_screen.dart';
import 'package:medic/screen/medicine_details.dart';
import 'package:medic/screen/search_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/shimmer_widget.dart';

class PopularMedicine extends StatelessWidget {
  MedicineController controller = Get.put(MedicineController());
  HomeController homeController = Get.put(HomeController());

  final Function(int, [String]) switchTab;

  PopularMedicine(this.switchTab, {super.key});

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
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
        actions: [
          GestureDetector(
              onTap: () {
                Get.to(() => SearchScreen());
              },
              child: SvgPicture.asset(
                AppIcons.search,
                width: 18,
              )),
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
              onTap: () {
                Get.back();
                switchTab(2);
                // Get.to(() => CartScreen());
              },
              child: SvgPicture.asset(
                AppIcons.bag,
                width: 22,
              )),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: popularMedicineWidget(),
    );
  }

  Widget popularMedicineWidget() {
    return StreamBuilder(
      stream: controller.fetchPopularMedicines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridMedicine(itemCount: snapshot.data?.length);
        } else if (snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.tilePrimaryColor),
            child: Text(
              "Error : ${snapshot.error}",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 13,
                  fontFamily: AppFont.fontMedium),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<MedicineData> medicineList = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: medicineList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => MedicineDetails(
                          medicineData: medicineList[index],
                          switchTab: homeController.pageUpdateOnHomeScreen,
                        ));
                  },
                  child: Container(
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
                              medicineList[index].genericName ?? "",
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
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImages.emptyBin),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    ConstString.noPopular,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 15, color: AppColors.skipGrey),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
