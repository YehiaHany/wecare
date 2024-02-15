// 'workingPlaces': _workingPlaceControllers
//             .map((controller) => controller.text)
//             .toList(),

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'add_meds.dart';

CollectionReference patients =
    FirebaseFirestore.instance.collection('patients');

class PatientProfile extends StatefulWidget {
  final String patient;
  const PatientProfile({super.key, required this.patient});

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  List<Widget> buildMeds(List<dynamic> meds, Function setState) {
    List<Widget> medsWidget = [];

    meds.forEach((element) {
      medsWidget.add(Dismissible(
        key: Key(element.toString()),
        child: ListTile(
          // leading: Text("${element}"),
          title: Text("${element["name"]}"),
          subtitle: Text("${element["dose"]}"),
          trailing: Text("${element["times"]}"),
        ),
        onDismissed: (direction) {
          setState(() {
            medsWidget.remove(element);
          });

          patients.doc(widget.patient).update({
            'meds': FieldValue.arrayRemove([
              {
                'dose': element["dose"],
                'name': element["name"],
                'times': element["times"]
              }
            ])
          }).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${element['name']} dismissed')));
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error deleting ${element['name']}')));
          });
        },
      ));
    });
    return medsWidget;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: patients.doc(widget.patient).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          String imageUrl = data['profileImage'];
          List<dynamic> meds = data['meds'];
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue[900],
              foregroundColor: Theme.of(context).colorScheme.background,
              title: Text("${data['username']}"),
            ),
            body: SafeArea(
              child: Container(
                margin: const EdgeInsets.fromLTRB(5, 5, 5, 20),
                child: Column(
                  children: [
                    Center(
                      child: ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.blue[900],
                          child: imageUrl.isNotEmpty
                              ? Image.network(imageUrl, fit: BoxFit.contain)
                              : const SizedBox(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("name:"),
                                Text("${data['username']}")
                              ]),
                          Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("gender:"),
                                Text("${data['gender']}")
                              ]),
                          Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("phone"),
                                Text("${data['phonenumber']}")
                              ]),
                          Column(children: buildMeds(meds, setState))

                          // ListView.builder(
                          //   itemCount: meds.length,
                          //   itemBuilder: (context, index) => ListTile(
                          //     leading: Text("$index"),
                          //     title: Text("${meds[index]["name"]}"),
                          //     trailing: Text("${meds[index]["dose"]}"),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue[900],
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: modalSheetBuilder(
                        context, widget.patient, meds.length, setState));
              },
              child: const Icon(Icons.medication_liquid_rounded),
            ),
          );
        }

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(50),
            child: SpinKitCubeGrid(
              color: Colors.blue[900],
              duration: const Duration(seconds: 2),
            ),
          ),
        );
      },
    );
  }
}
