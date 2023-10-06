import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/medicine_controller.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class OrderPlacement extends StatelessWidget {
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
        title: Text(ConstString.orderPlacement,
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
      body: orderPlaceWidget(context, controller),
      bottomSheet: Container(
        width: double.infinity,
        color: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                fixedSize: const Size(80, 45),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
            child: Text(
              ConstString.placeOrder,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: AppColors.white,
                  ),
            )),
      ),
    );
  }

  Widget orderPlaceWidget(BuildContext context, MedicineController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Image.asset("asset/medicinebox.jpg", height: 50),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Iconic Remedies",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontFamily: AppFont.fontBold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "15 Capsule(s) in Bottle",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: AppColors.txtGrey),
                              ),
                            ],
                          ),
                          const SizedBox(width: 80),
                          SvgPicture.asset(
                            AppIcons.delete,
                            height: 18,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SLE 120",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontFamily: AppFont.fontMedium,
                                    fontSize: 14),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "(30% Off)",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontSize: 10,
                                    color: AppColors.primaryColor,
                                    fontFamily: AppFont.fontMedium),
                          ),
                          const SizedBox(
                            width: 30,
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
                                Icons.remove,
                                color: AppColors.phoneGrey,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "0",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
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
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(
              height: 10,
              color: AppColors.decsGrey,
              thickness: 1,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ConstString.deliveryAddress,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.darkPrimaryColor,
                        fontFamily: AppFont.fontBold),
                  ),
                  SvgPicture.asset(AppIcons.edit)
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.lineGrey)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(AppIcons.fillpin, height: 20),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "67B Gregorio Grove ,Jaskolskiville",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.txtGrey),
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ConstString.billDetail,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.darkPrimaryColor,
                      fontFamily: AppFont.fontBold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.lineGrey)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ConstString.subtotal,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: AppColors.txtGrey,
                                      fontFamily: AppFont.fontMedium,
                                      fontSize: 13),
                            ),
                            Text(
                              "1 Item",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: AppColors.darkPrimaryColor,
                                      fontFamily: AppFont.fontMedium,
                                      fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ConstString.shipping,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: AppColors.txtGrey,
                                      fontFamily: AppFont.fontMedium,
                                      fontSize: 13),
                            ),
                            Text(
                              "SLE 220",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: AppColors.darkPrimaryColor,
                                      fontFamily: AppFont.fontMedium,
                                      fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ConstString.discount,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: AppColors.txtGrey,
                                      fontFamily: AppFont.fontMedium,
                                      fontSize: 13),
                            ),
                            Text(
                              "SLE 100",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: AppColors.darkPrimaryColor,
                                      fontFamily: AppFont.fontMedium,
                                      fontSize: 13),
                            ),
                          ],
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: AppColors.lineGrey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ConstString.totalAmount,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: AppColors.darkPrimaryColor,
                                      fontFamily: AppFont.fontMedium,
                                      fontSize: 13),
                            ),
                            Text(
                              "SLE 120",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: AppColors.primaryColor,
                                      fontFamily: AppFont.fontBold,
                                      fontSize: 13),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ConstString.paymentMethod,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.darkPrimaryColor,
                      fontFamily: AppFont.fontBold),
                ),
              ),
            ),
            Container(
                height: 260,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Obx(() => GestureDetector(
                            onTap: () {
                              controller.selectedPaymentMethod.value =
                                  controller.paymentMethod[index];
                              print(controller.selectedPaymentMethod);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.lineGrey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: AppColors.lineGrey)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            controller.paymentMethodIcon[index],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        controller.paymentMethod[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color:
                                                    AppColors.darkPrimaryColor,
                                                fontFamily: AppFont.fontMedium,
                                                fontSize: 13),
                                      ),
                                      Spacer(),
                                      SvgPicture.asset(
                                        controller.selectedPaymentMethod ==
                                                controller.paymentMethod[index]
                                            ? AppIcons.radioFill
                                            : AppIcons.radio,
                                        height: 22,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ));
                    },
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ConstString.presUploadedByYou,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.darkPrimaryColor,
                      fontFamily: AppFont.fontBold),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: AppColors.lineGrey,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }
}
