// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:medic/controller/cart_controller.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/model/order_data.dart';
import 'package:medic/model/order_with_medicine.dart';
import 'package:medic/model/user_address.dart';
import 'package:medic/screen/order_details_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/app_dialogue.dart';
import 'package:medic/widgets/shimmer_widget.dart';

class OrderHistory extends StatelessWidget {
  CartController controller = Get.put(CartController());

  OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          title: Text(ConstString.orderHistory,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontFamily: AppFont.fontBold)),
          elevation: 1.5,
          shadowColor: AppColors.txtGrey.withOpacity(0.2),
          bottom: TabBar(
            automaticIndicatorColorAdjustment: true,
            tabs: const [
              Tab(
                text: 'Current Orders',
                height: 40,
              ),
              Tab(
                text: 'Past Orders',
                height: 40,
              ),
            ],
            // physics: const BouncingScrollPhysics(),
            labelColor: AppColors.primaryColor,
            labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 13.5,
                letterSpacing: 0.3,
                fontFamily: AppFont.fontMedium),
            unselectedLabelColor: AppColors.txtGrey,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelStyle: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(
                    fontSize: 14,
                    letterSpacing: 0.3,
                    fontFamily: AppFont.fontMedium),
            indicatorWeight: 2,
          ),
        ),
        body: const TabBarView(children: [CurrentOrder(), PastOrder()]),
      ),
    );
  }
}

class CurrentOrder extends GetWidget<CartController> {
  const CurrentOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OrderWithMedicines>>(
      stream: controller.ordersWithMedicines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return OrderDetailShimmer(itemCount: snapshot.data?.length);
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                    ConstString.noOrder,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 15, color: AppColors.skipGrey),
                  )
                ],
              ),
            ),
          );
        }

        List<OrderWithMedicines> ordersWithMedicines = snapshot.data!;

        List<Widget> medicineAddressDateWidgets = [];
        for (var order in ordersWithMedicines) {
          for (var medicine in order.medicines) {
            medicineAddressDateWidgets.add(GestureDetector(
              onTap: () {
                Get.to(() => OrderDetailScreen(
                      orderId: order.orderData.id,
                      isTrue: true,
                      medicineId: medicine.id,
                    ));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 70,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: medicine.image ?? "",
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
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${medicine.genericName}",
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
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "LE ${medicine.medicinePrice}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontFamily: AppFont.fontMedium,
                                      fontSize: 12),
                            ),
                          ],
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                orderCancelDialogue(context, () async {
                                  Get.back();
                                  await controller
                                      .cancelOrder(order.orderData.id!);
                                });
                              },
                              child: SvgPicture.asset(
                                AppIcons.delete,
                                color: AppColors.red,
                                height: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 30,
                      color: AppColors.lineGrey,
                      thickness: 1,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${order.address!.address}, ${order.address!.area}, ${order.address!.landmark}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: AppColors.txtGrey, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                order.orderData.orderDate != null
                                    ? DateFormat('d MMM yyyy hh:mm a')
                                        .format(order.orderData.orderDate!)
                                    : 'Date not available',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: AppColors.txtGrey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 13,
                          color: AppColors.txtGrey,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: ElevatedButton(
                    //           onPressed: () {},
                    //           style: ElevatedButton.styleFrom(
                    //               backgroundColor: AppColors.decsGrey,
                    //               fixedSize: const Size(200, 45),
                    //               elevation: 0,
                    //               shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(30))),
                    //           child: Text(
                    //             ConstString.cancle,
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .displayMedium!
                    //                 .copyWith(
                    //                   color: AppColors.txtGrey,
                    //                 ),
                    //           )),
                    //     ),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     Expanded(
                    //       child: ElevatedButton(
                    //           onPressed: () {},
                    //           style: ElevatedButton.styleFrom(
                    //               backgroundColor: AppColors.primaryColor,
                    //               fixedSize: const Size(200, 45),
                    //               elevation: 0,
                    //               shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(30))),
                    //           child: Text(
                    //             ConstString.completed,
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .displayMedium!
                    //                 .copyWith(
                    //                   color: Colors.white,
                    //                 ),
                    //           )),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ));
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            children: medicineAddressDateWidgets,
          ),
        );
      },
    );
  }
}

class PastOrder extends GetWidget<CartController> {
  const PastOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OrderWithMedicines>>(
      stream: controller.pastOrdersWithMedicines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return OrderDetailShimmer(itemCount: snapshot.data?.length);
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                    ConstString.noOrder,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 15, color: AppColors.skipGrey),
                  )
                ],
              ),
            ),
          );
        }

        List<OrderWithMedicines> ordersWithMedicines = snapshot.data!;

        // Flatten the list of medicines with their corresponding addresses and order dates
        List<Widget> medicineAddressDateWidgets = [];
        for (var order in ordersWithMedicines) {
          for (var medicine in order.medicines) {
            medicineAddressDateWidgets.add(GestureDetector(
              onTap: () {
                Get.to(() => OrderDetailScreen(
                      orderId: order.orderData.id,
                      isTrue: true,
                      medicineId: medicine.id,
                    ));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 70,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: medicine.image ?? "",
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
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${medicine.genericName}",
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
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "LE ${medicine.medicinePrice}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontFamily: AppFont.fontMedium,
                                      fontSize: 12),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.checkFill,
                              color: order.orderData.orderStatus == "Cancelled"
                                  ? AppColors.red
                                  : AppColors.green,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              order.orderData.orderStatus ?? "Placed",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color:
                                        order.orderData.orderStatus ==
                                                    "Cancelled" ||
                                                order.orderData.orderStatus ==
                                                    "Rejected" ||
                                                order.orderData.orderStatus ==
                                                    "Inactive"
                                            ? AppColors.red
                                            : AppColors.green,
                                  ),
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      height: 30,
                      color: AppColors.lineGrey,
                      thickness: 1,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${order.address!.address}, ${order.address!.area}, ${order.address!.landmark}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: AppColors.txtGrey, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                order.orderData.orderDate != null
                                    ? DateFormat('d MMM yyyy hh:mm a')
                                        .format(order.orderData.orderDate!)
                                    : 'Date not available',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: AppColors.txtGrey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 13,
                          color: AppColors.txtGrey,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
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
                                ConstString.cancle,
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
                              onPressed: () {
                                showProgressDialogue(context);
                                controller.reorder(order.orderData);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  fixedSize: const Size(200, 45),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: Text(
                                ConstString.reorder,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            children: medicineAddressDateWidgets,
          ),
        );
      },
    );
  }
}
