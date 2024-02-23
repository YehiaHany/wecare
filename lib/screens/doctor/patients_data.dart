// ignore_for_file: use_build_context_synchronously, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wecare/screens/doctor/components/doctor_chat_page.dart';
import 'package:wecare/screens/doctor/view_patient_profile.dart';

import '../signin/signin.dart';

class PatientsDataPage extends StatefulWidget {
  const PatientsDataPage({super.key, required this.dr});
  final String dr;
  @override
  // ignore: no_logic_in_create_state
  State<PatientsDataPage> createState() => _PatientsDataPageState();
}

class _PatientsDataPageState extends State<PatientsDataPage> {
  String? mail = FirebaseAuth.instance.currentUser?.email;
  // final String dr;
  List<QueryDocumentSnapshot> data = [];

  late Future<dynamic> patients;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("patients")
        .where('dreid', isEqualTo: widget.dr)
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  buildPatients() async {
    List<Widget> temp = [];
    await getData();
    String capitalize(String input) {
      if (input == null || input.isEmpty) {
        return input;
      }

      List<String> words = input.split(" ");
      for (int i = 0; i < words.length; i++) {
        if (words[i].isNotEmpty) {
          words[i] = words[i][0].toUpperCase() + words[i].substring(1);
        }
      }

      return words.join(" ");
    }

    data.forEach((datai) {
      String username = datai["username"];
      username = capitalize(username);
      String imageUrl = datai['profileImage'];
      temp.add(Container(
        margin: const EdgeInsets.only(top: 10),
        child: InkWell(
          onTap: () {
            print('you pressed on ${datai["username"]} with id ${datai.id}');
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PatientProfile(patient: datai.id)));
          },
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            tileColor: Colors.blue.shade700,
            title: Center(child: Text("${username}",style: TextStyle(color: Colors.white),)),
            // title: Text("${datai["phonenumber"]}"),
            // subtitle: Text("${datai["gender"]}"),
            // leading: Text("${datai["username"]}",style: TextStyle(fontSize: 15),),
            leading:imageUrl.isNotEmpty
                ? CircleAvatar(
              backgroundColor: Colors.white,
              radius: 29,
              backgroundImage: NetworkImage(imageUrl), // Replace with your image URL
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            )

                : const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.person,
              size: 20,
              color: Colors.white,
            ),
          ),
            trailing:GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/d_chat', arguments: {
                    'patient_id': datai.id,
                    'doctor_id': widget.dr,
                    'patient_name': username,
                  }
                );
              },
              child: Icon(FontAwesomeIcons.signalMessenger,color: Colors.white,),
            ),
            // trailing:Text("${datai["age"]}"),
          ),
        ),
      ));
    });
    return temp;
  }

  @override
  void initState() {
    super.initState();
    patients = buildPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   foregroundColor: Theme.of(context).colorScheme.background,
      //   title: const Text("Patients data"),
      // ),
      body: Center(
        child: FutureBuilder<dynamic>(
          future: patients,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SafeArea(
                child: Container(
                  color: Colors.blue[150],
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Card(
                    elevation: 20,
                    color: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: snapshot.hasData && snapshot.data!.isNotEmpty
                        ? ListView(
                      padding: const EdgeInsets.all(10),
                      children: snapshot.data!,
                    )
                        : Center(
                      child: Text(
                        'No data to display',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
      // body: ListView(padding: const EdgeInsets.all(10), children: patients),

      // body: ListView.builder(
      //   clipBehavior: Clip.antiAlias,
      //   padding: const EdgeInsets.all(10),
      //   itemCount: data.length,
      //   prototypeItem: Card(
      //     child: Container(
      //       padding: const EdgeInsets.all(15),
      //       child: const Flex(
      //           direction: Axis.horizontal,
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text("a"),
      //             Text("b"),
      //             Text("c"),
      //             Text("d"),
      //           ]),
      //     ),
      //   ),
      //   itemBuilder: (context, i) {
      //     return Card(
      //       child: Container(
      //         padding: const EdgeInsets.all(15),
      //         child: Flex(
      //             direction: Axis.horizontal,
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text("${data[i]["username"]}"),
      //               Text("${data[i]["gender"]}"),
      //               Text("${data[i]["phonenumber"]}"),
      //               Text("${data[i]["age"]}"),
      //             ]),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
