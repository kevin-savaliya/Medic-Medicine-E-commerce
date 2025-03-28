// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:medic/controller/medicine_controller.dart';
import 'package:medic/model/category_data.dart';
import 'package:medic/screen/cart_screen.dart';
import 'package:medic/screen/categorywise_medicine.dart';
import 'package:medic/screen/search_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/shimmer_widget.dart';

class MedicineCategory extends StatelessWidget {
  MedicineController controller = Get.put(MedicineController());

  MedicineCategory({super.key});

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
            child: SvgPicture.asset(
              AppIcons.back,
            ),
          ),
        ),
        titleSpacing: 0,
        title: Text(ConstString.medicineCategory,
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
                Get.to(() => CartScreen());
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
      body: categoryWidget(),
    );
  }

  Widget categoryWidget() {
    return StreamBuilder<List<CategoryData>>(
      stream: controller.fetchCategory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: GridCategory(itemCount: snapshot.data?.length),
          );
        } else if (snapshot.hasError) {
          return const Text("Error");
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<CategoryData> categoryList = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.8,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => CategoryWiseMedicine(
                        categoryData: categoryList.elementAt(index)));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.decsGrey),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: SvgPicture.network(
                              categoryList[index].image!,
                              height: 25,
                            ),
                            // child: CachedNetworkImage(
                            //   height: 35,
                            //   width: 35,
                            //   imageUrl: categoryList[index].image!,
                            //   errorWidget: (context, url, error) =>
                            //       const Icon(Icons.error),
                            //   progressIndicatorBuilder:
                            //       (context, url, downloadProgress) => SizedBox(
                            //     width: 30,
                            //     height: 30,
                            //     child: Center(
                            //         child: LoadingIndicator(
                            //       colors: [AppColors.primaryColor],
                            //       indicatorType: Indicator.ballScale,
                            //       strokeWidth: 1,
                            //     )),
                            //   ),
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Text(
                              categoryList[index].name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontSize: 13,
                                      fontFamily: AppFont.fontMedium,
                                      color: AppColors.darkPrimaryColor),
                            ),
                          )
                        ],
                      ),
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
                    ConstString.noCategory,
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
