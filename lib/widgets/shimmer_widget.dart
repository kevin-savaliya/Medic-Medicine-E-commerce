import 'package:flutter/material.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmer extends StatelessWidget {
  final int? itemCount;
  final double? height;

  CategoryShimmer({required this.itemCount, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: itemCount,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              child: Column(
                children: [
                  CircleAvatar(radius: 30),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Medic",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 15,
                        fontFamily: AppFont.fontSemiBold,
                        color: AppColors.darkPrimaryColor),
                  )
                ],
              ),
            );
          },
        ));
  }
}

class MedicineShimmer extends StatelessWidget {
  final int? itemCount;
  final double? height;

  MedicineShimmer({required this.itemCount, this.height});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: itemCount,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                height: 100,
                width: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300]),
              ),
            );
          },
        ));
  }
}
