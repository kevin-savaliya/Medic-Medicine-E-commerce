import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class HomeController extends GetxController {
  RxInt pageIndex = 0.obs;

  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  User? get firebaseUser => FirebaseAuth.instance.currentUser;

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // current logged in user detail from users collection from firestore database
  // Rx<UserModel?> loggedInUser = UserModel.newUser().obs;
  Rx<UserModel?> loggedInUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _fetchUser();
  }

  // fetch current logged in user detail using currentUser.uid from users collection from firestore database
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
