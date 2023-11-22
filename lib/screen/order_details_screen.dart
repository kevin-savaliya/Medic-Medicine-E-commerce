// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/cart_controller.dart';
import 'package:medic/model/order_data.dart';
import 'package:medic/model/prescription_model.dart';
import 'package:medic/model/user_address.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/screen/add_review_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/user/my_name_text_widget.dart';

class OrderDetailScreen extends StatelessWidget {
  CartController controller = Get.put(CartController());

  String? orderId;

  OrderDetailScreen({super.key, this.orderId});

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

  Widget orderDetailWidget(BuildContext context) {
    return FutureBuilder(
      future: controller.fetchOrderIds(orderId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasData) {
          OrderData orderData = snapshot.data!;
          String formatDate = controller.OrderDateFormat(orderData.orderDate!);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder(
                      stream: controller.fetchUserById(orderData.creatorId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CupertinoActivityIndicator();
                        } else if (snapshot.hasData) {
                          UserModel user = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ConstString.patient,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: AppColors.txtGrey,
                                        fontFamily: AppFont.fontMedium,
                                        fontSize: 13),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${user.name}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: AppColors.primaryColor,
                                        fontFamily: AppFont.fontBold,
                                        fontSize: 16),
                              ),
                            ],
                          );
                        } else {
                          return const Text("No User");
                        }
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          ConstString.orderNo,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: AppColors.txtGrey,
                                  fontFamily: AppFont.fontMedium,
                                  fontSize: 13),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "#${orderData.id!.substring(0, 7)}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
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
                                "SLL 2200",
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
                                "SLL 100",
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
                                "SLL 120",
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
                    formatDate,
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
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: AppColors.darkPrimaryColor,
                                  fontFamily: AppFont.fontMedium,
                                  fontSize: 13),
                        ),
                        const Spacer(),
                        Text(
                          "SLL 120",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: StreamBuilder(
                      stream: controller.fetchUserById(orderData.creatorId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CupertinoActivityIndicator();
                        } else if (snapshot.hasData) {
                          UserModel user = snapshot.data!;
                          String contact =
                              "${user.countryCode} ${user.mobileNo}";
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ConstString.home,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
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
                                  Text(
                                    "${user.name}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: AppColors.txtGrey,
                                            fontSize: 12),
                                  ),
                                ],
                              ),
                              StreamBuilder(
                                stream: controller
                                    .fetchAddressById(orderData.addressId!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CupertinoActivityIndicator();
                                  } else if (snapshot.hasData) {
                                    UserAddress add = snapshot.data!;
                                    String address =
                                        "${add.address}, ${add.area}, ${add.landmark}";
                                    return Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.pin,
                                          color: AppColors.txtGrey,
                                          height: 15,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            address,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    color: AppColors.txtGrey,
                                                    fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
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
                                    contact,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: AppColors.txtGrey,
                                            fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return SizedBox();
                        }
                      },
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ConstString.byMedic,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
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
                            Text(
                              "The Medic",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: AppColors.txtGrey, fontSize: 12),
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
                                  .copyWith(
                                      color: AppColors.txtGrey, fontSize: 12),
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
                StreamBuilder(
                  stream: controller
                      .fetchPrescriptionById(orderData.prescriptionId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (snapshot.hasData) {
                      PrescriptionData prescription = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              height: 120,
                              width: 120,
                              imageUrl: prescription.images?[0] ?? '',
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                width: 120,
                                child: Center(
                                  child: CupertinoActivityIndicator(
                                    color: AppColors.primaryColor,
                                    animating: true,
                                    radius: 14,
                                  ),
                                ),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 100,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.lineGrey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(
                            Icons.error_outline,
                            color: AppColors.txtGrey,
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => AddReviewScreen(
                                  orderId: orderData.id,
                                  medicineIdMap: orderData.medicineId,
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.decsGrey,
                              fixedSize: const Size(200, 45),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: Text(
                            ConstString.addReview,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
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
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
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
          );
        } else {
          return const Center(child: Text("No Data Found"));
        }
      },
    );
  }
}
