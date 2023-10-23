import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

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

    Map<String, dynamic> prescriptionData = {
      'title': title,
      'images': imageUrls
    };

    DocumentSnapshot snapshot = await presRef.doc(currentUserId).get();

    if (snapshot.exists) {
      await presRef.doc(currentUserId).update({
        'prescriptions': FieldValue.arrayUnion([prescriptionData])
      });
    } else {
      await presRef.doc(currentUserId).set({
        'prescriptions': [prescriptionData]
      });
    }
    Get.back();
    showInSnackBar("Prescriptioon Added Successfully",isSuccess: true,title: "The Medic");
  }

  Future<String> uploadImage(File image) async {
    final storageReference = FirebaseStorage.instance.ref().child(
        'prescription_images/$currentUserId/${DateTime.now().toIso8601String()}.png');
    final uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => {});
    final downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  }
}
