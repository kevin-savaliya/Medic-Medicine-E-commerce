import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medic/controller/upload_pres_controller.dart';
import 'package:medic/model/prescription_model.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class PrescriptionList extends StatelessWidget {
  final UploadPresController controller = Get.put(UploadPresController());

  PrescriptionList({super.key});

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
        title: Text(ConstString.prescriptions,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
      ),
      body: StreamBuilder(
        stream: controller.fetchPrescriptions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CupertinoActivityIndicator(
              color: AppColors.primaryColor,
              radius: 15,
            ));
          } else if (snapshot.hasError) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.tilePrimaryColor),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Error : ${snapshot.error}",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 15,
                      fontFamily: AppFont.fontMedium),
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<PrescriptionData> prescriptions = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Container(
                    height: 170,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.decsGrey),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                ConstString.quickOrder,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                        fontFamily: AppFont.fontBold,
                                        fontSize: 16,
                                        height: 1.4),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                ConstString.uploadphoto,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(height: 1.4, fontSize: 11),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      fixedSize: const Size(150, 18),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  child: Text(
                                    ConstString.uploadPres,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: AppColors.white,
                                            fontFamily: AppFont.fontMedium),
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              SvgPicture.asset(
                                AppImages.presIcon,
                                height: 80,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                ConstString.howwork,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: AppColors.primaryColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      ConstString.presUploadedByYou,
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                color: AppColors.darkPrimaryColor,
                                fontFamily: AppFont.fontSemiBold,
                                fontSize: 15.5,
                              ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: prescriptions.length,
                      itemBuilder: (context, index) {
                        String formattedDate = DateFormat('d MMM yyyy')
                            .format(prescriptions[index].uploadTime!);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            prescriptions[index].images?[0] ??
                                                '',
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                SizedBox(
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
                                  Positioned(
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: AppColors.darkPrimaryColor
                                                  .withOpacity(0.7),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(10),
                                                      bottomLeft:
                                                          Radius.circular(10))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  ConstString.remove,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          color:
                                                              AppColors.white),
                                                ),
                                                SvgPicture.asset(
                                                  AppIcons.closeRed,
                                                  height: 16,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        ConstString.prescriptions,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: AppColors.txtGrey
                                                    .withOpacity(0.7)),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 110,
                                        child: Text(
                                          "${prescriptions[index].title}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  color: AppColors.dark,
                                                  fontFamily:
                                                      AppFont.fontMedium),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        ConstString.presBy,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: AppColors.txtGrey
                                                    .withOpacity(0.7)),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Medic",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: AppColors.dark,
                                                fontFamily: AppFont.fontMedium),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        ConstString.presStatus,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: AppColors.txtGrey
                                                    .withOpacity(0.7)),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        prescriptions[index].isApproved!
                                            ? "Approved"
                                            : "Not Approved",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontSize: 12,
                                                fontFamily:
                                                    AppFont.fontSemiBold,
                                                color: prescriptions[index]
                                                        .isApproved!
                                                    ? AppColors.green
                                                    : AppColors.red),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    formattedDate,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: AppColors.txtGrey
                                                .withOpacity(0.7),
                                            fontFamily: AppFont.fontMedium),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
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
                    ConstString.noPres,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontFamily: AppFont.fontMedium),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
