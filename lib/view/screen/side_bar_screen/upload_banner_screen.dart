import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UploadBannerScreen extends StatefulWidget {
  static const String routeName = '\UploadedScreen';
  const UploadBannerScreen({super.key});

  @override
  State<UploadBannerScreen> createState() => _UploadBannerScreenState();
}

class _UploadBannerScreenState extends State<UploadBannerScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  dynamic _image;
  String? fileName;

  // Function to pick an image
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  // Function to upload the banner to Firebase Storage
  Future<String> _uploadBannerToStore(dynamic image) async {
    Reference ref = _storage.ref().child("Banners").child(fileName!);

    UploadTask uploadTask = ref.putData(image); // For web, use bytes

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Function to upload the image URL to Firestore
  uploadToFireStore() async {
    try {
      // Show loading indicator
      EasyLoading.show();

      // Check if image is selected
      if (_image != null) {
        // Upload the image and get the URL
        String imageUrl = await _uploadBannerToStore(_image);

        // Upload the image URL to Firestore
        await _firestore.collection("banners").doc(fileName).set({
          "image": imageUrl,
        }).whenComplete(() {
          EasyLoading.dismiss();

          // setState(() {
          //   _image = null;
          // });
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Banner uploaded successfully!")),
        );
      } else {
        // Hide loading indicator if no image is selected
        EasyLoading.dismiss();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select an image first")),
        );
      }
    } catch (e) {
      // Hide loading indicator if an error occurs
      EasyLoading.dismiss();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload banner: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Banner',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade800),
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 165, 162, 162),
                      ),
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(_image, fit: BoxFit.cover))
                          : const Center(child: Text("Banners")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        width: 80,
                        child: ElevatedButton(
                          onPressed: uploadToFireStore,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Save"),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Center(
                            child: SizedBox(
                              width: 140,
                              child: ElevatedButton(
                                onPressed: pickImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow.shade700,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("Upload Image"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
