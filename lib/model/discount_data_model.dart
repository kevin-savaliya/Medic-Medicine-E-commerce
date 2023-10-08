import 'dart:convert';

class DiscountDataModel {
  String? id;
  String? type;
  double? percentage;
  double? amount;
  String? discountName;

  DiscountDataModel({
    this.id,
    this.type,
    this.percentage,
    this.amount,
    this.discountName,
  });

  DiscountDataModel copyWith({
    String? id,
    String? type,
    double? percentage,
    double? amount,
    String? discountName,
  }) {
    return DiscountDataModel(
      id: id ?? this.id,
      type: type ?? this.type,
      percentage: percentage ?? this.percentage,
      amount: amount ?? this.amount,
      discountName: discountName ?? this.discountName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'percentage': percentage,
      'amount': amount,
      'discountName': discountName,
    };
  }

  factory DiscountDataModel.fromMap(Map<String, dynamic> map) {
    return DiscountDataModel(
      id: map['id'],
      type: map['type'],
      percentage: map['percentage']?.toDouble(),
      amount: map['amount']?.toDouble(),
      discountName: map['discountName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DiscountDataModel.fromJson(String source) =>
      DiscountDataModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscountDataModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
