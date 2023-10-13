import 'dart:convert';

class CategoryData {
  String? id;
  String? name;
  String? image;
  int? sortNo;

  CategoryData({this.id, this.name, this.image, this.sortNo});

  CategoryData copyWith({
    String? id,
    String? name,
    String? image,
    int? sortNo,
  }) {
    return CategoryData(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      sortNo: sortNo ?? this.sortNo,
    );
  }

  CategoryData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    image = map['image'];
    sortNo = map['sortNo'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['sortNo'] = sortNo;
    return data;
  }

  String toJson() => json.encode(toMap());

  factory CategoryData.fromJson(String source) =>
      CategoryData.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategoryData &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              sortNo == other.sortNo;

  @override
  int get hashCode => id.hashCode ^ sortNo.hashCode;
}
