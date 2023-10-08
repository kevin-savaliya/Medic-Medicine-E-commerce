import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/auth_controller.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';
import 'package:medic/widgets/custom_widget.dart';

class VerifyOtpScreen extends GetWidget<AuthController> {
  final String verificationId;
  final String phoneNumber;
  const VerifyOtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

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
          const SizedBox(height: 30),
          Text(
            ConstString.welcome,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontSize: 20),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            ConstString.enterOTP,
            style: Theme.of(context).textTheme.displaySmall!,
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: OtpTextField(
                autoFocus: false,
                handleControllers: (ctrl) {
                  controller.otp.value = '';
                  for (TextEditingController? element
                      in ctrl.where((element) => element != null).toList()) {
                    controller.otp.value =
                        controller.otp.value.trim() + element!.text.trim();
                  }
                  print('OTP input ${controller.otp.value}');
                },
                numberOfFields: 6,
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
                focusedBorderColor: AppColors.primaryColor,
                textStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontFamily: AppFont.fontRegular,
                    color: AppColors.darkPrimaryColor)),
          ),
          const SizedBox(height: 100),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () async {
                  if (controller.otp.value.isEmpty) {
                    showInSnackBar(
                      ConstString.enterOtp,
                      title: ConstString.enterOtpMessage,
                    );
                    return;
                  }
                  AuthController auth = Get.find<AuthController>();
                  FocusManager.instance.primaryFocus?.unfocus();
                  await controller.verifyOtp(auth.user);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    fixedSize: const Size(200, 50),
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
          const SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async {
                await controller.verifyPhoneNumber();
              },
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: ConstString.dontgetOTP,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: 14, color: AppColors.txtGrey)),
                TextSpan(
                    text: ConstString.resendOTP,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: AppColors.primaryColor, fontSize: 14))
              ])),
            ),
          ),
          GetBuilder<AuthController>(
              id: 'timer',
              builder: (ctrl) {
                return Visibility(
                  visible: ctrl.start.value != 0,
                  child: Center(
                    child: Obx(
                      () => TextWidget(
                          "00 : ${ctrl.start.value}${ctrl.start.value == 1 ? '' : ' Sec'}",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  color: AppColors.primaryColor, fontSize: 14)),
                    ),
                  ),
                );
              }),
        ]),
      )),
    );
  }
}
