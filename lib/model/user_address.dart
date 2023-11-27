import 'dart:convert';

class UserAddress {
  String? id;
  String? title;
  String? address;
  String? area;
  String? landmark;
  String? name;
  String? mobileNo;
  bool? isActive;

  UserAddress({
    this.id,
    this.title,
    this.address,
    this.area,
    this.landmark,
    this.name,
    this.mobileNo,
    this.isActive,
  });

  UserAddress copyWith({
    String? id,
    String? title,
    String? address,
    String? area,
    String? landmark,
    String? name,
    String? mobileNo,
    bool? isActive,
  }) {
    return UserAddress(
      id: id ?? this.id,
      title: title ?? this.title,
      address: address ?? this.address,
      area: area ?? this.area,
      landmark: landmark ?? this.landmark,
      name: name ?? this.name,
      mobileNo: mobileNo ?? this.mobileNo,
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
      'name': name,
      'mobileNo': mobileNo,
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
      name: map['name'],
      mobileNo: map['mobileNo'],
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
