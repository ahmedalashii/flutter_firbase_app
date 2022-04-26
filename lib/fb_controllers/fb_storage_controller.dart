/*
* What is the difference between Firebase Storage and Cloud Firestore/Realtime Database?
* I have been using Google Firebase's Realtime Database,
* but want to be able to store more complex user-generated data like images,
* videos etc. As per the Firebase docs, they provide two other services:
* 'Firebase Storage' and 'Cloud Firestore'.
* Can someone please summarise what the difference is between
* the similarly named 'Storage' and 'Firestore' ?
The answer :
* The products are not really comparable. They have almost nothing in common, except from the perspective of the Firebase client, apps which are gated by security rules.

Cloud Storage is just for storing binary data using paths that look like filesystem paths.
* It's not a database, and you can't really query it like one. It's typically used for things like pictures, videos, PDFs, backups/exports,
* and other raw data which can be very large in size. There is a 5GB limit to the size of data you can store in a single object.
* It's dirt cheap and optimized for download speed, and can be served by CDN.
Firestore is a database used for querying data and is almost never used for storing binary data.
* You use it to store actual values that you intend to query, such as names, times, and other metadata.
* Since a Firestore document is limited to 1MB in size, that also drastically cripples its ability to hold very large amounts of data like Cloud Storage.
* It's also generally more expensive to store and transfer data compared to Cloud Storage,
* as you're paying for much more than just basic storage capabilities.
I suggest reading the documentation for more detailed descriptions of these products.
* It should be clear what specific problems they are trying to solve, as they have essentially no overlap in functionality.
*
* */

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

typedef UploadListener = void Function(
    {required bool status,
    required TaskState taskState,
    String? message,
    Reference? reference});
  /*
  * Reference >> Represents a reference to a Google Cloud Storage object. Developers can upload, download, and delete objects, as well as get/set object metadata.
  * */
class FirebaseStorageController {
  // It's important to read the comments above to understand what exactly is the firebase storage.
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadImage(
      {required File file, required UploadListener uploadListener}) async {
    UploadTask uploadTask = _firebaseStorage
        .ref("images/${DateTime.now()}_image.png")
        .putFile(file);
    uploadTask.snapshotEvents.listen((event) {
      // we can't return bool inside a void function (listen) >> so we have to use typedef
      if (event.state == TaskState.running) {
        uploadListener(status: false, taskState: event.state);
      } else if (event.state == TaskState.success) {
        uploadListener(
            status: true,
            taskState: event.state,
            reference: event.ref,
            message: "Image Uploaded Successfully.");
      } else if (event.state == TaskState.error) {
        uploadListener(
            status: false,
            taskState: event.state,
            message: "Uploading Image has been failed!, something went wrong!");
      }
    });
  }

  Future<List<Reference>> getImages() async {
    ListResult listResult = await _firebaseStorage.ref("images").listAll();
    if (listResult.items.isNotEmpty) {
      return listResult.items;
    }
    return [];
  }

  Future<bool> deleteImage({required String path}) async {
    // Deletes the object at this reference's location.
    return await _firebaseStorage
        .ref(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }
}
