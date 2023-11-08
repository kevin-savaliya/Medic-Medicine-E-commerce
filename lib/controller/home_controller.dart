import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';

class HomeController extends GetxController {
  RxInt pageIndex = 0.obs;

  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  User? get firebaseUser => FirebaseAuth.instance.currentUser;

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  TextEditingController nameController = TextEditingController();

  // current logged in user detail from users collection from firestore database
  // Rx<UserModel?> loggedInUser = UserModel.newUser().obs;
  Rx<UserModel?> loggedInUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _fetchUser();
    // checkUserNameExistOrNot();
  }

  Future<void> _fetchUser({
    void Function(UserModel? userModel)? onSuccess,
  }) async {
    try {
      streamUser(currentUserId!).listen((updatedUserData) {
        loggedInUser.value = updatedUserData;
        if (onSuccess != null) {
          onSuccess(updatedUserData);
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  checkUserNameExistOrNot() {
    if (firebaseUser != null) {
      _usersCollection
          .doc(currentUserId)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          UserModel userModel =
              UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
          if (userModel.name == null || userModel.name!.isEmpty) {
            showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  insetPadding: EdgeInsets.zero,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  children: [
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter Your Name",
                        style: Theme.of(Get.context!)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                                fontFamily: AppFont.fontSemiBold,
                                color: AppColors.primaryColor,
                                fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: true,
                        fillColor: AppColors.transparentDetails,
                        hintText: "Enter Your Name ",
                        hintStyle: Theme.of(Get.context!)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                                fontFamily: AppFont.fontMedium,
                                fontSize: 14,
                                color: AppColors.skipGrey),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 17,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              fixedSize: const Size(200, 50),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: Text(
                            ConstString.saveName,
                            style: Theme.of(Get.context!)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: Colors.white,
                                ),
                          )),
                    )
                    //   ],
                    // )
                  ],
                );
              },
            );
          }
        } else {
          showInSnackBar("User Not Exist");
        }
      });
    }
  }

  // void _saveUsername(String username) {
  //   if (user != null) {
  //     firestore.collection('users').doc(user.uid).update({
  //       'name': username,
  //     }).then((_) {
  //       // Handle successful update
  //       print('Username updated successfully');
  //     }).catchError((error) {
  //       // Handle update error
  //       print('Error updating username: $error');
  //     });
  //   }
  // }

  // fetch current logged in user detail using currentUser.uid from users collection from firestore database
  Future<void> fetchUser({
    void Function(UserModel userModel)? onSuccess,
  }) async {
    try {
      streamUser(currentUserId!).listen((updatedUserData) {
        loggedInUser.value = updatedUserData;
        if (onSuccess != null && updatedUserData != null) {
          onSuccess(updatedUserData);
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  // create a method to update user data when update on firestore in stream and convert it to UserModel
  Stream<UserModel?> streamUser(String id) {
    return _usersCollection.doc(id).snapshots().map((documentSnapshot) {
      if (documentSnapshot.data() == null) {
        return null;
      }
      return UserModel.fromMap(
          documentSnapshot.data()! as Map<String, dynamic>);
    });
  }

  pageUpdateOnHomeScreen(int index) {
    pageIndex.value = index;
    update();
  }

  List searchList = [
    "Acetaminophen",
    "Diphenhydramine",
    "Loratadine",
    "Omeprazole",
    "Amoxicillin",
    "Lisinopril",
    "Prednisone"
  ];
}
