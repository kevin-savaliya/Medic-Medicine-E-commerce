import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medic/model/prescription_model.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';
import 'package:sizer/sizer.dart';

class UploadPresController extends GetxController {
  final ImagePicker picker = ImagePicker();

  final selectedImages = <RxString>[].obs;

  var _selectedProfileImage = "".obs;

  String get selectedProfileImage => _selectedProfileImage.value;

  set selectedProfileImage(String value) {
    _selectedProfileImage.value = value;
  }

  TextEditingController titleController = TextEditingController();

  CroppedFile? croppedPostFile;
  CroppedFile? croppedProfileFile;

  CollectionReference presRef =
      FirebaseFirestore.instance.collection("prescriptions");

  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  pickImageFromCamera() async {
    try {
      final XFile? image = await picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          imageQuality: 50);

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

        if (croppedProfileFile != null) {
          selectedImages.add(croppedProfileFile!.path.obs);
          print("Image Picked and Cropped from Camera : $selectedImages");
        } else {
          print("Cropping cancelled");
        }
      } else {
        print("Image picking cancelled");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
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

  Future<void> pickImage(context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: 170,
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            color: AppColors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                ConstString.selectchoice,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 16,
                    color: AppColors.black,
                    fontFamily: AppFont.fontSemiBold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.all(5),
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.splashdetail,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 40);

                        if (image != null) {
                          // _selectedImage.value = image.path;

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

                          _selectedProfileImage.value =
                              croppedProfileFile!.path;

                          print("Image Picked From Camera");
                        }
                        Get.back();
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Image.asset(AppIcons.camerapng, height: 45),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              ConstString.camera,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontSize: 14.5, color: AppColors.black),
                            )
                          ],
                        ),
                        // height: Responsive.height(8, context),
                      ),
                    ),
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 50);

                      if (image != null) {
                        // _selectedImage.value = image.path;

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

                        _selectedProfileImage.value = croppedProfileFile!.path;

                        print("Image Picked From Gallery");
                      }
                      Get.back();
                    },
                    child: Container(
                      // height: Responsive.height(8, context),
                      child: Column(
                        children: [
                          Image.asset(AppIcons.gallerypng, height: 45),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            ConstString.gallery,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 14.5, color: AppColors.black),
                          )
                        ],
                      ),
                    ),
                  )),
                ],
              )
            ],
          ),
        );
      },
    );
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
          List<dynamic> prescriptions = data['prescriptions'] as List<dynamic>;
          prescriptionCount = prescriptions.length;
        }
      } else {
        print('Document with id $documentId does not exist.');
      }
    } catch (e) {
      print('Error fetching prescription count for document: $e');
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

  Future<void> deletePrecription(String prescriptionId) async {
    var userDocRef = presRef.doc(currentUserId);
    try {
      var doc = await userDocRef.get();
      if (doc.exists) {
        List<dynamic> prescriptions = (doc.data()
                as Map<String, dynamic>)['prescriptions'] as List<dynamic>? ??
            [];

        prescriptions.removeWhere(
            (prescription) => prescription['id'] == prescriptionId);

        await userDocRef.update({'prescriptions': prescriptions}).then((value) {
          Get.back();
          showInSnackBar("Prescription Deleted Successfully",
              title: "The Medic", isSuccess: false);
        });
      }
    } catch (e) {
      print("Error Deleting Document : $e");
    }
  }
}
