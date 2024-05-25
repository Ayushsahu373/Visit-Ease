import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:visit_ease/Widgets/gradientButton.dart';
import 'package:visit_ease/Widgets/input_textfield.dart';
import 'package:visit_ease/pages/institute/fetchdata.dart';

class InstituteLogin extends StatefulWidget {
  const InstituteLogin({Key? key}) : super(key: key);

  @override
  _InstituteLoginState createState() => _InstituteLoginState();
}

class _InstituteLoginState extends State<InstituteLogin> {
  TextEditingController _instituteID = TextEditingController();
  TextEditingController _institutePass = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var _deviceHeight = MediaQuery.of(context).size.height;
    var _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image that fits the entire device screen
          Positioned.fill(
            child: Image.network(
              'https://www.wallpapertip.com/wmimgs/167-1671007_best-android-app-background.jpg', // Change to your background image URL
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.only(
              top: 80.0,
              left: 8.0,
              right: 8.0,
              bottom: 8.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Institute",
                  style: TextStyle(
                    fontSize: _deviceHeight * .06,
                    color: Colors
                        .white, // Changed text color to be visible on background
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "log-in",
                  style: TextStyle(
                    fontSize: _deviceHeight * .05,
                    color: Colors
                        .white, // Changed text color to be visible on background
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: _deviceHeight * 0.045,
                ),
                TextInputField(
                  controller: _instituteID,
                  labelText: "Institute ID",
                  Preicon: Icons.location_city,
                ),
                SizedBox(
                  height: _deviceHeight * 0.03,
                ),
                TextInputField(
                  controller: _institutePass,
                  labelText: "Institute Password",
                  isObscure: true,
                  Preicon: Icons.password,
                ),
                SizedBox(
                  height: _deviceHeight * 0.03,
                ),
                SizedBox(
                  height: _deviceHeight * 0.045,
                ),
                GradientButton(
                  buttonText: "Submit",
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });

                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _instituteID.text,
                            password: _institutePass.text)
                        .then((value) {
                      setState(() {
                        _isLoading = false;
                      });

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DataBaseRetrievalScreen(
                                    email: _instituteID.text,
                                  )));
                    }).catchError((error) {
                      setState(() {
                        _isLoading = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Login failed: $error"),
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
