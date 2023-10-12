class CategoryData {
  String? id;
  String? name;
  String? image;
  int? sortNo;

  CategoryData({this.id, this.name, this.image, this.sortNo});

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
}
