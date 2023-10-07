import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? name;
  final String? gender;
  final String? email;
  final String? fcmToken;
  final int? countryCode;
  final String? mobileNo;
  final String? profilePicture;
  final bool? enablePushNotification;

  UserModel._({
    this.id,
    this.name,
    this.gender,
    this.email,
    this.mobileNo,
    this.fcmToken,
    this.countryCode,
    this.profilePicture,
    this.enablePushNotification,
  });

  UserModel.newUser({
    this.id,
    this.name,
    this.gender,
    this.email,
    this.mobileNo,
    this.fcmToken,
    this.countryCode,
    this.profilePicture,
    this.enablePushNotification,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? gender,
    String? email,
    int? countryCode,
    String? mobileNo,
    String? fcmToken,
    String? profilePicture,
    bool? enablePushNotification,
  }) {
    return UserModel._(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      mobileNo: mobileNo ?? this.mobileNo,
      fcmToken: fcmToken ?? this.fcmToken,
      countryCode: countryCode ?? this.countryCode,
      profilePicture: profilePicture ?? this.profilePicture,
      enablePushNotification:
          enablePushNotification ?? this.enablePushNotification,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'countryCode': countryCode,
      'email': email,
      'enablePushNotification': enablePushNotification,
      'fcmToken': fcmToken,
      'id': id,
      'mobileNo': mobileNo,
      'name': name,
      'profilePicture': profilePicture,
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel._(
      id: map['id'],
      name: map['name'],
      gender: map['gender'],
      email: map['email'],
      fcmToken: map['fcmToken'],
      countryCode: map['countryCode'],
      mobileNo: map['mobileNo'],
      profilePicture: map['profilePicture'],
      enablePushNotification: map['enablePushNotification'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    return UserModel._(
      id: map['id'],
      name: map['name'],
      gender: map['gender'],
      email: map['email'],
      fcmToken: map['fcmToken'],
      countryCode: map['countryCode'],
      mobileNo: map['mobileNo'],
      profilePicture: map['profilePicture'],
      enablePushNotification: map['enablePushNotification'],
    );
  }
}
