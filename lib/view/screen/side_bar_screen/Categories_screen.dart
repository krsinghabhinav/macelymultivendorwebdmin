import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:macelymultivendorwebdmin/view/screen/side_bar_screen/widget/category_widget.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '\CategoriesScreen';
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String categoryName;

  dynamic _image;
  String? fileName;

  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  Future<String> _uploadCategoryBannersToStorage(dynamic image) async {
    Reference ref = _storage.ref().child('categoryImages').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    // Await the upload task to complete
    TaskSnapshot snapshot = await uploadTask;
    // Get the download URL after the upload is complete
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> uploadedCategory() async {
    // Show loading indicator
    EasyLoading.show(status: 'Uploading...');

    try {
      // Validate the form
      if (_formKey.currentState!.validate()) {
        // Check if an image is selected
        if (_image != null) {
          // Upload the image and get the URL
          String imageUrl = await _uploadCategoryBannersToStorage(_image);

          // Ensure fileName and categoryName are not null
          if (fileName != null && categoryName != null) {
            // Save the category data to Firestore
            await _firestore.collection('categories').doc(fileName).set({
              'categoryName': categoryName,
              'image': imageUrl,
            }).whenComplete(() {
              EasyLoading.dismiss();

              setState(() {
                _image = null;
                _formKey.currentState!.reset();
              });
            });
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Category uploaded successfully!")),
            );
          } else {
            // If fileName or categoryName is null
            EasyLoading.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error: fileName or categoryName is missing"),
              ),
            );
          }
        } else {
          // If no image is selected
          EasyLoading.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please select an image first"),
            ),
          );
        }
      } else {
        // If form validation fails
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please complete the form before submitting")),
        );
      }
    } catch (e) {
      // Hide loading indicator in case of an error
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading category: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
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
                                child: Image.memory(
                                  _image,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Text("Categories"),
                              ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: SizedBox(
                          width: 250,
                          child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  categoryName = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please category name must not be empty';
                                } else {
                                  return null;
                                }
                              },
                              // controller: _bannerController,
                              decoration: InputDecoration(
                                labelText: 'Enter Category Name',
                                hintText: 'Enter Category Name',
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: 80,
                          child: ElevatedButton(
                            onPressed: uploadedCategory,
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
                                  onPressed: _pickImage,
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
            ),
            const Divider(color: Colors.grey),
            Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Categories",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            CategoryWidget(),
          ],
        ),
      ),
    );
  }
}
