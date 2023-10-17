// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/medicine_controller.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/screen/medicine_details.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/shimmer_widget.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class FavouriteScreen extends StatelessWidget {
  MedicineController controller = Get.put(MedicineController());

  FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        // titleSpacing: 0,
        title: Text(ConstString.fav,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
        actions: [
          GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                AppIcons.search,
                width: 20,
              )),
          const SizedBox(
            width: 12,
          ),
          GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                AppIcons.bag,
                width: 22,
              )),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: medicineWidget(),
    );
  }

  Widget medicineWidget() {
    return StreamBuilder(
      stream: controller.fetchFavouriteMedicine(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridMedicine(itemCount: snapshot.data?.length);
        } else if (snapshot.hasError) {
          return Text("Error : ${snapshot.error}");
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<MedicineData>? medicineList = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: medicineList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.73,
                  mainAxisSpacing: 5),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => MedicineDetails(
                          medicineData: medicineList[index],
                        ));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    height: 250,
                    width: 200,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.decsGrey)),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 5,
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        height: 25,
                                        width: 25,
                                        imageUrl:
                                            medicineList[index].image ?? "",
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: Center(
                                            child: CupertinoActivityIndicator(
                                              color: AppColors.primaryColor,
                                              animating: true,
                                              radius: 10,
                                            ),
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Obx(() {
                                      String medicineId =
                                          medicineList[index].id ?? "";
                                      bool isFav =
                                          controller.isFavourite(medicineId);
                                      return Positioned(
                                          top: 10,
                                          right: 10,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (isFav) {
                                                controller.removeFavourite(
                                                    medicineId);
                                              } else {
                                                controller
                                                    .addFavourite(medicineId);
                                              }
                                            },
                                            child: isFav
                                                ? SvgPicture.asset(
                                                    AppIcons.favFillRed,
                                                    height: 22,
                                                  )
                                                : SvgPicture.asset(
                                                    AppIcons.like,
                                                    height: 22,
                                                  ),
                                          ));
                                    })
                                  ],
                                ),
                              ),
                            )),
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  medicineList[index].genericName!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontFamily: AppFont.fontMedium,
                                          color: AppColors.darkPrimaryColor,
                                          fontSize: 13.5),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  medicineList[index].brandName!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontFamily: AppFont.fontRegular,
                                          color: AppColors.txtGrey,
                                          fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                SmoothStarRating(
                                  rating: double.parse(
                                      medicineList[index].ratings!),
                                  allowHalfRating: true,
                                  defaultIconData: Icons.star,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half,
                                  starCount: 5,
                                  spacing: 2,
                                  onRatingChanged: (rating) {},
                                  size: 15,
                                  color: AppColors.secondaryColor,
                                  borderColor: AppColors.indGrey,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "SLE 120",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: AppColors
                                                      .darkPrimaryColor,
                                                  fontFamily:
                                                      AppFont.fontMedium),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "30% Off",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  fontSize: 8,
                                                  color: AppColors.primaryColor,
                                                  fontFamily:
                                                      AppFont.fontMedium),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.tilePrimaryColor,
                                              fixedSize: const Size(110, 20),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30))),
                                          child: Text(
                                            "Add to cart",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    fontSize: 9.5,
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontFamily:
                                                        AppFont.fontMedium),
                                          )),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.tilePrimaryColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppIcons.noData, height: 60),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  ConstString.noMedicine,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontFamily: AppFont.fontMedium),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
