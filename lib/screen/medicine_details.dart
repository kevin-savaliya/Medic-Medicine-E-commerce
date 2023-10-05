import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:medic/screen/order_placement_screen.dart';
import 'package:medic/screen/upload_pres_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class MedicineDetails extends StatelessWidget {
  const MedicineDetails({super.key});

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
      body: medicineDetailWidget(context),
    );
  }

  Container medicineDetailWidget(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.primaryColor,
              height: 55,
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 15, right: 5),
                horizontalTitleGap: 5,
                leading: SvgPicture.asset(AppImages.rxBar),
                title: Text(
                  ConstString.prescriptionRequirement,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.white,
                      fontFamily: AppFont.fontRegular,
                      height: 1.4,
                      fontSize: 12.5),
                ),
                trailing: TextButton(
                    onPressed: () {
                      Get.to(() => UploadPrescription());
                    },
                    child: Text(
                      ConstString.upload,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.white,
                          fontFamily: AppFont.fontMedium),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        AppImages.medicineBox,
                        width: 180,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: SvgPicture.asset(AppIcons.like))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Iconic Remedies",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontFamily: AppFont.fontBold,
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
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "SLE 120",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: AppColors.darkPrimaryColor,
                                    fontFamily: AppFont.fontMedium),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            "30% Off",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontSize: 11,
                                    color: AppColors.primaryColor,
                                    fontFamily: AppFont.fontMedium),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.decsGrey,
                              borderRadius: BorderRadius.circular(5)),
                          height: 28,
                          width: 28,
                          child: Icon(
                            Icons.remove,
                            color: AppColors.phoneGrey,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "0",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.decsGrey,
                              borderRadius: BorderRadius.circular(5)),
                          height: 28,
                          width: 28,
                          child: Icon(
                            Icons.add,
                            color: AppColors.primaryColor,
                            size: 18,
                          ),
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              fixedSize: Size(110, 20),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: Text(
                            "Add to cart",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: AppColors.white,
                                    fontFamily: AppFont.fontMedium),
                          ))
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                height: 1,
                color: AppColors.lineGrey,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ExpansionTileCard(
                contentPadding: EdgeInsets.zero,
                baseColor: AppColors.white,
                elevation: 0,
                title: Text(
                  ConstString.description,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
                ),
                children: [
                  Container(
                    height: 1,
                    color: AppColors.lineGrey,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Iconic Capsule is a medicine that is used for the treatment of Treatment of megaloblastic anemias due to a deficiency of folic acid, Treatment of anemias of nutritional origin, Pregnancy, Infancy, Or childhood, Vitamin b12 deficiency, Pernicious anemia, For eye and ear wash, Skin infection and other conditions.",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(height: 1.5, color: AppColors.txtGrey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 1,
                color: AppColors.lineGrey,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ExpansionTileCard(
                contentPadding: EdgeInsets.zero,
                baseColor: AppColors.white,
                elevation: 0,
                title: Text(
                  ConstString.benefits,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
                ),
                children: [
                  Container(
                    height: 1,
                    color: AppColors.lineGrey,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Iconic Capsule is a medicine that is used for the treatment of Treatment of megaloblastic anemias due to a deficiency of folic acid, Treatment of anemias of nutritional origin, Pregnancy, Infancy, Or childhood, Vitamin b12 deficiency, Pernicious anemia, For eye and ear wash, Skin infection and other conditions.",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(height: 1.5, color: AppColors.txtGrey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 1,
                color: AppColors.lineGrey,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ExpansionTileCard(
                contentPadding: EdgeInsets.zero,
                baseColor: AppColors.white,
                elevation: 0,
                title: Text(
                  ConstString.uses,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
                ),
                children: [
                  Container(
                    height: 1,
                    color: AppColors.lineGrey,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Iconic Capsule is a medicine that is used for the treatment of Treatment of megaloblastic anemias due to a deficiency of folic acid, Treatment of anemias of nutritional origin, Pregnancy, Infancy, Or childhood, Vitamin b12 deficiency, Pernicious anemia, For eye and ear wash, Skin infection and other conditions.",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(height: 1.5, color: AppColors.txtGrey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 1,
                color: AppColors.lineGrey,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ExpansionTileCard(
                contentPadding: EdgeInsets.zero,
                baseColor: AppColors.white,
                elevation: 0,
                title: Text(
                  ConstString.direction,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
                ),
                children: [
                  Container(
                    height: 1,
                    color: AppColors.lineGrey,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Iconic Capsule is a medicine that is used for the treatment of Treatment of megaloblastic anemias due to a deficiency of folic acid, Treatment of anemias of nutritional origin, Pregnancy, Infancy, Or childhood, Vitamin b12 deficiency, Pernicious anemia, For eye and ear wash, Skin infection and other conditions.",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(height: 1.5, color: AppColors.txtGrey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 1,
                color: AppColors.lineGrey,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ExpansionTileCard(
                contentPadding: EdgeInsets.zero,
                baseColor: AppColors.white,
                elevation: 0,
                title: Text(
                  ConstString.safety,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
                ),
                children: [
                  Container(
                    height: 1,
                    color: AppColors.lineGrey,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Iconic Capsule is a medicine that is used for the treatment of Treatment of megaloblastic anemias due to a deficiency of folic acid, Treatment of anemias of nutritional origin, Pregnancy, Infancy, Or childhood, Vitamin b12 deficiency, Pernicious anemia, For eye and ear wash, Skin infection and other conditions.",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(height: 1.5, color: AppColors.txtGrey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 1,
                color: AppColors.lineGrey,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ExpansionTileCard(
                contentPadding: EdgeInsets.zero,
                baseColor: AppColors.white,
                elevation: 0,
                title: Text(
                  ConstString.FAQ,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
                ),
                children: [
                  Container(
                    height: 1,
                    color: AppColors.lineGrey,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Iconic Capsule is a medicine that is used for the treatment of Treatment of megaloblastic anemias due to a deficiency of folic acid, Treatment of anemias of nutritional origin, Pregnancy, Infancy, Or childhood, Vitamin b12 deficiency, Pernicious anemia, For eye and ear wash, Skin infection and other conditions.",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(height: 1.5, color: AppColors.txtGrey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                height: 1,
                color: AppColors.lineGrey,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ConstString.rating_review,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontFamily: AppFont.fontBold),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "4.4",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontSize: 30, fontFamily: AppFont.fontBold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SmoothStarRating(
                        rating: 3,
                        allowHalfRating: true,
                        defaultIconData: Icons.star,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        starCount: 5,
                        spacing: 4,
                        onRatingChanged: (rating) {},
                        size: 16,
                        color: AppColors.secondaryColor,
                        borderColor: AppColors.indGrey,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "45,683",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: 12, fontFamily: AppFont.fontMedium),
                      ),
                    ],
                  ),
                  Container(
                    // color: Colors.black12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "5",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Container(
                              width: 200,
                              child: GFProgressBar(
                                backgroundColor: AppColors.lineGrey,
                                lineHeight: 7,
                                progressBarColor: AppColors.secondaryColor,
                                percentage: 0.8,
                                width: 180,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "4",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Container(
                              width: 200,
                              child: GFProgressBar(
                                backgroundColor: AppColors.lineGrey,
                                lineHeight: 7,
                                progressBarColor: AppColors.secondaryColor,
                                percentage: 0.6,
                                width: 180,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "3",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Container(
                              width: 200,
                              child: GFProgressBar(
                                backgroundColor: AppColors.lineGrey,
                                lineHeight: 7,
                                progressBarColor: AppColors.secondaryColor,
                                percentage: 0.4,
                                width: 180,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "2",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Container(
                              width: 200,
                              child: GFProgressBar(
                                backgroundColor: AppColors.lineGrey,
                                lineHeight: 7,
                                progressBarColor: AppColors.secondaryColor,
                                percentage: 0.2,
                                width: 180,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "1",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Container(
                              width: 200,
                              child: GFProgressBar(
                                backgroundColor: AppColors.lineGrey,
                                lineHeight: 7,
                                progressBarColor: AppColors.secondaryColor,
                                percentage: 0.1,
                                width: 180,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                height: 1,
                color: AppColors.lineGrey,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Image.asset("asset/dummy1.png", height: 35),
                    title: Text(
                      "Brandie",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
                    ),
                    subtitle: Text(
                      "June,2023",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(),
                    ),
                    horizontalTitleGap: 8,
                    contentPadding: EdgeInsets.zero,
                  ),
                  SmoothStarRating(
                    rating: 4,
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
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "I've had the pleasure of using the Iconic Remidies for a few months now, and I couldn't be happier with my purchase. This device has genuinely transformed the way I manage my daily tasks and entertainment needs.",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(height: 1.5, color: AppColors.txtGrey),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 1,
                color: AppColors.lineGrey,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ConstString.recommended,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.darkPrimaryColor,
                          fontFamily: AppFont.fontMedium,
                          fontSize: 15.5,
                        ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        ConstString.viewAll,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.primaryColor,
                            fontFamily: AppFont.fontMedium,
                            fontSize: 14),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      width: 200,
                      decoration: BoxDecoration(
                          color: AppColors.decsGrey,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.decsGrey)),
                      child: Column(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Container(
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
                                          right: 10,
                                          child:
                                              SvgPicture.asset(AppIcons.like))
                                    ],
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12))),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                  SizedBox(
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
                                  SizedBox(
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
                                  SizedBox(
                                    height: 10,
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
                                                    color: AppColors
                                                        .darkPrimaryColor,
                                                    fontFamily:
                                                        AppFont.fontMedium),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "30% Off",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    fontSize: 10,
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontFamily:
                                                        AppFont.fontMedium),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                            onPressed: () {

                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.tilePrimaryColor,
                                                fixedSize: Size(110, 20),
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
                                                      color: AppColors
                                                          .primaryColor,
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
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
