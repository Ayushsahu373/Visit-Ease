// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for NumberFormatter

import 'package:visit_ease/pages/gatekeeper/dataUpload.dart';
 String timekey="";
class HomePageOfGatekeeper extends StatelessWidget {
 
  const HomePageOfGatekeeper({
    Key? key,
   
  }) : super(key: key);

  void _updateIsDone(String field, String value, String exittime) {
    FirebaseFirestore.instance
        .collection('visitEaseData')
        .where(field,
            isEqualTo:
                value) // Query documents where the field matches the value
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // Loop through the documents and update each one
        FirebaseFirestore.instance
            .collection('visitEaseData')
            .doc(doc.id) // Use the document ID of each document
            .update({'exittime': exittime});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    timekey = now.toString();
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://www.wallpapertip.com/wmimgs/167-1671007_best-android-app-background.jpg', // Change to your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Visit Ease App Name
          Positioned(
            top: 50, // Adjust top position as needed
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Visit Ease',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.transparent,
                    // Add additional styling as needed
                  ),
                ),
              ),
            ),
          ),
          // Entry Button
          Positioned(
            bottom: 120,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisitorsDataUpload()),
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Entry',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Exit Button
          Positioned(
            bottom: 120,
            right: 20,
            child: GestureDetector(
              onTap: () {
                _showExitDialog(context);
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Exit',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    TextEditingController uidController = TextEditingController();
    // Use NumberFormatter to accept only numeric input
    NumberTextInputFormatter numberFormatter = NumberTextInputFormatter();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: uidController,
                inputFormatters: [numberFormatter], // Apply the numberFormatter
                keyboardType:
                    TextInputType.number, // Set the keyboard type to number
                decoration: const InputDecoration(
                  labelText: 'UID',
                  hintText: 'Enter UID',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel button
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform action with UID
                String uid = uidController.text;
                print('UID entered: $uid');
                _updateIsDone('uid', uid, timekey);
                Navigator.of(context).pop();
              },
              child: Text('Exit'),
            ),
          ],
        );
      },
    );
  }
}

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;

    // Use regular expression to allow only numbers
    final newString = newText.replaceAll(RegExp(r'[^0-9]'), '');

    return newString != newText
        ? TextEditingValue(
            text: newString,
            selection: TextSelection.collapsed(offset: newString.length),
          )
        : newValue;
  }
}
