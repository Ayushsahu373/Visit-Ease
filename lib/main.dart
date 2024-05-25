import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:visit_ease/pages/gatekeeper/Homepage.dart';
import 'package:visit_ease/pages/gatekeeper/dataUpload.dart';
import 'package:visit_ease/pages/institute/fetchdata.dart';
import 'package:visit_ease/pages/institute/institute_login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'VisitEase',
      debugShowCheckedModeBanner: false,
      home: InstituteLogin() ,
    //  HomePageOfGatekeeper(),
    );
  }
}
