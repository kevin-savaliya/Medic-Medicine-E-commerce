import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medic/controller/user_controller.dart';
import 'package:medic/controller/user_repository.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/screen/home_screen.dart';
import 'package:medic/screen/phone_login_screen.dart';
import 'package:medic/screen/verify_otp_screen.dart';
import 'package:medic/screen/verify_success.dart';
import 'package:medic/services/notification/notification_service.dart';
import 'package:medic/utils/app_storage.dart';
import 'package:medic/utils/controller_ids.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';
import 'package:medic/widgets/app_dialogue.dart';

class AuthController extends GetxController {
  RxString verificationId = "".obs;
  RxString otp = ''.obs;

  RxString verificationid = "".obs;
  bool isLoading = false;

  RxBool isNewUser = false.obs;
  RxBool isOtpSent = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String countryName = '';
  UserModel? userModel;
  User? user;
  Timer? timer;
  RxInt start = 30.obs;
  RxBool resendButton = true.obs;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  Rx<UserGender> selectedGender = UserGender.male.obs;
  FocusNode phoneNumberTextField = FocusNode();
  AppStorage appStorage = AppStorage();

  static const continueButtonId = 'continueButtonId';

  var isLoggedIn = false.obs;

  CountryCode? countryData;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    countryData = CountryCode.fromCountryCode('SL');
  }

  @override
  void dispose() {
    phoneNumberTextField.dispose();
    update([continueButtonId]);
    super.dispose();
  }

  Future<void> navigateToNextScreen(UserCredential credentials) async {
    UserModel? gotUser = Get.find<UserController>().loggedInUser.value;
    isLoading = false;
    update([ControllerIds.verifyButtonKey]);
    if (gotUser != null) {
      await appStorage.setUserData(gotUser);
      await NotificationService.instance.getTokenAndUpdateCurrentUser();
      await Get.offAll(() => const HomeScreen());
    }
  }

  Future<void> checkAfterSocialSignin() async {
    User user = FirebaseAuth.instance.currentUser!;
    final String? userPhone = user.phoneNumber;

    if (userPhone != null && userPhone.isNotEmpty) {
      UserModel? currentUser = Get.find<UserController>().loggedInUser.value;
      if (currentUser != null) {
        await appStorage.setUserData(currentUser);
        await NotificationService.instance.getTokenAndUpdateCurrentUser();
        await Get.offAll(() => const HomeScreen());
      }
    } else {
      update([continueButtonId]);
    }
    log(userPhone.toString());
    isLoading = false;
    update([continueButtonId]);
  }

  RxInt startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
          resendButton = false.obs;
        } else {
          start.value != 0 ? start-- : null;
          update(['timer']);
        }
      },
    );
    return start;
  }

  Future<void> verifyPhoneNumber(
      {bool second = false, bool isLogin = false}) async {
    bool isValid = validateData(isLogin: isLogin);
    if (isValid) {
      isOtpSent = true.obs;
      update([continueButtonId]);
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: '+${getPhoneNumber()}',
          verificationCompleted: (PhoneAuthCredential credential) async {
            isOtpSent = false.obs;
            update([continueButtonId]);
            _auth.signInWithCredential(credential).then((value) {

              showInSnackBar(ConstString.successLogin, isSuccess: true);
              return;
            });
          },
          verificationFailed: (FirebaseAuthException exception) {
            isOtpSent = false.obs;
            update([continueButtonId]);

            log("Verification error${exception.message}");
            isLoading = false;
            update([ControllerIds.verifyButtonKey]);
            authException(exception);
          },
          codeSent:
              (String currentVerificationId, int? forceResendingToken) async {
            verificationId.value = currentVerificationId;
            isOtpSent = false.obs;
            update([continueButtonId]);
            log("$verificationId otp is sent ");

            showInSnackBar(ConstString.otpSent, isSuccess: true);

            start.value = 30;
            if (timer?.isActive != true) {
              startTimer();
            }

            if (!second) {
              Get.off(() => VerifyOtpScreen(phoneNumber: getPhoneNumber()));
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            isOtpSent = false.obs;
            update([continueButtonId]);

            verificationid = verificationId.obs;
          },
        );
      } catch (e) {
        log("------verify number with otp sent-----$e");
      }
    }
  }

  Future<void> signOut() async {
    await NotificationService.instance.reGenerateFCMToken();
    phoneNumberController.clear();
    AppStorage appStorage = AppStorage();
    appStorage.appLogout();
    isLoading = false;
    Get.delete<AuthController>();
    Get.put(AuthController(), permanent: true);
    Get.back();
    await Get.offAll(() => const PhoneLoginScreen());
    await FirebaseAuth.instance.signOut();
  }

  bool validateData({bool isLogin = false}) {
    if (isLogin) {
      if (phoneNumberController.text.trim().isEmpty) {
        showInSnackBar("Please enter phone number.",
            title: 'Required!', isSuccess: false);
        return false;
      } else {
        return true;
      }
    }
    if (firstNameController.text.trim().isEmpty) {
      showInSnackBar("Please enter first name.",
          title: 'Required!', isSuccess: false);
      return false;
    } else if (lastNameController.text.trim().isEmpty) {
      showInSnackBar("Please enter last name.",
          title: 'Required!', isSuccess: false);
      return false;
    } else if (phoneNumberController.text.trim().isEmpty) {
      showInSnackBar("Please enter phone number.",
          title: 'Required!', isSuccess: false);
      return false;
    }
    return true;
  }

  String getPhoneNumber() {
    if (countryData?.dialCode == null) {
      return '';
    }
    String mPhoneNumber = phoneNumberController.text.trim();
    return (countryData!.dialCode! + mPhoneNumber).replaceAll('+', '');
  }

  void authException(FirebaseAuthException e) {
    switch (e.code) {
      case ConstString.invalidVerificationCode:
        return showInSnackBar(ConstString.invalidVerificationMessage);
      case ConstString.invalidPhoneNumber:
        return showInSnackBar(
          ConstString.invalidPhoneFormat,
          title: ConstString.invalidPhoneMessage,
        );
      case ConstString.networkRequestFailed:
        return showInSnackBar(ConstString.checkNetworkConnection);
      case ConstString.userDisabled:
        return showInSnackBar(ConstString.accountDisabled);
      case ConstString.sessionExpired:
        return showInSnackBar(ConstString.sessionExpiredMessage);
      case ConstString.quotaExceed:
        return showInSnackBar(ConstString.quotaExceedMessage);
      case ConstString.tooManyRequest:
        return showInSnackBar(ConstString.tooManyRequestMessage);
      case ConstString.captchaCheckFailed:
        return showInSnackBar(ConstString.captchaFailedMessage);
      case ConstString.missingPhoneNumber:
        return showInSnackBar(ConstString.missingPhoneNumberMessage);
      default:
        return showInSnackBar(e.message);
    }
  }

  Future<void> actionVerifyPhone({required bool isLogin}) async {
    update([AuthController.continueButtonId]);
    FocusManager.instance.primaryFocus?.unfocus();

    await verifyPhoneNumber(isLogin: isLogin);

    update([AuthController.continueButtonId]);
  }

  Future<void> verifyOtp(BuildContext context, User? user) async {
    if (otp.value.isEmpty) {
      showInSnackBar(
        ConstString.enterOtp,
        title: ConstString.enterOtpMessage,
      );
      return;
    }
    isLoading = true;
    update([ControllerIds.verifyButtonKey]);
    try {
      showProgressDialogue(context);
      final UserCredential result;
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId.value, smsCode: otp.value);

      if (user != null) {
        if (user.phoneNumber == null) {
          result = await user.linkWithCredential(phoneAuthCredential);
          log('data to check 1 ${getPhoneNumber()}');
          // var gotUser = await _createUserInUserCollection(result,
          //     displayName: getUserName());
        } else {
          result = await _auth.signInWithCredential(phoneAuthCredential);
          log(ConstString.successLogin);
        }
        isLoading = false;
        update([ControllerIds.verifyButtonKey]);
      } else {
        result = await _auth.signInWithCredential(phoneAuthCredential);
        isLoading = false;
        update([ControllerIds.verifyButtonKey]);
      }
      isLoading = true;
      update([ControllerIds.verifyButtonKey]);
      if (result.additionalUserInfo?.isNewUser ?? false) {
        log('data to check 2 ${getPhoneNumber()}');
        var gotUser = await _createUserInUserCollection(result,
            displayName: getUserName());
        await appStorage.setUserData(gotUser);
        await NotificationService.instance.getTokenAndUpdateCurrentUser();
        await Get.offAll(() => const VerifySuccess());
        isLoading = false;
        update([ControllerIds.verifyButtonKey]);
      } else {
        var gotUser = await _createUserInUserCollection(result,
            displayName: getUserName());
        isLoading = false;
        update([ControllerIds.verifyButtonKey]);

        await appStorage.setUserData(gotUser);
        await NotificationService.instance.getTokenAndUpdateCurrentUser();
        await Get.offAll(() => const VerifySuccess());
      }
      isLoading = false;
      update([ControllerIds.verifyButtonKey]);
    } on FirebaseAuthException catch (e) {
      Get.back();
      authException(e);
      isLoading = false;
      update([ControllerIds.verifyButtonKey]);
    } catch (e) {
      Get.back();
      isLoading = false;
      update([ControllerIds.verifyButtonKey]);
    }
  }

  Future<UserModel> _createUserInUserCollection(
    UserCredential credentials, {
    String? displayName,
  }) async {
    late UserModel userModel;
    bool isUserExist =
        await UserRepository.instance.isUserExist(credentials.user!.uid);
    if (!isUserExist) {
      List<String> name = getFirstLastName(credentials);
      String? fcmToken = await _firebaseMessaging.getToken();
      userModel = UserModel.newUser(
        id: credentials.user?.uid,
        name: (displayName ?? ('${name.first} ${name[1]}')),
        profilePicture: credentials.user?.photoURL,
        fcmToken: fcmToken,
        countryCode: int.parse(countryData!.dialCode!.replaceAll('+', '')),
        mobileNo: phoneNumberController.text.trim().replaceAll('+', ''),
        enablePushNotification: true,
        gender: selectedGender.value.name,
      );
      await UserRepository.instance.createNewUser(userModel);
    } else {
      userModel =
          await UserRepository.instance.fetchUser(credentials.user!.uid);
    }
    return userModel;
  }

  List<String> getFirstLastName(UserCredential credentials) {
    return [firstNameController.text.trim(), lastNameController.text.trim()];
  }

  List<String> getFirstLastName1(UserCredential credentials) {
    if (credentials.user?.displayName == null) {
      return getNameFromEmail(credentials.user?.email ?? '');
    } else {
      try {
        List<String> splitedString = credentials.user!.displayName!.split(' ');
        if (splitedString.isNotEmpty) {
          return [splitedString[0], splitedString[1]];
        } else {
          return getNameFromEmail(credentials.user?.email ?? '');
        }
      } catch (e) {
        return getNameFromEmail(credentials.user?.email ?? '');
      }
    }
  }

  List<String> getNameFromEmail(String email) {
    List<String> parts = email.split('@');

    if (parts.length != 2) {
      return ['-', ''];
    }

    String username = parts[0];

    List<String> nameParts = username.split('.');

    if (nameParts.isEmpty) {
      return [
        capitalizeFirstLetter(username),
        generateRandomNumbers(),
      ];
    }

    String firstName = capitalizeFirstLetter(nameParts[0]);
    String lastName =
        nameParts.length > 1 ? capitalizeFirstLetter(nameParts.last) : '';

    return [firstName, lastName];
  }

  String capitalizeFirstLetter(String word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1);
  }

  String generateRandomNumbers() {
    math.Random random = math.Random();
    return '${random.nextInt(9)}${random.nextInt(9)}${random.nextInt(9)}';
  }

  String getUserName() {
    List<String> names = [];
    // return first and last name with joined string with single space  - firstNameController lastNameController
    names.add(firstNameController.text.trim());
    names.add(lastNameController.text.trim());
    return names.join(" ");
  }

  Future deleteAccount() async {
    try {
      await signOut();
      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      log(e.toString());
    }
  }
}
