import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/auth_controller.dart';
import 'package:medic/screen/home_screen.dart';
import 'package:medic/screen/phone_signup_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/custom_loading_widget.dart';

class PhoneLoginScreen extends GetWidget<AuthController> {
  const PhoneLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: SvgPicture.asset(AppImages.medic_teal_text)),
          actions: [
            GestureDetector(
              onTap: controller.isLoading
                  ? null
                  : () async {
                      await Get.offAll(() => const HomeScreen());
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Center(
                  child: Text(
                    ConstString.skip,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.primaryColor,
                        ),
                  ),
                ),
              ),
            )
          ],
          toolbarHeight: 70),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 30),
            Text(ConstString.welcome,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontSize: 20)),
            const SizedBox(height: 8),
            Text(ConstString.enterPhone,
                style: Theme.of(context).textTheme.displaySmall!),
            const SizedBox(height: 30),
            Text(ConstString.mobileNumber,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: AppColors.txtGrey2, fontSize: 14)),
            Row(
              children: [
                Expanded(
                    child: CountryCodePicker(
                  onChanged: (CountryCode? countryData) {
                    controller.countryData = countryData;
                  },
                  initialSelection: 'SL',
                  showFlag: false,
                  showFlagDialog: true,
                  dialogTextStyle: TextStyle(fontFamily: AppFont.fontRegular),
                  searchStyle: TextStyle(fontFamily: AppFont.fontRegular),
                  // showDropDownButton: true,
                  textStyle: TextStyle(fontFamily: AppFont.fontMedium),
                  alignLeft: true,
                  enabled: true,
                )),
                Expanded(
                    flex: 3,
                    child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: controller.phoneNumberController,
                        decoration: InputDecoration(
                            hintText: ConstString.enterMobile,
                            hintStyle: TextStyle(
                                fontFamily: AppFont.fontMedium,
                                color: AppColors.phoneGrey,
                                fontSize: 14),
                            border: InputBorder.none,
                            disabledBorder: const UnderlineInputBorder(),
                            enabledBorder: InputBorder.none,
                            focusedBorder: const UnderlineInputBorder(),
                            errorBorder: const UnderlineInputBorder(),
                            focusedErrorBorder: const UnderlineInputBorder())))
              ],
            ),
            const SizedBox(height: 100),
            continueButton(context),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: ElevatedButton(
                    onPressed: controller.isLoading
                        ? null
                        : () async {
                            await Get.to(() => const PhoneSignUpScreen());
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      fixedSize: const Size(200, 50),
                      elevation: 0,
                    ),
                    child: Text(
                      'Register now',
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                color: AppColors.primaryColor,
                              ),
                    )),
              ),
            ),
          ]),
        ),
      )),
    );
  }

  GetBuilder<AuthController> continueButton(BuildContext context) {
    return GetBuilder<AuthController>(
      id: AuthController.continueButtonId,
      builder: (ctrl) {
        if (controller.isOtpSent.value) {
          return Center(
            child: Container(
                height: 50,
                width: 50,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: const CustomLoadingWidget()),
          );
        }
        return Align(
          alignment: Alignment.center,
          child: ElevatedButton(
              onPressed: controller.isLoading
                  ? null
                  : () async {
                      if (controller.validateData(isLogin: true)) {
                        await controller.actionVerifyPhone(isLogin: true);
                      }
                    },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  fixedSize: const Size(200, 50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: Text(
                ConstString.sendOTP,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Colors.white,
                    ),
              )),
        );
      },
    );
  }
}
