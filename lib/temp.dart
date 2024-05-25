// import 'dart:io';
// import 'dart:math';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:secureindia/report_mechanism/report_success.dart';

// class Complain_page extends StatefulWidget {
//   const Complain_page({Key? key});

//   @override
//   State<Complain_page> createState() => _Complain_pageState();
// }

// class _Complain_pageState extends State<Complain_page> {
//   TextEditingController _dateController = TextEditingController();
//   TimeOfDay _selectedTime = TimeOfDay.now();
//   TextEditingController _userNameController = TextEditingController();
//   TextEditingController _phoneNumberController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _cityController = TextEditingController();
//   TextEditingController _stateController = TextEditingController();
//   TextEditingController _addressController = TextEditingController();
//   TextEditingController _aadharNumberController = TextEditingController();
//   TextEditingController _bankAccountController = TextEditingController();
//   TextEditingController _transactionIdController = TextEditingController();
//   TextEditingController _fraudAmountController = TextEditingController();
//   TextEditingController _suspectDetailsController = TextEditingController();
//   TextEditingController _suspectMediaController = TextEditingController();
//   TextEditingController _evidenceDescriptionController =
//       TextEditingController();
//   File? _reportImage;
//   File? _idProof;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Report Fraud",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: HexColor("146c94"),
//         centerTitle: true,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "When Did it Happen ?",
//                 style: TextStyle(
//                     fontSize: 19,
//                     color: HexColor("000000"),
//                     fontWeight: FontWeight.bold),
//               ),
//               TextField(
//                 controller: _dateController,
//                 readOnly: true,
//                 onTap: () async {
//                   DateTime? _datePicker = await showDatePicker(
//                     context: context,
//                     firstDate: DateTime(2000),
//                     initialDate: DateTime.now(),
//                     lastDate: DateTime(3000),
//                   );
//                   if (_datePicker != null) {
//                     setState(() {
//                       _dateController.text =
//                           DateFormat('dd-MM-yyyy').format(_datePicker);
//                     });
//                   }
//                 },
//                 decoration: InputDecoration(
//                   labelText: "Select Date",
//                   filled: true,
//                   prefixIcon: Icon(Icons.calendar_today),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 "What time ?",
//                 style: TextStyle(
//                     fontSize: 19,
//                     color: HexColor("000000"),
//                     fontWeight: FontWeight.bold),
//               ),
//               TextField(
//                 autofocus: true,
//                 readOnly: true,
//                 onTap: () async {
//                   final TimeOfDay? timeOfDay = await showTimePicker(
//                     context: context,
//                     initialTime: _selectedTime,
//                     initialEntryMode: TimePickerEntryMode.dial,
//                   );
//                   if (timeOfDay != null) {
//                     setState(() {
//                       _selectedTime = timeOfDay;
//                     });
//                   }
//                 },
//                 decoration: InputDecoration(
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   labelText: "${_selectedTime.hour}:${_selectedTime.minute}",
//                   hintText: "${_selectedTime.hour}:${_selectedTime.minute}",
//                   filled: true,
//                   prefixIcon: Icon(Icons.access_time),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 controller: _userNameController,
//                 decoration: InputDecoration(labelText: 'User Name'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _phoneNumberController,
//                 decoration: InputDecoration(labelText: 'Phone Number'),
//               ),
//               SizedBox(height: 10),
//               // TextField(
//               //   controller: _emailController,
//               //   decoration: InputDecoration(labelText: 'Email Id'),
//               // ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _cityController,
//                 decoration: InputDecoration(labelText: 'City Name'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _stateController,
//                 decoration: InputDecoration(labelText: 'State Name'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _addressController,
//                 decoration: InputDecoration(labelText: 'Address'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _aadharNumberController,
//                 decoration: InputDecoration(labelText: 'Aadhar Number'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _bankAccountController,
//                 decoration: InputDecoration(labelText: 'Bank Account No'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _transactionIdController,
//                 decoration:
//                     InputDecoration(labelText: 'Transaction ID / UTR No'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _fraudAmountController,
//                 decoration: InputDecoration(labelText: 'Fraud Amount'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _suspectDetailsController,
//                 maxLines: 3,
//                 decoration: InputDecoration(labelText: 'Suspect Details'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _suspectMediaController,
//                 decoration:
//                     InputDecoration(labelText: 'Suspect Website or Media'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _evidenceDescriptionController,
//                 maxLines: 3,
//                 decoration: InputDecoration(labelText: 'Evidence Description'),
//               ),
//               SizedBox(height: 20),
//               ListTile(
//                 trailing: Icon(Icons.arrow_forward),
//                 title: Text("Select Evidence"),
//                 tileColor: Colors.grey[300],
//                 onTap: () async {
//                   final selectedImage = await ImagePicker()
//                       .pickImage(source: ImageSource.gallery);
//                   if (selectedImage != null) {
//                     setState(() {
//                       _reportImage = File(selectedImage.path);
//                     });
//                   }
//                 },
//               ),
//               SizedBox(height: 20),
//               ListTile(
//                 trailing: Icon(Icons.arrow_forward),
//                 title: Text("Select IdProof"),
//                 tileColor: Colors.grey[300],
//                 onTap: () async {
//                   final selectedImage = await ImagePicker()
//                       .pickImage(source: ImageSource.gallery);
//                   if (selectedImage != null) {
//                     setState(() {
//                       _idProof = File(selectedImage.path);
//                     });
//                   }
//                 },
//               ),
//               SizedBox(height: 20),
//               Container(
//                 margin: EdgeInsets.only(top: 30, left: 90),
//                 width: 200,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: HexColor("146c94"),
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: HexColor("146c94"), width: 2),
//                 ),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: HexColor("146c94"),
//                   ),
//                   onPressed: addReportToFirebase,
//                   child: Text("Submit",
//                       style: TextStyle(color: Colors.white, fontSize: 20)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> addReportToFirebase() async {
//     // Check if any field is empty
//     if (_userNameController.text.isEmpty ||
//         _phoneNumberController.text.isEmpty ||
//         _cityController.text.isEmpty ||
//         _stateController.text.isEmpty ||
//         _addressController.text.isEmpty ||
//         _aadharNumberController.text.isEmpty ||
//         _bankAccountController.text.isEmpty ||
//         _transactionIdController.text.isEmpty ||
//         _fraudAmountController.text.isEmpty ||
//         _suspectDetailsController.text.isEmpty ||
//         _suspectMediaController.text.isEmpty ||
//         _evidenceDescriptionController.text.isEmpty ||
//         _reportImage == null ||
//         _idProof == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               'Please fill all the fields and select both Evidence and IdProof'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return;
//     }

