// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';

import '../../../get/images_getx_controller.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  double? _progressValue = 0;
  late ImagePicker _imagePicker;
  XFile? _pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Upload an Image",
            style: TextStyle(color: Colors.grey.shade800)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
      ),
      body: Column(
        children: <Widget>[
          LinearProgressIndicator(
            value: _progressValue, // when the value is null it will loading.
            color: Colors.green,
            backgroundColor: Colors.grey.shade400,
            minHeight: 10,
          ),
          Expanded(
            child: (_pickedFile != null)
                ? Image.file(File(_pickedFile!.path))
                : TextButton(
                    onPressed: () async => await pickImage(),
                    child: Text("Select Image"),
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 20),
                      minimumSize: Size(double.infinity, 0),
                    ),
                  ),
          ),
          ElevatedButton.icon(
            onPressed: () async => await uploadImage(),
            icon: Icon(Icons.cloud_upload),
            label: Text("Upload Image"),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future pickImage() async {
    _imagePicker = ImagePicker();
    XFile? selectedImageFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImageFile != null) {
      setState(() {
        _pickedFile = selectedImageFile;
      });
    }
  }

  Future uploadImage() async {
    _changeProgressValue(value: null);
    if (_pickedFile != null) {
      ImagesGetxController.to.uploadImage(
          file: File(_pickedFile!.path),
          uploadListener: (
              {required bool status,
              required TaskState taskState,
              String? message,
              Reference? reference}) {
            if (taskState == TaskState.running) {
              _changeProgressValue(value: null);
            } else if (taskState == TaskState.success) {
              _changeProgressValue(value: 1);
            } else if (taskState == TaskState.error) {
              _changeProgressValue(value: 0);
            }
          });
    }
  }

  void _changeProgressValue({double? value}) {
    setState(() {
      _progressValue = value;
    });
  }

  void _clearSelectedImage() {
    setState(() {
      _pickedFile = null;
    });
  }
}
