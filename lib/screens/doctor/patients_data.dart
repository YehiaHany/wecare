// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PatientsDataPage extends StatefulWidget {
  const PatientsDataPage({super.key, required this.dr});
  final String dr;
  @override
  // ignore: no_logic_in_create_state
  State<PatientsDataPage> createState() => _PatientsDataPageState(dr: dr);
}

class _PatientsDataPageState extends State<PatientsDataPage> {
  String? mail = FirebaseAuth.instance.currentUser?.email;
  final String dr;
  List<QueryDocumentSnapshot> data = [];

  _PatientsDataPageState({required this.dr});
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("patients")
        .where('Drssn', isEqualTo: dr)
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.background,
        title: const Text("all patients data"),
      ),
      body: ListView.builder(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(10),
        itemCount: data.length,
        prototypeItem: Card(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: const Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("a"),
                    Text("b"),
                    Text("c"),
                    Text("d"),
                  ]),
            ),
          ),
        itemBuilder: (context, i) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${data[i]["username"]}"),
                    Text("${data[i]["gender"]}"),
                    Text("${data[i]["phonenumber"]}"),
                    Text("${data[i]["age"]}"),
                  ]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        onPressed: () => Navigator.of(context).pushNamed('addcategory'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
