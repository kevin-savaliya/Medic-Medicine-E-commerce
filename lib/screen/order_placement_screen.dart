// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:medic/controller/cart_controller.dart';
import 'package:medic/controller/medicine_controller.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/model/prescription_model.dart';
import 'package:medic/model/user_address.dart';
import 'package:medic/screen/myaddress_screen.dart';
import 'package:medic/screen/order_details_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';
import 'package:medic/widgets/app_dialogue.dart';

class OrderPlacement extends StatelessWidget {
  MedicineController controller = Get.put(MedicineController());

  // CartController cartController = Get.put(CartController());

  OrderPlacement({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CartController(),
      builder: (cartController) {
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
          body: orderPlaceWidget(context, cartController),
          bottomSheet: Container(
            width: double.infinity,
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            child: ElevatedButton(
                onPressed: () async {
                  if (cartController.orderData.value.addressId == null) {
                    showInSnackBar("Please Enter Delivery Address");
                    return;
                  }
                  showProgressDialogue(context);
                  await cartController.placeOrder();
                  Get.to(() => OrderDetailScreen());
                },
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
      },
    );
  }

  Widget orderPlaceWidget(BuildContext context, CartController cartController) {
    if ((cartController.orderData.value.medicineData ?? []).isNotEmpty) {
      List<MedicineData> medicineList =
          (cartController.orderData.value.medicineData ?? []);
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: medicineList.length,
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      height: 15,
                      color: AppColors.lineGrey,
                      thickness: 1,
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 70,
                          width: 100,
                          child: CachedNetworkImage(
                            imageUrl: medicineList[index].image ?? "",
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => SizedBox(
                              width: 30,
                              height: 30,
                              child: Center(
                                  child: LoadingIndicator(
                                colors: [AppColors.primaryColor],
                                indicatorType: Indicator.ballScale,
                                strokeWidth: 1,
                              )),
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 170,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${medicineList[index].genericName}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontFamily: AppFont.fontBold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${medicineList[index].uses}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(color: AppColors.txtGrey),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 30),
                                GestureDetector(
                                  onTap: () {
                                    cartController.removeFromCart(
                                        medicineList[index].id!);
                                  },
                                  child: SvgPicture.asset(
                                    AppIcons.delete,
                                    height: 18,
                                  ),
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
                                  onTap: () {
                                    cartController.decrementQuantity(
                                        medicineList[index].id!);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.decsGrey,
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 28,
                                    width: 28,
                                    child: Icon(
                                      Icons.remove,
                                      color: medicineList[index].quantity == 0
                                          ? AppColors.phoneGrey
                                          : AppColors.primaryColor,
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
                                    "${medicineList[index].quantity}",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cartController.incrementQuantity(
                                        medicineList[index].id!);
                                  },
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
                  );
                },
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
                    GestureDetector(
                        onTap: () {
                          Get.to(() => MyAddressScreen());
                        },
                        child: SvgPicture.asset(
                          AppIcons.edit,
                          height: 20,
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: cartController.fetchActiveAddress(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CupertinoActivityIndicator();
                  } else if (snapshot.hasData) {
                    UserAddress add = snapshot.data!;
                    cartController.orderData.value.addressId = add.id;
                    String address =
                        "${add.address}, ${add.area}, ${add.landmark}";
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.lineGrey)),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              SvgPicture.asset(AppIcons.fillpin, height: 20),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                address,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: AppColors.txtGrey, fontSize: 14),
                              )
                            ],
                          )),
                    );
                  } else {
                    return const Text("");
                  }
                },
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  height: 160,
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
                                "${cartController.orderData.value.medicineData!.length}",
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
              // TODO: Kevin setup payment method
              /*SizedBox(
                  height: 260,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Obx(() => GestureDetector(
                          onTap: () {
                            // controller.selectedPaymentMethod.value =
                            // controller.paymentMethod[index];
                            // print(controller.selectedPaymentMethod);
                          },
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.lineGrey),
                                  borderRadius:
                                  BorderRadius.circular(10)),
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
                                              color:
                                              AppColors.lineGrey)),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          controller
                                              .paymentMethodIcon[index],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      controller.paymentMethod[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                          color: AppColors
                                              .darkPrimaryColor,
                                          fontFamily:
                                          AppFont.fontMedium,
                                          fontSize: 13),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(
                                      controller.selectedPaymentMethod ==
                                          controller
                                              .paymentMethod[index]
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
                  )),*/
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
              StreamBuilder(
                stream: cartController.fetchPrescriptionData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CupertinoActivityIndicator();
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
                    return Text("No Prescription Found!");
                  }
                },
              ),
              const SizedBox(
                height: 70,
              )
            ],
          ),
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
                ConstString.cartEmpty,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 13, color: AppColors.skipGrey),
              )
            ],
          ),
        ),
      );
    }
  }
}
