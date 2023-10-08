import 'dart:convert';

class MCategory {
  String? id;
  String? name;
  String? image;
  int? sortNo;

  MCategory({
    this.id,
    this.name,
    this.image,
    this.sortNo,
  });

  MCategory copyWith({
    String? id,
    String? name,
    String? image,
    int? sortNo,
  }) {
    return MCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      sortNo: sortNo ?? this.sortNo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'sortNo': sortNo,
    };
  }

  factory MCategory.fromMap(Map<String, dynamic> map) {
    return MCategory(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      sortNo: map['sortNo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MCategory.fromJson(String source) =>
      MCategory.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MCategory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          sortNo == other.sortNo;

  @override
  int get hashCode => id.hashCode ^ sortNo.hashCode;
}
