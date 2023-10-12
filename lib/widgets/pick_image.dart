import 'dart:io';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medic/theme/colors.dart';

class PickImageController extends GetxController {
  final ImagePicker picker = ImagePicker();

  final selectedImage = "".obs;

  CroppedFile? croppedPostFile;
  CroppedFile? croppedProfileFile;

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

      selectedImage.value = croppedProfileFile!.path;

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

      selectedImage.value = croppedProfileFile!.path;

      print("Image Picked From Gallery");
    }
    Get.back();
  }
}
