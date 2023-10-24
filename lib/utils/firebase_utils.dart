import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUtils {
  static DateTime timestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
}
