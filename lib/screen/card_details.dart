import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/cart_controller.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class CardDetails extends StatelessWidget {
  CartController controller = Get.put(CartController());

  CardDetails({super.key});

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
        title: Text(ConstString.cardDetail,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
      ),
      body: cardDetailsWidget(context),
    );
  }

  Widget cardDetailsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Card Detail",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: AppColors.primaryColor,
                fontFamily: AppFont.fontSemiBold,
                fontSize: 19),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Card Number",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 15,
                color: AppColors.txtGrey,
                fontFamily: AppFont.fontMedium),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            style: Theme.of(context).textTheme.titleMedium,
            decoration: InputDecoration(
              filled: true,
              enabled: true,
              fillColor: AppColors.transparentDetails,
              hintText: "Enter card number...",
              hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontFamily: AppFont.fontMedium,
                  fontSize: 14,
                  color: AppColors.skipGrey),
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 17,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expiration Date",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 15,
                          color: AppColors.txtGrey,
                          fontFamily: AppFont.fontMedium),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Obx(() => Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  color: AppColors.decsGrey,
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownButton<String>(
                                underline: SizedBox(),
                                icon: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: SvgPicture.asset(AppIcons.arrowDown),
                                ),
                                value: controller.selectedMonth.value,
                                onChanged: (String? newValue) {
                                  controller.selectedMonth.value = newValue!;
                                },
                                items: controller.months
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Obx(() => Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  color: AppColors.decsGrey,
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownButton<String>(
                                underline: SizedBox(),
                                icon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: SvgPicture.asset(AppIcons.arrowDown),
                                ),
                                value: controller.selectedYear.value,
                                onChanged: (String? newValue) {
                                  controller.selectedYear.value = newValue!;
                                },
                                items: controller.years
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CVV",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 15,
                          color: AppColors.txtGrey,
                          fontFamily: AppFont.fontMedium),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.titleMedium,
                        decoration: InputDecoration(
                          filled: true,
                          enabled: true,
                          fillColor: AppColors.transparentDetails,
                          hintText: "Enter CVV",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontFamily: AppFont.fontMedium,
                                  fontSize: 14,
                                  color: AppColors.skipGrey),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    fixedSize: const Size(200, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  ConstString.pay,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Colors.white,
                      ),
                )),
          )
        ],
      ),
    );
  }
}
