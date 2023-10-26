import 'dart:convert';

class DiscountDataModel {
  String? id;
  String? type;
  double? percentage;
  double? amount;
  String? discountName;
  String? code;

  DiscountDataModel({
    this.id,
    this.type,
    this.percentage,
    this.amount,
    this.discountName,
    this.code,
  });

  DiscountDataModel copyWith({
    String? id,
    String? type,
    double? percentage,
    double? amount,
    String? discountName,
    String? code,
  }) {
    return DiscountDataModel(
      id: id ?? this.id,
      type: type ?? this.type,
      percentage: percentage ?? this.percentage,
      amount: amount ?? this.amount,
      discountName: discountName ?? this.discountName,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'percentage': percentage,
      'amount': amount,
      'discountName': discountName,
      'code': code,
    };
  }

  factory DiscountDataModel.fromMap(Map<String, dynamic> map) {
    return DiscountDataModel(
      id: map['id'],
      type: map['type'],
      percentage: map['percentage']?.toDouble(),
      amount: map['amount']?.toDouble(),
      discountName: map['discountName'],
      code: map['code'],
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
