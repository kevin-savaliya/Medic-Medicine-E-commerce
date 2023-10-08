import 'dart:convert';

class UserAddress {
  String? id;
  String? title;
  String? address;
  String? area;
  String? landmark;
  bool? isActive;

  UserAddress({
    this.id,
    this.title,
    this.address,
    this.area,
    this.landmark,
    this.isActive,
  });

  UserAddress copyWith({
    String? id,
    String? title,
    String? address,
    String? area,
    String? landmark,
    bool? isActive,
  }) {
    return UserAddress(
      id: id ?? this.id,
      title: title ?? this.title,
      address: address ?? this.address,
      area: area ?? this.area,
      landmark: landmark ?? this.landmark,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'address': address,
      'area': area,
      'landmark': landmark,
      'isActive': isActive,
    };
  }

  factory UserAddress.fromMap(Map<String, dynamic> map) {
    return UserAddress(
      id: map['id'],
      title: map['title'],
      address: map['address'],
      area: map['area'],
      landmark: map['landmark'],
      isActive: map['isActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAddress.fromJson(String source) =>
      UserAddress.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAddress &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isActive == other.isActive;

  @override
  int get hashCode => id.hashCode ^ isActive.hashCode;
}
