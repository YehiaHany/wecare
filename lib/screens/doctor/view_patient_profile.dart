// 'workingPlaces': _workingPlaceControllers
//             .map((controller) => controller.text)
//             .toList(),

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

CollectionReference patients =
    FirebaseFirestore.instance.collection('patients');

List<Widget> buildMeds(List<dynamic> meds) {
  List<Widget> medsWidget = [];

  meds.forEach((element) {
    medsWidget.add(ListTile(
      // leading: Text("${element}"),
      title: Text("${element["name"]}"),
      trailing: Text("${element["dose"]}"),
    ));
  });
  return medsWidget;
}

class PatientProfile extends StatelessWidget {
  final String patient;
  const PatientProfile({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: patients.doc(patient).get(),
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
                  child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Center(
                              child: ClipOval(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.blue[900],
                                  child: imageUrl.isNotEmpty
                                      ? Image.network(imageUrl,
                                          fit: BoxFit.contain)
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("name:"),
                                        Text("${data['username']}")
                                      ]),
                                  Flex(
                                      direction: Axis.horizontal,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("gender:"),
                                        Text("${data['gender']}")
                                      ]),
                                  Flex(
                                      direction: Axis.horizontal,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("phone"),
                                        Text("${data['phonenumber']}")
                                      ]),
                                  Column(children: buildMeds(meds))

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
                      )),
                ),
              ));
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
