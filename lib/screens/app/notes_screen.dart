import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/fb_controllers/fb_auth_controller.dart';
import 'package:firebase_app/fb_controllers/fb_firestore_controller.dart';
import 'package:firebase_app/fb_controllers/fb_notifications.dart';
import "package:flutter/material.dart";

import '../../models/note.dart';
import '../../utils/helpers.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with Helpers, FirebaseNotifications {
  @override
  void initState() {
    super.initState();
    initializeForegroundNotificationForAndroid();
    manageNotificationAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, "/create_note_screen"),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notes", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, "/images_screen");
            },
            icon: const Icon(Icons.image),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuthController().signOut();
              Navigator.pushReplacementNamed(context, "/login_screen");
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      // Firestore Database >> table is a collection , row in the table is called document in this collection, column in the table called key in this collection.
      body: StreamBuilder<QuerySnapshot>(
          stream: FireStoreController().read(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              List<QueryDocumentSnapshot> notes = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.note),
                      title: Text(notes[index].get("title")),
                      subtitle: Text(notes[index].get("info")),
                      trailing: IconButton(
                        onPressed: () async =>
                            await deleteNote(path: notes[index].id),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.warning, size: 80),
                    Text(
                      "NO DATA!",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Future<void> deleteNote({required String path}) async {
    bool status = await FireStoreController().delete(path: path);
    String message = status ? "Deleted Successfully" : "Deletion Failed!";
    showSnackBar(context: context, message: message, error: !status);
  }
}
