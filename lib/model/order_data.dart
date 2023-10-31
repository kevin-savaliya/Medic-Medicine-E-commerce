import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medic/model/category_data.dart';
import 'package:medic/model/discount_data_model.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/model/prescription_model.dart';
import 'package:medic/model/review_data.dart';
import 'package:medic/model/user_address.dart';
import 'package:medic/model/user_model.dart';

class OrderData {
  String? id;
  String creatorId;
  String addressId;
  String reviewId;
  String? prescriptionId;
  String medicineId;
  String? discountId;
  String categoryId;
  UserModel? userModel;
  UserAddress? userAddress;
  ReviewData? reviewData;
  PrescriptionData? prescriptionData;
  MedicineData? medicineData;
  DiscountDataModel? discountData;
  CategoryData? categoryData;

  OrderData({
    this.id,
    required this.creatorId,
    required this.addressId,
    required this.reviewId,
    this.prescriptionId,
    required this.medicineId,
    this.discountId,
    required this.categoryId,
    this.userModel,
    this.userAddress,
    this.reviewData,
    this.prescriptionData,
    this.medicineData,
    this.discountData,
    this.categoryData,
  });

  OrderData copyWith({
    String? id,
    String? creatorId,
    String? addressId,
    String? reviewId,
    String? prescriptionId,
    String? medicineId,
    String? discountId,
    String? categoryId,
    UserModel? userModel,
    UserAddress? userAddress,
    ReviewData? reviewData,
    PrescriptionData? prescriptionData,
    MedicineData? medicineData,
    DiscountDataModel? discountData,
    CategoryData? categoryData,
  }) {
    return OrderData(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      addressId: addressId ?? this.addressId,
      reviewId: reviewId ?? this.reviewId,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      medicineId: medicineId ?? this.medicineId,
      discountId: discountId ?? this.discountId,
      categoryId: categoryId ?? this.categoryId,
      userModel: userModel ?? this.userModel,
      userAddress: userAddress ?? this.userAddress,
      reviewData: reviewData ?? this.reviewData,
      prescriptionData: prescriptionData ?? this.prescriptionData,
      medicineData: medicineData ?? this.medicineData,
      discountData: discountData ?? this.discountData,
      categoryData: categoryData ?? this.categoryData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creatorId': creatorId,
      'addressId': addressId,
      'reviewId': reviewId,
      'prescriptionId': prescriptionId,
      'medicineId': medicineId,
      'discountId': discountId,
      'categoryId': categoryId,
    };
  }

  factory OrderData.fromMap(Map<String, dynamic> map) {
    return OrderData(
      id: map['id'],
      creatorId: map['creatorId'],
      addressId: map['addressId'],
      reviewId: map['reviewId'],
      prescriptionId: map['prescriptionId'],
      medicineId: map['medicineId'],
      discountId: map['discountId'],
      categoryId: map['categoryId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderData.fromJson(String source) =>
      OrderData.fromMap(json.decode(source));

  factory OrderData.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    return OrderData.fromMap(map);
  }
}
