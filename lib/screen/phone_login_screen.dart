import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/screen/verify_otp_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});

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
            ConstString.enterPhone,
            style: Theme.of(context).textTheme.displaySmall!,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            ConstString.mobileNumber,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: AppColors.txtGrey2, fontSize: 14),
          ),
          Row(
            children: [
              Expanded(
                child: CountryCodePicker(
                  onChanged: print,
                  showFlag: false,
                  showFlagDialog: true,
                  dialogTextStyle: TextStyle(fontFamily: AppFont.fontRegular),
                  searchStyle: TextStyle(fontFamily: AppFont.fontRegular),
                  // showDropDownButton: true,
                  textStyle: TextStyle(fontFamily: AppFont.fontMedium),
                  alignLeft: true,
                  enabled: true,
                ),
              ),
              Expanded(
                flex: 3,
                child: TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: ConstString.enterMobile,
                      hintStyle: TextStyle(
                          fontFamily: AppFont.fontMedium,
                          color: AppColors.phoneGrey,
                          fontSize: 14),
                      border: InputBorder.none,
                      disabledBorder: UnderlineInputBorder(),
                      enabledBorder: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(),
                      errorBorder: UnderlineInputBorder(),
                      focusedErrorBorder: UnderlineInputBorder()),
                ),
              )
            ],
          ),
          SizedBox(height: 100),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () {
                  Get.to(() => VerifyOtpScreen());
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    fixedSize: Size(200, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  ConstString.sendOTP,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Colors.white,
                      ),
                )),
          ),
        ]),
      )),
    );
  }
}
