import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../fb_controllers/fb_storage_controller.dart';

class ImagesGetxController extends GetxController {
  static ImagesGetxController get to => Get.find();
  final FirebaseStorageController _fbStorageController =
      FirebaseStorageController();
  RxList<Reference> references = <Reference>[].obs;

  @override
  void onInit() {
    getImages();
    super.onInit();
  }

  Future<void> uploadImage(
      {required File file, required UploadListener uploadListener}) async {
    _fbStorageController.uploadImage(
        file: file,
        uploadListener: (
            {required bool status,
            required TaskState taskState,
            String? message,
            Reference? reference}) {
          if (status && reference != null) {
            references.add(reference);
          }
          uploadListener(
              taskState: taskState, status: status, message: message);
        });
  }

  Future<void> getImages() async {
    references.value = await _fbStorageController.getImages();
  }

  Future<bool> deleteImage({required String path}) async {
    bool deleted = await _fbStorageController.deleteImage(path: path);
    if (deleted) {
      // The full path of this object.
      references.removeWhere((element) => element.fullPath == path);
    }
    return deleted;
  }
}
