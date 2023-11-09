// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medic/_dart/_init.dart';
import 'package:medic/controller/cart_controller.dart';
import 'package:medic/model/review_data_model.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';
import 'package:medic/widgets/app_dialogue.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class AddReviewScreen extends StatefulWidget {
  String? orderId;
  Map<String, String>? medicineIdMap;

  AddReviewScreen({super.key, this.orderId, this.medicineIdMap});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  List<String>? medicineIdList;

  String? selectedMedicine;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    medicineIdList = widget.medicineIdMap!.values.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CartController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
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
            backgroundColor: AppColors.white,
            title: Text(ConstString.addReview,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontFamily: AppFont.fontBold)),
            elevation: 1.5,
            shadowColor: AppColors.txtGrey.withOpacity(0.2),
          ),
          body: reviewWidget(context, controller),
        );
      },
    );
  }

  Widget reviewWidget(BuildContext context, CartController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                ConstString.writereview,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: 21,
                    letterSpacing: 0,
                    fontFamily: AppFont.fontBold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              ConstString.leavereview,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 13,
                    letterSpacing: 0,
                    fontFamily: AppFont.fontMedium,
                    color: AppColors.txtGrey,
                  ),
            ),
            const SizedBox(
              height: 35,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.selectMedicine,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14, letterSpacing: 0),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: controller.fetchMedicineNames(medicineIdList!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CupertinoActivityIndicator();
                } else if (snapshot.hasData) {
                  List<String> medicineNames = snapshot.data!;
                  return Container(
                    height: 55,
                    decoration: BoxDecoration(
                        color: AppColors.decsGrey,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonFormField(
                      // itemHeight: kMinInteractiveDimension,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 13),
                      hint: Text(
                        "Select Medicine",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 14, color: AppColors.txtGrey),
                      ),
                      decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none),
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: SvgPicture.asset(AppIcons.arrowDown),
                      ),
                      // underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(10),
                      onChanged: (value) {
                        selectedMedicine = value!;
                        if (!medicineNames.contains(value)) {
                          medicineNames.add(value);
                        }
                        setState(() {});
                      },
                      items: medicineNames.map((String medicine) {
                        return DropdownMenuItem<String>(
                          value: medicine,
                          child: Text(
                            medicine,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      value:
                          selectedMedicine, // Handle a value not in list scenario
                    ),
                  );
                } else {
                  return Text(
                    "No Medicines",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 14),
                  );
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                ConstString.rateproduct,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14, letterSpacing: 0),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SmoothStarRating(
                rating: controller.rating,
                allowHalfRating: true,
                defaultIconData: Icons.star_outline_rounded,
                filledIconData: Icons.star_rounded,
                halfFilledIconData: Icons.star_half_rounded,
                starCount: 5,
                onRatingChanged: (rating) {
                  setState(() {
                    controller.rating = rating;
                  });
                },
                size: 30,
                color: AppColors.primaryColor,
                borderColor: AppColors.primaryColor,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ConstString.review,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14, letterSpacing: 0),
                ),
                const SizedBox(
                  width: 5,
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: SvgPicture.asset(
                      AppIcons.info,
                      height: 17,
                      color: AppColors.txtGrey,
                    )),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFormField(
                controller: controller.reviewText,
                textCapitalization: TextCapitalization.sentences,
                autofocus: false,
                maxLines: 5,
                cursorColor: AppColors.txtGrey,
                decoration: InputDecoration(
                  filled: true,
                  enabled: true,
                  fillColor: AppColors.phoneGrey.withOpacity(0.2),
                  hintText: "Write a review",
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.decsGrey, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.decsGrey, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.decsGrey, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.decsGrey, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                "200 character required",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: AppColors.txtGrey, fontSize: 11.5),
              ),
            ),
            const SizedBox(
              height: 75,
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.reviewText.text.isEmpty) {
                  showInSnackBar("Please enter review", title: "The Medic");
                  return;
                }
                showProgressDialogue(context);
                String id = controller.reviewRef.doc().id;
                ReviewDataModel review = ReviewDataModel(
                    id: id,
                    rating: controller.rating,
                    review: controller.reviewText.text,
                    medicineId: selectedMedicine,
                    userId: controller.currentUser,
                    orderId: widget.orderId,
                    createdTime: DateTime.now());
                await controller.uploadReview(review);
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  fixedSize: const Size(170, 55),
                  backgroundColor: AppColors.darkPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: Text(
                ConstString.submit,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: AppColors.white,
                    fontSize: 15,
                    fontFamily: AppFont.fontMedium),
              ),
            )
          ],
        ),
      ),
    );
  }
}
