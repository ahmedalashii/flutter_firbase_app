import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';

/*
* Firestore is one of the two databases available at Firebase.
* It’s a new and improved version of the Real-Time Database,
* and its capabilities include real-time updates, offline synchronization,
* scalability, and multi-region deployment.
* */
/*
* The Difference Between Firebase and Firestore ?
* Firebase is a more compressive solution vs. Firestore and incorporates multiple services like databases,
* notifications, analytics, ML, etc.
* Firestore is a NoSQL database that is part of the Firebase app development platform.
* 1st Link : https://firebase.blog/posts/2017/10/cloud-firestore-for-rtdb-developers
* 2nd Link : https://stackoverflow.com/questions/46549766/whats-the-difference-between-cloud-firestore-and-the-firebase-realtime-database
* */

class FireStoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CRUD

  Future<bool> create({required Note note}) async {
    return await _firestore
        .collection("Notes") // like table
        .add(note.toMap()) // add row
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> update({required Note note}) {
    return _firestore
        .collection("Notes")
        .doc(note.id)
        .update(note.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Stream<QuerySnapshot> read() async* {
    yield* _firestore.collection("Notes").snapshots();
  }

  Future<bool> delete({required String path}) {
    return _firestore
        .collection("Notes")
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }
}