//     // If all fields are filled, proceed with the submission
//     try {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Creating Complaint'),
//             content: SizedBox(
//               height: 50,
//               width: 50,
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//           );
//         },
//       );

//       // Generate a random 10-digit number
//       int uniqueId = Random().nextInt(4294967295) + 1000000000;

//       // Upload reportImage
//       String reportImageUrl =
//           await uploadFileToFirebase(_reportImage!, "reportPictures/$uniqueId");

//       // Upload idProof
//       String idProofUrl =
//           await uploadFileToFirebase(_idProof!, "idProof/$uniqueId");

//       // Create report data including date and time
//       Map<String, dynamic> reportData = {
//         "complaintId": uniqueId.toString(),
//         "timeofComplaint": Timestamp.now(),
//         "Complaint Reviewed": "",
//         "Complaint Accepted": 0,
//         "Level-1 Completed": 0,
//         "Level-2 Completed": 0,
//         "Level-3 Completed": 0,
//         "Problem Solved": 0,
//         "username": _userNameController.text,
//         "phoneNumber": _phoneNumberController.text,
//         // "email": _emailController.text.trim().toLowerCase(),
//         "email": FirebaseAuth.instance.currentUser?.email,
//         "city": _cityController.text.trim().toLowerCase(),
//         "state": _stateController.text.trim().toLowerCase(),
//         "address": _addressController.text,
//         "aadharNumber": _aadharNumberController.text,
//         "bankAccountNo": _bankAccountController.text,
//         "transactionId": _transactionIdController.text,
//         "fraudAmount": _fraudAmountController.text,
//         "suspectDetails": _suspectDetailsController.text,
//         "suspectMedia": _suspectMediaController.text,
//         "evidenceDescription": _evidenceDescriptionController.text,
//         "reportImage": reportImageUrl,
//         "idProof": idProofUrl,
//         "date": _dateController.text,
//         "time": "${_selectedTime.hour}:${_selectedTime.minute}",
//       };

//       // Add report to Firestore
//       await FirebaseFirestore.instance
//           .collection("complaints")
//           .doc(uniqueId.toString())
//           .set(reportData);

//       Navigator.pop(context); // Close the dialog
//       print("report creaed successfully");
//       // Navigate to report_success page with uniqueId as parameter
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               ReportSuccessPage(uniqueId: uniqueId.toString()),
//         ),
//       );

//       // Clear the fields after successful report creation
//       _userNameController.clear();
//       _phoneNumberController.clear();
//       _emailController.clear();
//       _cityController.clear();
//       _stateController.clear();
//       _addressController.clear();
//       _aadharNumberController.clear();
//       _bankAccountController.clear();
//       _transactionIdController.clear();
//       _fraudAmountController.clear();
//       _suspectDetailsController.clear();
//       _suspectMediaController.clear();
//       _evidenceDescriptionController.clear();
//       _dateController.clear(); // Clear date controller
//       _selectedTime = TimeOfDay.now(); // Reset selected time
//       _reportImage = null;
//       _idProof = null;
//     } catch (e) {
//       print("Error uploading report: $e");
//       Navigator.pop(context); // Close the dialog

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to create report. Please try again.'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   Future<String> uploadFileToFirebase(File file, String storagePath) async {
//     UploadTask uploadTask =
//         FirebaseStorage.instance.ref().child(storagePath).putFile(file);
//     TaskSnapshot taskSnapshot = await uploadTask;
//     return await taskSnapshot.ref.getDownloadURL();
//   }
// }
