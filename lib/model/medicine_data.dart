import 'dart:convert';

class MedicineData {
  String? id;
  String? about;
  String? brandName;
  String? categoryId;
  String? drugDrugInteractions;
  String? image;
  String? placeholderImage;
  double? ratings;
  String? genericName;
  String? description;
  String? benefits;
  String? uses;
  String? directionForUse;
  String? safetyInformation;

  MedicineData({
    this.id,
    this.about,
    this.brandName,
    this.categoryId,
    this.drugDrugInteractions,
    this.image,
    this.placeholderImage,
    this.ratings,
    this.genericName,
    this.description,
    this.benefits,
    this.uses,
    this.directionForUse,
    this.safetyInformation,
  });

  MedicineData copyWith({
    String? id,
    String? about,
    String? brandName,
    String? categoryId,
    String? drugDrugInteractions,
    String? image,
    String? placeholderImage,
    double? ratings,
    String? genericName,
    String? description,
    String? benefits,
    String? uses,
    String? directionForUse,
    String? safetyInformation,
  }) {
    return MedicineData(
      id: id ?? this.id,
      about: about ?? this.about,
      brandName: brandName ?? this.brandName,
      categoryId: categoryId ?? this.categoryId,
      drugDrugInteractions: drugDrugInteractions ?? this.drugDrugInteractions,
      image: image ?? this.image,
      placeholderImage: placeholderImage ?? this.placeholderImage,
      ratings: ratings ?? this.ratings,
      genericName: genericName ?? this.genericName,
      description: description ?? this.description,
      benefits: benefits ?? this.benefits,
      uses: uses ?? this.uses,
      directionForUse: directionForUse ?? this.directionForUse,
      safetyInformation: safetyInformation ?? this.safetyInformation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'about': about,
      'brandName': brandName,
      'categoryId': categoryId,
      'drugDrugInteractions': drugDrugInteractions,
      'image': image,
      'placeholderImage': placeholderImage,
      'ratings': ratings,
      'genericName': genericName,
      'description': description,
      'benefits': benefits,
      'uses': uses,
      'directionForUse': directionForUse,
      'safetyInformation': safetyInformation,
    };
  }

  factory MedicineData.fromMap(Map<String, dynamic> map) {
    return MedicineData(
      id: map['id'],
      about: map['about'],
      brandName: map['brandName'],
      categoryId: map['categoryId'],
      drugDrugInteractions: map['drugDrugInteractions'],
      image: map['image'],
      placeholderImage: map['placeholderImage'],
      ratings: map['ratings'],
      genericName: map['genericName'],
      description: map['description'],
      benefits: map['benefits'],
      uses: map['uses'],
      directionForUse: map['directionForUse'],
      safetyInformation: map['safetyInformation'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicineData.fromJson(String source) =>
      MedicineData.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          categoryId == other.categoryId;

  @override
  int get hashCode => id.hashCode ^ categoryId.hashCode;
}
