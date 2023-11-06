import 'package:medic/utils/firebase_utils.dart';

class PrescriptionData {
  String? id;
  String? title;
  List<dynamic>? images;
  DateTime? uploadTime;
  String? userId;
  List<dynamic>? medicineList;
  bool? isApproved;
  String? documentId;
  int? prescriptionIndex;

  PrescriptionData(
      this.id,
      this.title,
      this.images,
      this.uploadTime,
      this.userId,
      this.medicineList,
      this.isApproved,
      this.documentId,
      this.prescriptionIndex);

  PrescriptionData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    images = map['images'];
    images = map['images'];
    uploadTime = map['uploadTime'] != null
        ? FirebaseUtils.timestampToDateTime(map['uploadTime'])
        : null;
    userId = map['userId'];
    medicineList = map['medicineList'];
    isApproved = map['isApproved'];
    documentId = map['documentId'];
    prescriptionIndex = map['prescriptionIndex'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['images'] = images;
    data['uploadTime'] = uploadTime;
    data['userId'] = userId;
    data['medicineList'] = medicineList;
    data['isApproved'] = isApproved;
    data['documentId'] = documentId;
    data['prescriptionIndex'] = prescriptionIndex;
    return data;
  }
}
