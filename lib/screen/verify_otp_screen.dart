import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/screen/home_screen.dart';
import 'package:medic/screen/verify_success.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          child: SvgPicture.asset(
            AppImages.medic_teal_text,
          ),
        ),
        toolbarHeight: 70,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 30,
          ),
          Text(
            ConstString.welcome,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontSize: 20),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            ConstString.enterOTP,
            style: Theme.of(context).textTheme.displaySmall!,
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: OtpTextField(
              autoFocus: false,
              handleControllers: (ctrl) {},
              numberOfFields: 4,

              cursorColor: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(28),
              // showFieldAsBox: false,
              fieldWidth: 45,
              borderColor: AppColors.primaryColor,
              enabled: true,
              filled: true,
              onCodeChanged: (String code) {},
              fillColor: AppColors.transparentDetails.withOpacity(0.4),
              keyboardType: TextInputType.number,
              // disabledBorderColor: AppColors.splashdetail,
              focusedBorderColor: AppColors.primaryColor,
              // enabledBorderColor: AppColors.splashdetail,
              textStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontFamily: AppFont.fontRegular,
                  color: AppColors.darkPrimaryColor),
              // decoration: const InputDecoration(
              //     border: OutlineInputBorder(), fillColor: Colors.black26),
            ),
          ),
          SizedBox(height: 100),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () {
                  Get.offAll(() => const VerifySuccess());
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    fixedSize: Size(200, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  ConstString.verify,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Colors.white,
                      ),
                )),
          ),
          SizedBox(height: 15,),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {

              },
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: ConstString.dontgetOTP,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14,color: AppColors.txtGrey)),
                TextSpan(
                    text: ConstString.resendOTP,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppColors.primaryColor,fontSize: 14))
              ])),
            ),
          ),
        ]),
      )),
    );
  }
}
