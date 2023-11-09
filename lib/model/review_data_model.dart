import 'package:medic/utils/firebase_utils.dart';

class ReviewDataModel {
  String? id;
  String? medicineId;
  String? userId;
  String? orderId;
  double? rating;
  String? review;
  DateTime? createdTime;

  ReviewDataModel({
    this.id,
    this.medicineId,
    this.userId,
    this.orderId,
    this.rating,
    this.review,
    this.createdTime,
  });

  ReviewDataModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    medicineId = map['medicineId'];
    userId = map['userId'];
    orderId = map['orderId'];
    rating = map['rating'];
    review = map['review'];
    createdTime = map['createdTime'] != null
        ? FirebaseUtils.timestampToDateTime(map['createdTime'])
        : null;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['medicineId'] = this.medicineId;
    data['userId'] = this.userId;
    data['orderId'] = this.orderId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['createdTime'] = this.createdTime;
    return data;
  }

  ReviewDataModel copyWith({
    String? id,
    String? medicineId,
    String? userId,
    String? orderId,
    double? rating,
    String? review,
    DateTime? createdTime,
  }) {
    return ReviewDataModel(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      createdTime: createdTime ?? this.createdTime,
    );
  }
}
