import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medic/model/reminder_data_model.dart';
import 'package:medic/utils/utils.dart';

class ReminderController extends GetxController {
  RxString weekIndex = "".obs;
  RxString monthIndex = "".obs;
  RxString yearIndex = "".obs;

  RxString frequencyValue = "".obs;

  DateTime? selectedDate;
  RxString selectedFormateDate = "Select Date".obs;

  TimeOfDay selectedTime = TimeOfDay.now();

  final String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  TextEditingController medicineController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController doseController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  List<String> frequencyList = ["Everyday", "Date-Duration"];

  final CollectionReference reminderRef =
      FirebaseFirestore.instance.collection("reminders");

  bool validateData() {
    if (medicineController.text.trim().isEmpty) {
      showInSnackBar("Please enter medicine name.",
          title: 'Required!', isSuccess: false);
      return false;
    } else if (amountController.text.trim().isEmpty) {
      showInSnackBar("Please enter amount of pill.",
          title: 'Required!', isSuccess: false);
      return false;
    } else if (doseController.text.trim().isEmpty) {
      showInSnackBar("Please enter doses.",
          title: 'Required!', isSuccess: false);
      return false;
    } else if (timeController.text.trim().isEmpty) {
      showInSnackBar("Please select time.",
          title: 'Required!', isSuccess: false);
      return false;
    }
    return true;
  }

  addReminderdata(ReminderDataModel reminderDataModel) async {
    DocumentSnapshot doc = await reminderRef.doc(currentUser).get();

    if (doc.exists) {
      await reminderRef.doc(currentUser).update({
        'reminders': FieldValue.arrayUnion([reminderDataModel.toMap()])
      });
    } else {
      await reminderRef.doc(currentUser).set({
        'reminders': [reminderDataModel.toMap()]
      });
    }

    Get.back();
    Get.back();
    clearController();
    showInSnackBar("Reminder Added Successfully",
        isSuccess: true, title: "The Medic");
  }

  clearController() {
    medicineController.clear();
    amountController.clear();
    doseController.clear();
    timeController.clear();
    frequencyValue = "".obs;
  }

  Stream<List<ReminderDataModel>> fetchReminder() {
    return reminderRef.doc(currentUser).snapshots().map((doc) {
      if (doc.exists) {
        List reminderList = doc["reminders"] as List;
        List<ReminderDataModel> reminders = reminderList.map((reminder) {
          return ReminderDataModel.fromMap(reminder);
        }).toList();
        return reminders;
      }
      return [];
    });
  }
}
