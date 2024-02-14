import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wecare/screens/doctor/components/custom_testformfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

TextEditingController medName = TextEditingController();
TextEditingController medDose = TextEditingController();
TextEditingController medTimes = TextEditingController();
GlobalKey<FormState> formState = GlobalKey<FormState>();
CollectionReference patients =
    FirebaseFirestore.instance.collection('patients');
String? validator(value) {
  if (value == "") return "empty field";
  return null;
}

modalSheetBuilder(
    BuildContext context, String patient, int size, Function setState) {
  return (context) => SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: formState,
              child: Column(
                children: [
                  CustomTextFormField(
                      hintText: "Enter drug name",
                      myController: medName,
                      validator: validator),
                  CustomTextFormField(
                      hintText: "Enter drug dose",
                      myController: medDose,
                      validator: validator),
                  CustomTextFormField(
                      hintText: "Enter drug times",
                      myController: medTimes,
                      validator: validator),
                  TextButton(
                      onPressed: () {
                        addMed(context, patient, size);
                        setState(() {});
                      },
                      child: const Text('Add med'))
                ],
              ),
            )),
      );
}

// error linked hashmap
// should be fixed
addMed(context, patient, size) {
  patients.doc(patient).update({
    'meds': FieldValue.arrayUnion([
      {'dose': medDose.text, 'name': medName.text, 'times': medTimes.text}
    ])
  }).then((value) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Drug Added',
      desc: 'Drug successfully added to to the patient',
      onDismissCallback: (type) => Navigator.of(context).pop(),
    ).show();
  }).catchError((error) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'error',
      desc: error,
      onDismissCallback: (type) => Navigator.of(context).pop(),
    ).show();
  });
}
