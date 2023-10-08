import 'dart:convert';

class FavouriteDataModel {
  String? medicineId;
  DateTime? createdAt;

  FavouriteDataModel({
    this.medicineId,
    this.createdAt,
  });

  FavouriteDataModel copyWith({
    String? medicineId,
    DateTime? createdAt,
  }) {
    return FavouriteDataModel(
      medicineId: medicineId ?? this.medicineId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'medicineId': medicineId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory FavouriteDataModel.fromMap(Map<String, dynamic> map) {
    return FavouriteDataModel(
      medicineId: map['medicineId'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FavouriteDataModel.fromJson(String source) =>
      FavouriteDataModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteDataModel &&
          runtimeType == other.runtimeType &&
          medicineId == other.medicineId;

  @override
  int get hashCode => medicineId.hashCode;
}
