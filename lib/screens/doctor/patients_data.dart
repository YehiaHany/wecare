// ignore_for_file: use_build_context_synchronously, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    temp.add(ElevatedButton(
      onPressed: () {
        print('you pressed on the dummy tile');
      },
      child: const ListTile(
        title: Text("username"),
        subtitle: Text("gender"),
        leading: Text("phone"),
        trailing: Text("age"),
      ),
    ));
    data.forEach((datai) {
      temp.add(Container(
        margin: const EdgeInsets.only(top: 10),
        child: ElevatedButton(
          onPressed: () {
            print('you pressed on ${datai["username"]}');
          },
          child: ListTile(
            title: Text("${datai["username"]}"),
            subtitle: Text("${datai["gender"]}"),
            leading: Text("${datai["phonenumber"]}"),
            trailing: Text("${datai["age"]}"),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Patients data"),
      ),
      body: FutureBuilder<dynamic>(
        future: patients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView(
                padding: const EdgeInsets.all(10), children: snapshot.data!);
          }
        },
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
