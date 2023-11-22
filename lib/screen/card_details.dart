import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/cart_controller.dart';
import 'package:medic/model/credit_card_model.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';
import 'package:medic/widgets/app_dialogue.dart';

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
        title: Text(ConstString.addNewCard,
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Holder Name",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 13,
                  color: AppColors.txtGrey,
                  fontFamily: AppFont.fontMedium),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: controller.cardHolderController,
              textCapitalization: TextCapitalization.words,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                filled: true,
                enabled: true,
                fillColor: AppColors.transparentDetails,
                hintText: "Enter Holder Name...",
                hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontFamily: AppFont.fontMedium,
                    fontSize: 14,
                    color: AppColors.phoneGrey),
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
            const SizedBox(
              height: 10,
            ),
            Text(
              "Card Number",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 13,
                  color: AppColors.txtGrey,
                  fontFamily: AppFont.fontMedium),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: controller.cardNumberController,
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                filled: true,
                enabled: true,
                fillColor: AppColors.transparentDetails,
                hintText: "0000 0000 0000",
                hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontFamily: AppFont.fontMedium,
                    fontSize: 14,
                    color: AppColors.phoneGrey),
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
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Expire Date",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 13,
                            color: AppColors.txtGrey,
                            fontFamily: AppFont.fontMedium),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          maxLengthEnforcement:
                              MaxLengthEnforcement.truncateAfterCompositionEnds,
                          keyboardType: TextInputType.number,
                          controller: controller.expDateController,
                          style: Theme.of(context).textTheme.titleMedium,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            enabled: true,
                            fillColor: AppColors.transparentDetails,
                            hintText: "MM/YY",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontFamily: AppFont.fontMedium,
                                    fontSize: 14,
                                    color: AppColors.phoneGrey),
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
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CVV",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 13,
                            color: AppColors.txtGrey,
                            fontFamily: AppFont.fontMedium),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          maxLength: 3,
                          maxLengthEnforcement:
                              MaxLengthEnforcement.truncateAfterCompositionEnds,
                          keyboardType: TextInputType.number,
                          controller: controller.cvvController,
                          style: Theme.of(context).textTheme.titleMedium,
                          decoration: InputDecoration(
                            counterText: '',
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
                                    color: AppColors.phoneGrey),
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
              height: 300,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () {
                    String cardNumber =
                        controller.cardNumberController.text.trim();
                    String cvv = controller.cvvController.text.trim();
                    String expDate =
                        "${controller.selectedMonth}/${controller.selectedYear.substring(2)}";
                    if (controller.validateCardInfo()) {
                      showProgressDialogue(context);
                      String id = controller.cardRef.doc().id;
                      CreditCard card = CreditCard(
                          id: id,
                          cardHolder:
                              controller.cardHolderController.text.trim(),
                          cardNumber:
                              controller.cardNumberController.text.trim(),
                          expiryDate: controller.expDateController.text.trim(),
                          cvv: controller.cvvController.text.trim());
                      controller.addCardDetails(card);
                    } else {
                      showInSnackBar("Invalid card details",
                          title: "The Medic", isSuccess: false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      fixedSize: const Size(200, 45),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: Text(
                    ConstString.addCard,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Colors.white,
                        ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
