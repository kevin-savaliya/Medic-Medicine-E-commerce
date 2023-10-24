import 'package:medic/utils/firebase_utils.dart';

class PrescriptionData {
  String? id;
  String? title;
  List<dynamic>? images;
  DateTime? uploadTime;
  String? userId;
  bool? isApproved;

  PrescriptionData(this.id, this.title, this.images, this.uploadTime,this.userId,this.isApproved);

  PrescriptionData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    images = map['images'];
    images = map['images'];
    uploadTime = map['uploadTime'] != null
        ? FirebaseUtils.timestampToDateTime(map['uploadTime'])
        : null;
    userId = map['userId'];
    isApproved = map['isApproved'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['images'] = images;
    data['uploadTime'] = uploadTime;
    data['userId'] = userId;
    data['isApproved'] = isApproved;
    return data;
  }
}
