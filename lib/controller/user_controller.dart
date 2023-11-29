import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medic/model/user_model.dart';

class UserController extends GetxController {
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  User? get firebaseUser => FirebaseAuth.instance.currentUser;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // final String uId = FirebaseAuth.instance.currentUser!.uid;
  Stream<QuerySnapshot>? dataSnapShot;

  Rx<UserModel> get user => _user;
  final Rx<UserModel> _user = UserModel.newUser().obs;

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // current logged in user detail from users collection from firestore database
  Rx<UserModel?> loggedInUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _fetchUser();

    // String uId = this.uId;
    // dataSnapShot = FirebaseFirestore.instance
    //     .collection('users')
    //     .where('id', isEqualTo: uId)
    //     .snapshots();

    // dataSnapShot!.listen((event) {
    //   if (event.docs.isNotEmpty) {
    //     _user.value = UserModel.fromDocumentSnapshot(event.docs.first);
    //     nameController.text = _user.value.name ?? '';
    //     emailController.text = _user.value.email ?? '';
    //     update();
    //   } else {
    //     log("No user data found");
    //   }
    // });
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

  Future<UserModel?> getLoggedInUserData() async {
    if (FirebaseAuth.instance.currentUser?.uid == null) return null;
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (userId.isEmpty) return null;

    final DocumentSnapshot<Object?> userData =
        await _usersCollection.doc(userId).get();
    if (userData.exists) {
      return UserModel.fromMap(userData.data() as Map<String, dynamic>);
    }
    return null;
  }

  Stream<UserModel?> streamUser(String id) {
    return _usersCollection.doc(id).snapshots().map((documentSnapshot) {
      if (documentSnapshot.data() == null) {
        return null;
      }
      return UserModel.fromMap(
          documentSnapshot.data()! as Map<String, dynamic>);
    });
  }
}
