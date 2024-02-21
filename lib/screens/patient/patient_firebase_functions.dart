import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class FirebaseInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  FirebaseInterface();

  Future<Map<String, dynamic>>  getPatientInfo(String patient_id) async{
    CollectionReference patients = FirebaseFirestore.instance.collection('patients');

    try {
      DocumentSnapshot snapshot = await patients.doc(patient_id).get();

      if (!snapshot.exists) {
        return {};
      }

      return snapshot.data() as Map<String, dynamic>;
    }
    catch (e) {
      print("Error fetching patient data: $e");
      return {};
    }
  }

  Future<void> updatePatientInfo(Map<String, dynamic> new_data, String patient_id) async{
    CollectionReference patients = FirebaseFirestore.instance.collection('patients');

    try {
      await patients.doc(patient_id).update(new_data);
      print("Patient data updated successfully.");
    } catch (error) {
      print("Failed to update patient data: $error");
    }
  }

  Future<List> getChatContacts(String patient_id) async{
    CollectionReference contacts = FirebaseFirestore.instance.collection('messages');
    CollectionReference doctors = FirebaseFirestore.instance.collection('doctors');

    try {
      QuerySnapshot querySnapshot = await contacts.where('patient_id', isEqualTo: patient_id).get();
      List doctors_id = [];

      List<Map<String, dynamic>> contact_list = [];
      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          contact_list.add(doc.data() as Map<String, dynamic>);
          doctors_id.add(contact_list.last['doctor_id']);
        }
      });

      for (int i = 0; i < doctors_id.length; i++) {
        try {
          DocumentSnapshot snapshot = await doctors.doc(doctors_id[i]).get();
          Map doctor_data = snapshot.data() as Map<String, dynamic>;

          contact_list[i]['first_name'] = doctor_data['username'];
          contact_list[i]['last_name'] = doctor_data['username'];
          contact_list[i]['image_url'] = doctor_data['profileImage'];
        }
        catch (e) {
          print("Error related contact data: $e");
          contact_list[i]['first_name'] = '';
          contact_list[i]['last_name'] = '';
          contact_list[i]['image_url'] = '';
        }
      }

      return contact_list;
    } catch (e) {
      print("Error fetching contacts data: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>>  getMessagesFromFirebase(String patient_id, String doctor_id) async {
    CollectionReference messages = FirebaseFirestore.instance.collection('messages');
    String chatID = '';

    try {
      QuerySnapshot querySnapshot = await messages
          .where('patient_id', isEqualTo: patient_id)
          .where('doctor_id', isEqualTo: doctor_id)
          .get();

      // Extract data from QuerySnapshot
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      List<Map<String, dynamic>> dataList = [];

      // Extracting data from each document
      documents.forEach((doc) {
        chatID = doc.id;
        dataList.add(doc.data() as Map<String, dynamic>);
      });

      dataList[0]['chat_id'] = chatID;
      return dataList[0];
    } catch (e) {
      print("Error fetching messages from Firebase: $e");
      return {};
    }
  }

  Future<void> updateMessages(String patient_id, String doctor_id, String chat_id, List<types.TextMessage> updated_messages) async{
    CollectionReference messages = FirebaseFirestore.instance.collection('messages');
    Map <String, dynamic> updated_data = {};
    List messages_list = [];

    updated_data['patient_id'] = patient_id;
    updated_data['doctor_id'] = doctor_id;

    for(int i=0; i<updated_messages.length; i--){
      Map single_message = {
        'content': updated_messages[i].text,
        'sender': updated_messages[i].author.id == patient_id ? 'patient': 'doctor',
      };

      messages_list.add(single_message);
    }
    updated_data['messages'] = messages_list;

    print(updated_data);
    try {
      await messages.doc(chat_id).update(updated_data);
      print("messages data updated successfully.");
    } catch (error) {
      print("Failed to update messages data: $error");
    }
  }
}
