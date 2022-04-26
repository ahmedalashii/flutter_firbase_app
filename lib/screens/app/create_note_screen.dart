import 'package:firebase_app/fb_controllers/fb_firestore_controller.dart';
import "package:flutter/material.dart";

import '../../models/note.dart';
import '../../utils/helpers.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({Key? key}) : super(key: key);

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> with Helpers {
  late TextEditingController _titleTextController;
  late TextEditingController _infoTextController;

  @override
  void initState() {
    _titleTextController = TextEditingController();
    _infoTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _infoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Note",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          TextField(
            controller: _titleTextController,
            decoration: const InputDecoration(
              hintText: "Title",
            ),
          ),
          TextField(
            controller: _infoTextController,
            decoration: const InputDecoration(
              hintText: "Info",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => performSave(),
            child: const Text("SAVE"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 50),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> performSave() async {
    if (checkData()) {
      await save();
    }
  }

  bool checkData() {
    if (_titleTextController.text.isNotEmpty &&
        _infoTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(
        context: context, message: "Enter All Required Data!", error: true);

    return false;
  }

  Future<void> save() async {
    bool status = await FireStoreController().create(note: note);
    String message = (status) ? "Created Successfully" : "Creation Failed!";
    showSnackBar(context: context, message: message, error: !status);
    if(status) clear();
    // SUCCESS
  }

  Note get note {
    Note note = Note();
    note.title = _titleTextController.text;
    note.info = _infoTextController.text;
    return note;
  }

  void clear(){
    _titleTextController.text = "";
    _infoTextController.text = "";
  }
}
