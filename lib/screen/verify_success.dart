import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/screen/home_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class VerifySuccess extends StatelessWidget {
  const VerifySuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppIcons.verify),
              const SizedBox(
                height: 35,
              ),
              Text(
                ConstString.verified,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontSize: 22),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                ConstString.accountVerified,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 14),
              ),
              const SizedBox(
                height: 45,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => HomeScreen());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      fixedSize: const Size(200, 50),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: Text(
                    ConstString.btnContinue,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Colors.white,
                        ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
