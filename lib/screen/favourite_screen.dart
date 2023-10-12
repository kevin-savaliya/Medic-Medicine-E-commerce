import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/screen/medicine_details.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.73, mainAxisSpacing: 5),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(() => const MedicineDetails());
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              height: 250,
              width: 200,
              decoration: BoxDecoration(
                  color: AppColors.decsGrey,
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
                              Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Image.asset(
                                  AppImages.medicineBox4,
                                  height: 50,
                                ),
                              ),
                              Positioned(
                                  top: 10,
                                  right: 5,
                                  child: SvgPicture.asset(
                                    AppIcons.favFillRed,
                                    height: 22,
                                  ))
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
                            "Iconic Remedies",
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
                            "Aspirin",
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
                            rating: 3,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "SLE 120",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            fontSize: 12,
                                            color: AppColors.darkPrimaryColor,
                                            fontFamily: AppFont.fontMedium),
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
                                            fontFamily: AppFont.fontMedium),
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
                                                BorderRadius.circular(30))),
                                    child: Text(
                                      "Add to cart",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontSize: 9.5,
                                              color: AppColors.primaryColor,
                                              fontFamily: AppFont.fontMedium),
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
  }
}
