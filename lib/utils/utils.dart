import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_storage.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:path/path.dart';

class AppIcon {
  static Widget get backIcon => Icon(
        Platform.isAndroid
            ? Icons.arrow_back_outlined
            : Icons.arrow_back_ios_outlined,
        color: AppColors.dark,
        size: 25,
      );

  static Widget get downIcon => Transform.rotate(
        angle: 180 * math.pi / 360,
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.dark,
          size: 25,
        ),
      );

  static AssetImage calendar = const AssetImage('assets/calendar.png');
}

class Utils {
  static String? appCurrentLanguage;
  static bool isDialogShowing = true;

  static final _dateFormat = DateFormat.yMMMMd('en_US');

  static DateTime fromDateTimeToUTCDateTime(
      String dateFormat, String timeFormat) {
    String a = "$dateFormat $timeFormat";
    DateTime? date = DateTime.parse(a);
    return date.toUtc();
  }

  List<Map<String, dynamic>> userPreferencesList = [
    {"size": "small", "likes": false},
    {"size": "medium", "likes": false},
    {"size": "large", "likes": false},
    {"size": "giant", "likes": false},
    {"size": "teacup", "likes": false},
    {"size": "toy", "likes": false}
  ];

  Map<String, bool> genderCheckboxList = {
    "Male": true,
    "Female": false,
    "Prefer Not To Say": false,
  };

  static double? getLong(dynamic val) {
    if (val is double) {
      return val;
    } else if (val is int) {
      return (val).toDouble();
    } else {
      return null;
    }
  }

  static String fromDateTimeToUTCString(String dateFormat, String timeFormat) {
    return fromDateTimeToUTCDateTime(dateFormat, timeFormat).toIso8601String();
  }

  static Future<XFile?> compressImage(File file,
      {int quality = 80, int minWidth = 1000, int minHeight = 1000}) async {
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    /* Max image compression quality value accept up to 95 */
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath,
        minWidth: minWidth, minHeight: minHeight, quality: quality);

