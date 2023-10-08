import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/user/my_name_text_widget.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

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
        title: Text(ConstString.orderDetails,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
      ),
      body: orderDetailWidget(context),
    );
  }

  Container orderDetailWidget(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ConstString.patient,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.txtGrey,
                          fontFamily: AppFont.fontMedium,
                          fontSize: 13),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    MyNameTextWidget(
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              color: AppColors.primaryColor,
                              fontFamily: AppFont.fontBold,
                              fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ConstString.orderNo,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.txtGrey,
                          fontFamily: AppFont.fontMedium,
                          fontSize: 13),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "#67890",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.primaryColor,
                          fontFamily: AppFont.fontBold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.billDetail,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.darkPrimaryColor,
                    fontFamily: AppFont.fontBold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 200,
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
                            ConstString.orderItem,
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
                      Divider(
                        height: 10,
                        color: AppColors.lineGrey,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ConstString.cartValue,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: AppColors.txtGrey,
                                    fontFamily: AppFont.fontMedium,
                                    fontSize: 13),
                          ),
                          Text(
                            "SLE 2200",
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
                      Divider(
                        height: 10,
                        color: AppColors.lineGrey,
                        thickness: 1,
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
                      Divider(
                        height: 10,
                        color: AppColors.lineGrey,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ConstString.total,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: AppColors.txtGrey,
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
                                    fontFamily: AppFont.fontMedium,
                                    fontSize: 13),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.paymentDetails,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.darkPrimaryColor,
                    fontFamily: AppFont.fontBold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "2 oct 2023",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.darkPrimaryColor,
                    fontFamily: AppFont.fontMedium,
                    fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lineGrey),
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.creditCard, height: 20),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      ConstString.creditCard,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.darkPrimaryColor,
                          fontFamily: AppFont.fontMedium,
                          fontSize: 13),
                    ),
                    const Spacer(),
                    Text(
                      "SLE 120",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.primaryColor,
                          fontFamily: AppFont.fontMedium,
                          fontSize: 13),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.addressDetail,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.darkPrimaryColor,
                    fontFamily: AppFont.fontBold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lineGrey),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ConstString.home,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.darkPrimaryColor,
                          fontFamily: AppFont.fontMedium,
                          fontSize: 13),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.other,
                          color: AppColors.txtGrey,
                          height: 15,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        MyNameTextWidget(
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColors.txtGrey, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.pin,
                          color: AppColors.txtGrey,
                          height: 15,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "67B Gregorio Grove, Jaskolskiville",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColors.txtGrey, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.phone,
                          color: AppColors.txtGrey,
                          height: 12,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "+61488827080",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColors.txtGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.seller,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.darkPrimaryColor,
                    fontFamily: AppFont.fontBold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lineGrey),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ConstString.byMedic,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.darkPrimaryColor,
                          fontFamily: AppFont.fontMedium,
                          fontSize: 13),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.other,
                          color: AppColors.txtGrey,
                          height: 15,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        MyNameTextWidget(
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColors.txtGrey, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.pin,
                          color: AppColors.txtGrey,
                          height: 15,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "67B Gregorio Grove, Jaskolskiville",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColors.txtGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.presUploadedByYou,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.darkPrimaryColor,
                    fontFamily: AppFont.fontBold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: AppColors.lineGrey,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.decsGrey,
                          fixedSize: const Size(200, 45),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(
                        ConstString.addReview,
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: AppColors.txtGrey,
                                ),
                      )),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          fixedSize: const Size(200, 45),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(
                        ConstString.viewInvoice,
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Colors.white,
                                ),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ]),
        ),
      ),
    );
  }
}
