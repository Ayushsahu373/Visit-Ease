import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visit_ease/Widgets/dropDown_textfield.dart';
import 'package:visit_ease/Widgets/gradientButton.dart';
import 'package:visit_ease/Widgets/input_textfield.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:visit_ease/pages/gatekeeper/visiorsID.dart';

class VisitorsDataUpload extends StatefulWidget {
  const VisitorsDataUpload({Key? key}) : super(key: key);

  @override
  _VisitorsDataUploadState createState() => _VisitorsDataUploadState();
}

class _VisitorsDataUploadState extends State<VisitorsDataUpload> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  DateTime now = DateTime.now();
  final Rx<File?> _pickedImage = Rx<File?>(null);
  bool _isLoading = false; // Loading state
  String? _selectedDepartment; // To store selected department

  @override
  void initState() {
    super.initState();
    initializeAppCheck();
    signInAnonymously();
  }

  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print("Failed to sign in anonymously: $e");
    }
  }

  Future<void> initializeAppCheck() async {
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('your-recaptcha-site-key'),
    );
  }

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = Timestamp.fromDate(now);
    var _deviceHeight = MediaQuery.of(context).size.height;
    var _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background color

      body: Stack(
        children: [
           Positioned.fill(
            child: Image.network(
              'https://www.wallpapertip.com/wmimgs/167-1671007_best-android-app-background.jpg', // Change to your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Image.network(
            
          //     height: _deviceHeight,
          //     width: _deviceWidth,
          //     'https://www.wallpapertip.com/wmimgs/167-1671007_best-android-app-background.jpg'),
          SingleChildScrollView(
            child: Container(
              height: _deviceHeight,
              width: _deviceWidth,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: [
                      
                      CircleAvatar(
                        radius: _deviceHeight * .08,
                        backgroundImage: _pickedImage.value == null
                            ? AssetImage("assets/images/image.png")
                            : FileImage(_pickedImage.value!) as ImageProvider,
                        backgroundColor: Colors
                            .grey[400], // Subtle background color for image
                      ),
                      Positioned(
                        bottom: -5,
                        right: 0,
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.blueAccent, // Interactive color
                          ),
                          onPressed: () async {
                            final pickedImage = await ImagePicker().pickImage(
                                source: ImageSource.camera, imageQuality: 30);
                            if (pickedImage != null) {
                              Get.snackbar('Profile Picture',
                                  'You have successfully selected your profile picture!');
                              _pickedImage.value = File(pickedImage.path);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _deviceHeight * 0.045),
                  TextInputField(
                    controller: _nameController,
                    labelText: "Name of Visitor",
                    Preicon: Icons.person,
                  ), // White background for input field
                  SizedBox(height: _deviceHeight * 0.02),
                  TextInputField(
                    controller: _addressController,
                    labelText: "Address",
                    Preicon: Icons.location_city,
                  ),
                  SizedBox(height: _deviceHeight * 0.02),
                  TextInputField(
                    controller: _contactController,
                    labelText: "Contact Number",
                    Preicon: Icons.call,
                  ),
                  SizedBox(height: _deviceHeight * 0.02),
                  TextInputField(
                    controller: _purposeController,
                    labelText: "Purpose of Visit",
                    Preicon: Icons.question_mark,
                  ),
                  SizedBox(height: _deviceHeight * 0.02),
                  DropdownField(
                    items: [
                      "CSE dept.",
                      "EC dept.",
                      "ME dept.",
                      "EE dept.",
                      "AIML dept.",
                      "IOT dept.",
                      "Training dept.",
                      "Placement dept.",
                      "not specified"
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDepartment = newValue;
                      });
                    },
                    labelText: "Choose Department",
                    preIcon: Icons.person,
                  ),
                  SizedBox(height: _deviceHeight * 0.04),
                  GradientButton(
                    buttonText: "Submit",
                    onPressed: () async {
                      setState(() {
                        _isLoading = true; // Show progress indicator
                      });
                      int uniqueId = Random().nextInt(4294967295) + 100000000;
                      if (_pickedImage.value != null) {
                        String visitorImageUrl = await uploadFileToFirebase(
                            _pickedImage.value!, "visitorsImages/$uniqueId");
                        now = DateTime.now();
                        timestamp = Timestamp.fromDate(now);
                        if (_nameController.text.isEmpty ||
                            _addressController.text.isEmpty ||
                            _purposeController.text.isEmpty ||
                            _selectedDepartment == null ||
                            visitorImageUrl.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Error: Fill all the fields",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } else {
                          Map<String, dynamic> visitorsData = {
                            "imagePath": visitorImageUrl,
                            "name": _nameController.text,
                            "address": _addressController.text,
                            "purpose": _purposeController.text,
                            "appointment": _selectedDepartment,
                            "time": timestamp,
                            "uid": uniqueId.toString(),
                            "contact": _contactController.text,
                          };

                          // FirebaseFirestore.instance
                          //     .collection("visitEaseData")
                          //     .doc()
                          //     .set(visitorsData);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VisitorIdCard(visitorData: visitorsData),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Error: No image selected",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                      setState(() {
                        _isLoading = false; // Hide progress indicator
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<String> uploadFileToFirebase(File file, String storagePath) async {
    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child(storagePath).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
