// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:medic/_dart/_init.dart';
import 'package:medic/controller/cart_controller.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/screen/order_placement_screen.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';

class CartScreen extends StatelessWidget {
  // CartController controller = Get.put(CartController());

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CartController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            titleSpacing: 15,
            automaticallyImplyLeading: false,
            title: Text(ConstString.cart,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontFamily: AppFont.fontBold)),
            elevation: 1.5,
            shadowColor: AppColors.txtGrey.withOpacity(0.2),
          ),
          body: getContent(context, controller),
        );
      },
    );
  }

  Widget getContent(BuildContext context, CartController controller) {
    if (controller.firebaseUser == null) {
      return UserNotLoggedInWidget();
    }
    return cartWidget(context, controller);
  }

  Widget cartWidget(BuildContext context, CartController controller) {
    if ((controller.orderData.value.medicineData ?? []).isNotEmpty) {
      final orderData = controller.orderData;
      List<MedicineData> medicineList = orderData.value.medicineData ?? [];
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
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
                          height: 15, color: AppColors.lineGrey, thickness: 1));
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      children: [
                        Row(
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
                                    (context, url, downloadProgress) =>
                                        SizedBox(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                    fontFamily:
                                                        AppFont.fontBold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${medicineList[index].description}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    color: AppColors.txtGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    GestureDetector(
                                      onTap: () {
                                        controller.removeFromCart(
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
                                      "SLL ${medicineList[index].medicinePrice ?? "100"}",
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
                                      width: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.decrementQuantity(
                                            medicineList[index].id!);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.decsGrey,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        height: 28,
                                        width: 28,
                                        child: Icon(
                                          Icons.remove,
                                          color:
                                              medicineList[index].quantity == 0
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.incrementQuantity(
                                            medicineList[index].id!);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.decsGrey,
                                            borderRadius:
                                                BorderRadius.circular(5)),
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
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Obx(() => controller.preRequireList
                                .contains(medicineList[index].id)
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "prescription is required to purchase this medicine",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: AppColors.red),
                                  ),
                                ),
                              )
                            : const SizedBox())
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ConstString.discount,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: AppColors.darkPrimaryColor,
                                fontFamily: AppFont.fontBold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => controller.selectedDiscount.value != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          width: double.infinity,
                          // height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    AppColors.listColor4dark,
                                    AppColors.listColor4
                                  ])),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${controller.discountPercentage.floor()}%",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontSize: 22,
                                                    color: AppColors.white,
                                                    fontFamily:
                                                        AppFont.fontBold),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "OFF",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: AppColors.white,
                                                    fontFamily:
                                                        AppFont.fontBold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${controller.discountName}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: AppColors.white,
                                                fontFamily: AppFont.fontBold),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Code",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color:
                                                    AppColors.darkPrimaryColor,
                                                fontFamily: AppFont.fontBold),
                                      ),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      Text(
                                        "${controller.discountCode}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color:
                                                    AppColors.darkPrimaryColor,
                                                fontSize: 14,
                                                fontFamily: AppFont.fontBold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    ConstString.applyDiscount,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.black, fontFamily: AppFont.fontBold),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: TextFormField(
                  controller: controller.disCodeController,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    filled: true,
                    enabled: true,
                    suffixIcon: TextButton(
                        onPressed: () {
                          controller.applyDiscount(
                              controller.disCodeController.text.trim());
                        },
                        child: Text(
                          ConstString.apply,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 14,
                                  color: AppColors.primaryColor,
                                  fontFamily: AppFont.fontBold),
                        )),
                    fillColor: AppColors.transparentDetails,
                    hintText: "Discount Code...",
                    hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
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
                      vertical: 17,
                    ),
                  ),
                ),
              ),
              // Obx(() => Align(
              //       alignment: Alignment.centerLeft,
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 15),
              //         child: Text(
              //           controller.isDiscountValid.value
              //               ? "Discount Applied!"
              //               : "Invalid Discount Code",
              //           style: Theme.of(context)
              //               .textTheme
              //               .titleMedium!
              //               .copyWith(
              //                   fontSize: 14,
              //                   fontFamily: AppFont.fontMedium,
              //                   color: controller.isDiscountValid.value
              //                       ? AppColors.green
              //                       : AppColors.red),
              //         ),
              //       ),
              //     )),
              const SizedBox(
                height: 20,
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
                                ConstString.items,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: AppColors.txtGrey,
                                        fontFamily: AppFont.fontMedium,
                                        fontSize: 13),
                              ),
                              Text(
                                "${controller.orderData.value.medicineData!.length}",
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
                                "${controller.getTotalQuantity()} Item",
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
                                "SLL ${controller.shippingFee}",
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
                              Obx(() => Text(
                                    "SLL ${controller.discountAmount.toStringAsFixed(1)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: AppColors.darkPrimaryColor,
                                            fontFamily: AppFont.fontMedium,
                                            fontSize: 13),
                                  )),
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
                                "SLL ${controller.getTotalPrice(controller.discountPercentage.value, controller.isDiscountValid)}",
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
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (medicineList.isNotEmpty) {
                      if (await controller
                          .checkPrescriptionOrder(medicineList)) {
                        Get.off(() => OrderPlacement());
                      } else {
                        showInSnackBar("Medicine Prescription is not Approved!",
                            isSuccess: false, title: "The Medic");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      fixedSize: const Size(160, 45),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: Text(
                    ConstString.placeOrder,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.white,
                        ),
                  )),
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
              const SizedBox(
                height: 10,
              ),
              SvgPicture.asset(AppImages.emptyBin),
              const SizedBox(
                height: 10,
              ),
              Text(
                ConstString.cartEmpty,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14, color: AppColors.skipGrey),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget UserNotLoggedInWidget() {
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
            ConstString.loginToViewCartItems,
            style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
                color: AppColors.primaryColor,
                fontSize: 16,
                fontFamily: AppFont.fontMedium),
          ),
        ],
      ),
    );
  }
}
