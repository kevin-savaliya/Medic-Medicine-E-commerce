import 'dart:convert';

class ReviewData {
  String? id;
  String? medicineId;
  String? reviewerUserId;
  DateTime? reviewerCreatedAt;
  DateTime? reviewerUpdatedAt;

  ReviewData({
    this.id,
    this.medicineId,
    this.reviewerUserId,
    this.reviewerCreatedAt,
    this.reviewerUpdatedAt,
  });

  ReviewData copyWith({
    String? id,
    String? medicineId,
    String? reviewerUserId,
    DateTime? reviewerCreatedAt,
    DateTime? reviewerUpdatedAt,
  }) {
    return ReviewData(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      reviewerUserId: reviewerUserId ?? this.reviewerUserId,
      reviewerCreatedAt: reviewerCreatedAt ?? this.reviewerCreatedAt,
      reviewerUpdatedAt: reviewerUpdatedAt ?? this.reviewerUpdatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineId': medicineId,
      'reviewerUserId': reviewerUserId,
      'reviewerCreatedAt': reviewerCreatedAt?.toIso8601String(),
      'reviewerUpdatedAt': reviewerUpdatedAt?.toIso8601String(),
    };
  }

  factory ReviewData.fromMap(Map<String, dynamic> map) {
    return ReviewData(
      id: map['id'],
      medicineId: map['medicineId'],
      reviewerUserId: map['reviewerUserId'],
      reviewerCreatedAt: map['reviewerCreatedAt'] != null
          ? DateTime.parse(map['reviewerCreatedAt'])
          : null,
      reviewerUpdatedAt: map['reviewerUpdatedAt'] != null
          ? DateTime.parse(map['reviewerUpdatedAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewData.fromJson(String source) =>
      ReviewData.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewData && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
