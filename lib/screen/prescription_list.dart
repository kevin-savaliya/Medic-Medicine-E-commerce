import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:medic/controller/upload_pres_controller.dart';
import 'package:medic/model/prescription_model.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class PrescriptionList extends StatelessWidget {
  UploadPresController controller = Get.put(UploadPresController());

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
                child: LoadingIndicator(
              colors: [AppColors.primaryColor],
              indicatorType: Indicator.ballScale,
              strokeWidth: 1,
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
              child: ListView.builder(
                itemCount: prescriptions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.lineGrey)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${prescriptions[index].title}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: AppColors.darkPrimaryColor,
                                        fontFamily: AppFont.fontSemiBold,
                                        fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Status : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontSize: 13,
                                          fontFamily: AppFont.fontMedium),
                                ),
                                Text(
                                  prescriptions[index].isApproved!
                                      ? "Approved"
                                      : "Not Approved",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontSize: 13,
                                          fontFamily: AppFont.fontSemiBold,
                                          color:
                                              prescriptions[index].isApproved!
                                                  ? AppColors.green
                                                  : AppColors.red),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                itemCount: prescriptions[index].images?.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, ind) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SizedBox(
                                      // width: 150,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: prescriptions[index]
                                                  .images?[ind] ??
                                              '',
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
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
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
