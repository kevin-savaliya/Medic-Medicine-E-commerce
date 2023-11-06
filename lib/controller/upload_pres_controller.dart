import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medic/model/prescription_model.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/utils.dart';

class UploadPresController extends GetxController {
  final ImagePicker picker = ImagePicker();

  final selectedImages = <RxString>[].obs;

  TextEditingController titleController = TextEditingController();

  CroppedFile? croppedPostFile;
  CroppedFile? croppedProfileFile;

  CollectionReference presRef =
      FirebaseFirestore.instance.collection("prescriptions");

  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  pickImageFromCamera() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

    if (image != null) {
      File imageFile = File(image.path);
      croppedProfileFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: AppColors.white,
            toolbarTitle: 'Crop Image',
          ),
          IOSUiSettings(
            title: 'Crop Image',
          )
        ],
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio7x5,
        ],
      );

      selectedImages.add(croppedProfileFile!.path.obs);
      print("Image Picked From Camera");
    }
    Get.back();
  }

  pickImageFromGallery() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (image != null) {
      File imageFile = File(image.path);
      croppedProfileFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: AppColors.white,
            toolbarTitle: 'Crop Image',
          ),
          IOSUiSettings(
            title: 'Crop Image',
          )
        ],
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio7x5,
        ],
      );

      selectedImages.add(croppedProfileFile!.path.obs);

      print("Image Picked From Gallery");
    }
    Get.back();
  }

  bool isValidate() {
    if (titleController.text.trim().isEmpty) {
      showInSnackBar("Please enter prescription.",
          title: 'Required!', isSuccess: false);
      return false;
    } else if (selectedImages.isEmpty) {
      showInSnackBar("Please select prescription images.",
          title: 'Required!', isSuccess: false);
      return false;
    }
    return true;
  }

  Future<void> storePrescription(String title) async {
    final RxList<String> imageUrls = <String>[].obs;

    List<File> files = selectedImages.map((path) => File(path.value)).toList();

    for (var image in files) {
      String imgUrl = await uploadImage(image);
      imageUrls.add(imgUrl);
    }

    String id = presRef.doc().id;

    int prescriptionLength = await getPrescriptionCount(currentUserId!);

    PrescriptionData data = PrescriptionData(
        id,
        title,
        imageUrls,
        DateTime.now(),
        currentUserId,
        [],
        false,
        currentUserId,
        (prescriptionLength));

    DocumentSnapshot snapshot = await presRef.doc(currentUserId).get();

    if (snapshot.exists) {
      await presRef.doc(currentUserId).update({
        'prescriptions': FieldValue.arrayUnion([data.toMap()])
      });
    } else {
      await presRef.doc(currentUserId).set({
        'prescriptions': [data.toMap()]
      });
    }
    Get.back();
    Get.back();
    showInSnackBar("Prescription Added Successfully",
        isSuccess: true, title: "The Medic");
  }

  Future<int> getPrescriptionCount(String documentId) async {
    DocumentReference prescriptionDocRef =
        FirebaseFirestore.instance.collection('prescriptions').doc(documentId);
    int prescriptionCount = 0;

    try {
      DocumentSnapshot documentSnapshot = await prescriptionDocRef.get();
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('prescriptions')) {
          // Assuming 'prescriptions' is the key for the list of prescriptions in the document
          List<dynamic> prescriptions = data['prescriptions'] as List<dynamic>;
          prescriptionCount = prescriptions.length;
        }
      } else {
        print('Document with id $documentId does not exist.');
      }
    } catch (e) {
      print('Error fetching prescription count for document: $e');
      // Handle the exception appropriately.
    }

    return prescriptionCount;
  }

  Future<String> uploadImage(File image) async {
    final storageReference = FirebaseStorage.instance.ref().child(
        'prescriptions/$currentUserId/${DateTime.now().toIso8601String()}.jpg');
    final uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => {});
    final downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  }

  Stream<List<PrescriptionData>> fetchPrescriptions() {
    return presRef.doc(currentUserId).snapshots().map((snapshot) {
      List<PrescriptionData> prescriptions = [];
      if (snapshot.exists) {
        Map<String, dynamic>? userData =
            snapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('prescriptions')) {
          List<Map<String, dynamic>> prescriptionMaps =
              List<Map<String, dynamic>>.from(userData['prescriptions']);
          prescriptions = prescriptionMaps
              .map((map) => PrescriptionData.fromMap(map))
              .toList();
        }
      }
      return prescriptions;
    });
  }

  uploadPrescriptions() {
    var data = presRef.snapshots().map((snapshot) {
      return snapshot.docs.map((e) {
        return PrescriptionData.fromMap(e.data() as Map<String, dynamic>);
      }).toList();
    });
    return data;
  }
}
