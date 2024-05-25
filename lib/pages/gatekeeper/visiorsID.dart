import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:visit_ease/pages/gatekeeper/Homepage.dart';
import 'package:visit_ease/pages/gatekeeper/dataUpload.dart';

class VisitorIdCard extends StatefulWidget {
  final Map<String, dynamic> visitorData;

  const VisitorIdCard({Key? key, required this.visitorData}) : super(key: key);

  @override
  _VisitorIdCardState createState() => _VisitorIdCardState();
}

class _VisitorIdCardState extends State<VisitorIdCard> {
  GlobalKey _globalKey = GlobalKey();
  String? _downloadUrl;
  bool _isLoading = false; // Loading state variable
  late final String entryTime;

  @override
  void initState() {
    super.initState();
    entryTime = widget.visitorData['time'].toDate().toString();
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.visitorData['name'];
    final String contact = widget.visitorData['contact'];
    final String address = widget.visitorData['address'];
    final String appointmentWith = widget.visitorData['appointment'];
    final String purpose = widget.visitorData['purpose'];
    final String uid = widget.visitorData['uid'].toString();
    final String imageUrl = widget.visitorData['imagePath'];

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Digital Visiors ID        ",
            style: TextStyle(color: Colors.white),
          ),
        ),
        excludeHeaderSemantics: true,
        backgroundColor: const Color.fromARGB(255, 134, 19, 154),
      ),
      backgroundColor: const Color.fromARGB(255, 88, 88, 88),
      body: Stack(
        children: [
          Center(
            child: RepaintBoundary(
              key: _globalKey,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    // Background Image with Opacity
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.12,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://gyaanarth.com/wp-content/uploads/2022/06/SISTec_Logo.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      height: 500,
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: 50,
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                size: 100,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: Text(
                              'Visitor ID: $uid',
                              style: GoogleFonts.roboto(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Divider(color: Colors.black),
                          SizedBox(height: 16),
                          Text(
                            'Name: $name',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Contact: $contact',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Address: $address',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Appointment with: $appointmentWith',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Purpose: $purpose',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Entry Time: $entryTime',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _captureAndUploadImage,
        backgroundColor: Color.fromARGB(255, 69, 22, 99),
        child: Icon(Icons.download_sharp, color: Colors.white),
      ),
    );
  }

  Future<void> _captureAndUploadImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final String downloadUrl = await uploadImageToFirebase(
            pngBytes, widget.visitorData['uid'].toString());
        bool isdone = false;
        Map<String, dynamic> locateVisitor = {
          "visitors ID": downloadUrl.toString(),
          "isDone": isdone,
          "entrytime": entryTime,
          "exittime": "",
          "appointmentWith": widget.visitorData['appointment'],
          "uid": widget.visitorData['uid'],
          "met with": "",
        };
        FirebaseFirestore.instance
            .collection("visitEaseData")
            .doc()
            .set(locateVisitor);
        setState(() {
          _downloadUrl = downloadUrl;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Download Your Visitor ID Card',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    QrImageView(
                      data: _downloadUrl!,
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width * 0.6,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Scan the QR code with Google Lens to download the image",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePageOfGatekeeper()),
                        );
                      },
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture and upload image: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> uploadImageToFirebase(Uint8List pngBytes, String uid) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('visitor_id_cards/$uid.png');
    final UploadTask uploadTask = storageReference.putData(pngBytes);
    final TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
