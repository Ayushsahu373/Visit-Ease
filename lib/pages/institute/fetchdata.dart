import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum SortOption { all, met, not_met, in_campus, exited }

class DataBaseRetrievalScreen extends StatefulWidget {
  final String email; // Added email parameter

  const DataBaseRetrievalScreen({Key? key, required this.email})
      : super(key: key);

  @override
  State<DataBaseRetrievalScreen> createState() =>
      _DataBaseRetrievalScreenState();
}

class _DataBaseRetrievalScreenState extends State<DataBaseRetrievalScreen> {
  late String _department = '';
  SortOption _selectedSort = SortOption.all;

  @override
  void initState() {
    super.initState();
    _determineDepartment();
  }

  void _determineDepartment() {
    if (widget.email == 'admin@sistec.com') {
      _department = 'admin'; // special case for admin
    } else if (widget.email.contains('cse')) {
      _department = 'CSE dept.';
    } else if (widget.email.contains('ec')) {
      _department = 'EC dept.';
    } else if (widget.email.contains('me')) {
      _department = 'ME dept.';
    } else if (widget.email.contains('ee')) {
      _department = 'EE dept.';
    } else if (widget.email.contains('aiml')) {
      _department = 'AIML dept.';
    } else if (widget.email.contains('iot')) {
      _department = 'IOT dept.';
    } else if (widget.email.contains('training')) {
      _department = 'Training dept.';
    } else if (widget.email.contains('placement')) {
      _department = 'Placement dept.';
    }
  }

  Stream<QuerySnapshot> _getFilteredStream() {
    Query query = FirebaseFirestore.instance.collection('visitEaseData');

    // Apply department filter if the user is not an admin
    if (_department != 'admin') {
      query = query.where('appointmentWith', isEqualTo: _department);
    }

    if (_selectedSort == SortOption.met) {
      query = query.where('isDone', isEqualTo: true);
    } else if (_selectedSort == SortOption.not_met) {
      query = query.where('isDone', isEqualTo: false);
    } else if (_selectedSort == SortOption.in_campus) {
      query = query.where('exittime', isEqualTo: "");
    } else if (_selectedSort == SortOption.exited) {
      query = query.where('exittime', isNotEqualTo: "");
    }

    return query.snapshots();
  }

  void _updateIsDone(String docId, bool isDone, String metWith) {
    FirebaseFirestore.instance.collection('visitEaseData').doc(docId).update({
      'isDone': isDone,
      'met with': metWith,
    });
  }

  @override
  Widget build(BuildContext context) {
    var _deviceHeight = MediaQuery.of(context).size.height;
    var _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 174, 174, 174),
      appBar: AppBar(
        title: Center(
          child: Text(
            "$_department       ",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        excludeHeaderSemantics: true,
        backgroundColor: const Color.fromARGB(255, 134, 19, 154),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: DropdownButton<SortOption>(
                      focusColor: Colors.green[100],
                      dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                      iconEnabledColor: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      value: _selectedSort,
                      onChanged: (SortOption? newValue) {
                        setState(() {
                          _selectedSort = newValue!;
                        });
                      },
                      items: SortOption.values.map((SortOption option) {
                        return DropdownMenuItem<SortOption>(
                          value: option,
                          child: Text(option.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: _deviceHeight * 0.8,
                width: _deviceWidth * 0.8,
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: _getFilteredStream(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No data available'),
                          );
                        }

                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var document = snapshot.data!.docs[index];
                              var docId = document.id;
                              var imageUrl = document["visitors ID"];
                              var entryTime = document["entrytime"];
                              var exitTime = document["exittime"];
                              var uid = document["uid"];
                              var appointmentWith = document["appointmentWith"];
                              var isDone = document["isDone"];
                              var metWith = document["met with"];

                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Update Status'),
                                        content: const Text(
                                            'Do you want to mark this as met?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _updateIsDone(docId, true,
                                                  _department);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4.0,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        imageUrl != null
                                            ? Image.network(imageUrl)
                                            : const Icon(
                                                Icons.image_not_supported),
                                        const SizedBox(height: 8.0),
                                        Text('Entry Time: $entryTime'),
                                        Text('Exit Time: $exitTime'),
                                        Text('UID: $uid'),
                                        Text(
                                            'Appointment With: $appointmentWith'),
                                        Text(
                                            'Is Done: ${isDone ? "Yes" : "No"}'),
                                        Text('Met with: $metWith'),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder<QuerySnapshot>(
                      stream: _getFilteredStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (!snapshot.hasData) {
                          return const Text('Loading...');
                        } else {
                          final count = snapshot.data!.docs.length;
                          return Text(
                            'Total count: $count',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
