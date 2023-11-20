// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:medic/controller/cart_controller.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/model/order_data.dart';
import 'package:medic/model/user_address.dart';
import 'package:medic/screen/order_details_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

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
        body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [CurrentOrder(), PastOrder()]),
      ),
    );
  }
}

class CurrentOrder extends GetWidget<CartController> {
  const CurrentOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.fetchCurrentOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CupertinoActivityIndicator(
            color: AppColors.primaryColor,
          ));
        } else if (snapshot.hasData) {
          List<OrderData> orderData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  height: 20,
                  color: AppColors.lineGrey,
                );
              },
              itemCount: orderData.length,
              itemBuilder: (context, index) {
                String formattedDate =
                    controller.formatDateTime(orderData[index].orderDate!);
                return GestureDetector(
                  onTap: () {
                    Get.to(() => OrderDetailScreen());
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        StreamBuilder(
                          stream: controller.fetchMedicineFromOrder(
                              orderData[index].medicineId.values.first),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CupertinoActivityIndicator());
                            } else if (snapshot.hasData) {
                              MedicineData medicine = snapshot.data!;
                              return Row(
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
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${medicine.genericName}",
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
                                        "SLE 120",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontFamily: AppFont.fontMedium,
                                                fontSize: 12),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder(
                                  stream: controller.fetchAddressById(
                                      orderData[index].addressId ?? ""),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CupertinoActivityIndicator();
                                    } else if (snapshot.hasData) {
                                      UserAddress add = snapshot.data!;
                                      String address =
                                          "${add.address}, ${add.area}, ${add.landmark}";

                                      return Text(
                                        address,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: AppColors.txtGrey,
                                                fontSize: 12),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  formattedDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: AppColors.txtGrey,
                                          fontSize: 12),
                                ),
                              ],
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
                                          borderRadius:
                                              BorderRadius.circular(30))),
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
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      fixedSize: const Size(200, 45),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  child: Text(
                                    ConstString.completed,
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
                );
              },
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
      },
    );
  }
}

class PastOrder extends GetWidget<CartController> {
  const PastOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.fetchPastOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator(
            color: AppColors.primaryColor,
          );
        } else if (snapshot.hasData) {
          List<OrderData> orderData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  height: 20,
                  color: AppColors.lineGrey,
                );
              },
              itemCount: orderData.length,
              itemBuilder: (context, index) {
                String formattedDate =
                    controller.formatDateTime(orderData[index].orderDate!);
                return GestureDetector(
                  onTap: () {
                    Get.to(() => OrderDetailScreen());
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        StreamBuilder(
                          stream: controller.fetchMedicineFromOrder(
                              orderData[index].medicineId.values.first),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CupertinoActivityIndicator());
                            } else if (snapshot.hasData) {
                              MedicineData medicine = snapshot.data!;
                              return Row(
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
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        medicine.genericName!,
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
                                        "SLE 120",
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
                                        color: index % 2 == 0
                                            ? AppColors.green
                                            : AppColors.red,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        index % 2 == 0
                                            ? ConstString.delivered
                                            : ConstString.failed,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: index % 2 == 0
                                                  ? AppColors.green
                                                  : AppColors.red,
                                            ),
                                      )
                                    ],
                                  )
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder(
                                  stream: controller.fetchAddressById(
                                      orderData[index].addressId ?? ""),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CupertinoActivityIndicator());
                                    } else if (snapshot.hasData) {
                                      UserAddress add = snapshot.data!;
                                      String address =
                                          "${add.address}, ${add.area}, ${add.landmark}";
                                      return Text(
                                        address,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: AppColors.txtGrey,
                                                fontSize: 12),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  formattedDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: AppColors.txtGrey,
                                          fontSize: 12),
                                ),
                              ],
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
                                          borderRadius:
                                              BorderRadius.circular(30))),
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
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      fixedSize: const Size(200, 45),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
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
                );
              },
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
      },
    );
  }
}