    return compressedImage;
  }

  static Future<bool> hasInternetConnection() async {
    bool isOffline;
    try {
      ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a mobile network.
        return true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (_) {
      isOffline = false;
      return isOffline;
    } on TimeoutException catch (_) {
      isOffline = false;
      return isOffline;
    } on SocketException catch (_) {
      isOffline = false;
      return isOffline;
    }
  }

  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return _dateFormat.format(date);
  }

  Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    String? content,
    void Function()? onPressed,
  }) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Text(
          (content != null) ? content : "",
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Get.back();
            },
            child: Text(
              'No',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: AppColors.alertBoxTextColot),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: onPressed,
            child: Text(
              'Yes',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: AppColors.alertBoxTextColot),
            ),
          ),
        ],
      ),
    );
  }

  static Widget getUserProfileWidget({UserModel? userModel}) {
    UserModel? userData;
    if (userModel != null) {
      userData = userModel;
    } else {
      userData = AppStorage().getUserData();
    }

    Widget widget;
    if (userData != null &&
        (userData.profilePicture.toString() != 'null' ||
            userData.profilePicture.toString().isNotEmpty)) {
      widget = Image.network(
        userData.profilePicture!,
        fit: BoxFit.fill,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: 35,
            width: 35,
            child: Center(
                child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            )),
          );
        },
        errorBuilder: (_, __, ___) {
          return Icon(
            Icons.person_outline,
            color: AppColors.primaryColor,
            size: 35,
          );
        },
        height: 35,
        width: 35,
      );
    } else {
      widget = Icon(
        Icons.person_outline,
        color: AppColors.primaryColor,
        size: 35,
      );
    }

    return widget;
  }

  static Widget noDataFound(
      {required String msg, required BuildContext context}) {
    double size = MediaQuery.of(context).size.height / 5;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage(AppImages.errorImage),
            color: AppColors.red,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            msg,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static void showInternetConnectionDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text('OK'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        // dismisses only the dialog and returns nothing
        isDialogShowing = false;
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('internetConnection'.tr),
      content: Text('noInternetConnection'.tr),
      actions: [
        okButton,
      ],
    );
    isDialogShowing = true;
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).onError((error, stackTrace) {
      isDialogShowing = false;
    }).whenComplete(() {
      isDialogShowing = false;
    });
  }

  static getRandomString([int len = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
    final random = math.Random.secure();
    return List.generate(len, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  static Future<String?> uploadPic(File? image, PicDir bucket) async {
    String? imageURL;
    late Reference firebaseStorageRef;
    try {
      if (image != null) {
        try {
          String fileName = basename(image.path);
          firebaseStorageRef =
              FirebaseStorage.instance.ref().child('${bucket.name}/$fileName');
          UploadTask uploadTask = firebaseStorageRef.putFile(image);
          TaskSnapshot taskSnapshot = await uploadTask;
          imageURL = await taskSnapshot.ref.getDownloadURL();
          //Logger.write(imageURL);
        } catch (e) {
          log(e.toString());
        }
      }
      return imageURL;
    } on SocketException {
      return ConstString.ERROR_WHILE_UPLODING_PICTURE;
    } on PlatformException {
      return ConstString.ERROR_WHILE_UPLODING_PICTURE;
    } on Exception {
      return ConstString.ERROR_WHILE_UPLODING_PICTURE;
    }
  }

  static Future<bool> removePic(String imageURL) async {
    bool isRemoved = false;
    try {
      Reference firebaseStorageRef =
          FirebaseStorage.instance.refFromURL(imageURL);
      await firebaseStorageRef.delete();
      isRemoved = true;
    } on SocketException {
      log("removePic function SocketException", name: "Utils");
    } on PlatformException {
      log("removePic function PlatformException", name: "Utils");
    } catch (e) {
      log("removePic function exception $e ", name: "Utils");
    }
    return isRemoved;
  }

  static String parseTimeStamp({required int value, required bool isTime}) {
    if (isTime) {
      DateTime calender = DateTime.fromMillisecondsSinceEpoch(value * 1000);
      String date = DateFormat('hh:mm a').format(calender);
      log("Date => $calender");
      return date;
    } else {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(value * 1000);
      String d12 = DateFormat('dd/MM/yyyy').format(time);
      log("Milli second to hours and min => $d12");
      return d12;
    }
  }

  static String getNewImage(String s, String errorUrl, {int size = 200}) {
    final Uri url = Uri.parse(s);
    final List<String> pathSagment = url.pathSegments.toList();

    if (pathSagment.isNotEmpty) {
      final String fileName = pathSagment[pathSagment.length - 1];

      // split file name
      final List<String> fileNameList = fileName.split('.');

      if (fileNameList.length >= 2) {
        // chnage file name
        fileNameList[fileNameList.length - 2] =
            '${fileNameList[fileNameList.length - 2]}_${size}x$size';

        // join file name
        final String newName = fileNameList.join('.');
        // set new file name
        pathSagment[pathSagment.length - 1] = newName;
        // replace new path segments
        return url.replace(pathSegments: pathSagment).toString();
      }
    }
    return errorUrl;
  }

  static String convertStringToDate(
      {required String data,
      bool isTime = false,
      bool getInLocalTime = false}) {
    String? date;
    DateTime dateTime = DateTime.parse(data);
    dateTime = dateTime.toLocal();
    if (isTime) {
      date = DateFormat("jm").format(dateTime);
    } else {
      date = DateFormat("dd/MM/yyyy").format(dateTime);
    }

    log('date =>$date');
    return date;
  }

  static String timeAgo({required DateTime d}) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()}${(diff.inDays / 365).floor() == 1 ? " year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()}${(diff.inDays / 30).floor() == 1 ? " month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()}${(diff.inDays / 7).floor() == 1 ? " week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays}${diff.inDays == 1 ? " day" : " days"} ago";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours}${diff.inHours == 1 ? " h" : " h"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes}${diff.inMinutes == 1 ? " min" : " min"} ago";
    }
    return "just now";
  }

  String expireTime({required DateTime expTime}) {
    Duration diff = expTime.difference(DateTime.now().toUtc().toLocal());
    if (diff.inDays > 7) {
      return "Expires in ${(diff.inDays / 7).floor()}${(diff.inDays / 7).floor() == 1 ? " week" : "weeks"} ";
    }
    if (diff.inDays > 0) {
      return "Expires in ${diff.inDays}${diff.inDays == 1 ? " day" : " days"} ";
    }
    if (diff.inHours > 0) {
      return "Expires in ${diff.inHours}${diff.inHours == 1 ? "h" : "h"} ";
    }
    return "";
  }

  static String timewithAgo({required DateTime d}) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()}${(diff.inDays / 365).floor() == 1 ? " year" : "years"}";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()}${(diff.inDays / 30).floor() == 1 ? " month" : "months"}";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()}${(diff.inDays / 7).floor() == 1 ? " week" : "weeks"}";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays}${diff.inDays == 1 ? " day" : " days"}";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours}${diff.inHours == 1 ? " h" : " h"}";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes}${diff.inMinutes == 1 ? " min" : " min"}";
    }
    return "just now";
  }

  Future<ImageSource?> selectImageSource({
    required BuildContext context,
    required String title,
    String? content,
    void Function()? onPressed,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Text(
          (content != null) ? content : "",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text(
              ConstString.camera,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text(
              ConstString.gallery,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ],
      ),
    );
  }
}

void unFocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}

Map<String, dynamic> reactionMap = {
  'Wise': 1,
  'Love': 2,
  'Like': 3,
  'Funny': 4,
  'Wow': 5,
};

final Map<NotificationType, String> notificationtype = {
  NotificationType.reaction: 'reaction',
  NotificationType.suggestion: 'suggestion',
  NotificationType.adminReply: 'admin_reply',
  NotificationType.topicPublished: 'topic_published',
  NotificationType.following: 'following',
};

enum PicDir { petPictures, profilePictures, chatPictures, eventPicture }

enum NotificationType {
  reaction,
  suggestion,
  following,
  topicPublished,
  adminReply,
}

enum UserGender {
  male,
  female,
  other,
}

void showInSnackBar(String? message,
    {String? title,
    SnackPosition? position,
    bool isSuccess = false,
    Duration? duration,
    Color? color}) {
  Get.snackbar(
      title ?? 'Medic',
      (message ?? '').length > 300
          ? ConstString.somethingWentWrong
          : (message ?? ''),
      snackPosition: position ?? SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: isSuccess
          ? Colors.green.withOpacity(0.6)
          : color ?? Colors.red.withOpacity(0.6),
      colorText: AppColors.textColor,
      margin: const EdgeInsets.all(10),
      duration: duration ?? const Duration(seconds: 3));
}

void toast(
    {required String message,
    ToastGravity? gravity,
    bool isSuccess = false,
    Color? color}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.black.withOpacity(0.8),
      textColor: AppColors.white);
}
