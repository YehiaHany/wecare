import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wecare/screens/general/toast.dart';
import 'package:wecare/screens/doctor/mainPageDoc.dart';

import '../loading/loading.dart';

class DoctorInfo extends StatefulWidget {
  final String userId;
  const DoctorInfo({super.key, required this.userId});

  @override
  State<DoctorInfo> createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  TextEditingController _doctorSpecializationController = TextEditingController();
  List<TextEditingController> _workingPlaceControllers = [TextEditingController()];
  TextEditingController _universityController = TextEditingController();
  DateTime? _selectedGraduationDate;
  File? _pdf;
  TextEditingController _pdfController = TextEditingController();
  bool isNext = false;


  Future<String?> _pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String? filePath = result.files.single.path;
        _pdf = File(filePath!);
        return result.files.first.path;
      }
    } catch (e) {
      print('Error picking PDF: $e');
    }

    return null;
  }
  Future<String> _uploadImageToStorage(File pdf) async {
    if (pdf != null) {
      final path= 'files/${pdf.hashCode}.pdf';
      final ref = FirebaseStorage.instance.ref().child(path);
      UploadTask? uploadTask = ref.putFile(pdf);
      final snapshot = await uploadTask!.whenComplete(() => {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      return urlDownload;
    } else {
      return ''; // Return an empty string if no image is provided
    }
  }

  Future<void> _saveDoctorInfo() async {
    try {
      CollectionReference doctorsCollection = FirebaseFirestore.instance.collection('doctors');
      String Url = '';
      if (_pdf != null) {
        Url = await _uploadImageToStorage(_pdf!);
      }
      await doctorsCollection.doc(widget.userId).set({
        'specialization': _doctorSpecializationController.text,
        'workingPlaces': _workingPlaceControllers.map((controller) => controller.text).toList(),
        'university': _universityController.text,
        'graduationDate': _selectedGraduationDate != null ? _selectedGraduationDate!.year.toString() : '',
        'pdfPath':Url,
      }, SetOptions(merge: true));
      showToast(message: 'Doctor information saved/updated successfully');
    } catch (e) {
      print('Error saving doctor information: $e');
      // Handle the error
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 35,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Info',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Image.asset(
                      'assets/images/sma3a.png',
                      height: 100,
                      width: 100,
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
                elevation: 40.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        TextFormField(
                          cursorColor: Colors.black,
                          controller: _doctorSpecializationController,
                          decoration: InputDecoration(
                            labelText: 'Doctor Specialization',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.healing, color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                width: 3.0,
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(width: 3.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        for (int i = 0; i < _workingPlaceControllers.length; i++)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      controller: _workingPlaceControllers[i],
                                      decoration: InputDecoration(
                                        labelText: 'Working Place ${i + 1}',
                                        labelStyle: TextStyle(color: Colors.black),
                                        prefixIcon: Icon(Icons.local_hospital, color: Colors.black),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: BorderSide(
                                            width: 3.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: BorderSide(width: 3.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_workingPlaceControllers.length > 1)
                                    IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      onPressed: () {
                                        setState(() {
                                          _workingPlaceControllers.removeAt(i);
                                        });
                                      },
                                    ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle),
                                    onPressed: () {
                                      setState(() {
                                        _workingPlaceControllers.add(TextEditingController());
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        TextFormField(
                          cursorColor: Colors.black,
                          controller: _universityController,
                          decoration: InputDecoration(
                            labelText: 'University Graduated From',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(FontAwesomeIcons.university, color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                width: 3.0,
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(width: 3.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          height: 60,
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 3),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.black),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );

                                  if (pickedDate != null && pickedDate != _selectedGraduationDate) {
                                    setState(() {
                                      _selectedGraduationDate = pickedDate;
                                    });
                                  }
                                },
                                child: Text(
                                  _selectedGraduationDate != null
                                      ? 'Year: ${_selectedGraduationDate!.year}'
                                      : 'Select Graduated Year',
                                  style: TextStyle(color: Colors.black, fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          height: 60,
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 3),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.picture_as_pdf, color: Colors.black),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () async {
                                  String? pickedPDF = await _pickPDF();
                                  if (pickedPDF != null) {
                                    setState(() {
                                      _pdfController.text = pickedPDF;
                                    });
                                  }
                                },
                                child: Text(
                                  _pdfController.text.isNotEmpty
                                      ? 'PDF Uploaded'
                                      : 'Upload PHD Or Master',
                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15),
                        isNext ? CircularProgressIndicator(color: Colors.blue,):ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isNext = true;
                            });
                            await _saveDoctorInfo();
                            setState(() {
                              isNext = false;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoadingPage(destinationPage: MainDocPage(userId: widget.userId)),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            minimumSize: Size(200.0, 50.0),
                          ),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//how to retrieve working places
// Future<List<String>> getWorkingPlaces() async {
//   List<String> workingPlaces = [];
//
//   try {
//     // Get the current user
//     User? user = _auth.getCurrentUser();
//
//     if (user != null) {
//       // Create a reference to the doctors collection
//       CollectionReference doctorsCollection = FirebaseFirestore.instance.collection('doctors');
//
//       // Get the document for the current user
//       DocumentSnapshot doctorDoc = await doctorsCollection.doc(user.uid).get();
//
//       if (doctorDoc.exists) {
//         // Retrieve the working places from the document
//         workingPlaces = List<String>.from(doctorDoc.get('workingPlaces'));
//       }
//     }
//   } catch (e) {
//     print('Error retrieving working places: $e');
//     // Handle the error
//   }
//
//   return workingPlaces;
// }