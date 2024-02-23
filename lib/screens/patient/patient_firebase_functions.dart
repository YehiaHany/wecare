import 'dart:math';

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

  Future<Map> getContactsForPatient(String patientID) async{
    Map patientInfo = await getPatientInfo(patientID);
    String doctorID = patientInfo['dreid'];

    Map contact = {};

    CollectionReference doctors = FirebaseFirestore.instance.collection('doctors');
    try {
      DocumentSnapshot snapshot = await doctors.doc(doctorID).get();
      Map doctorData = snapshot.data() as Map<String, dynamic>;

      contact['doctor_name'] = doctorData['username'];
      contact['doctor_image_url'] = doctorData['profileImage'];
    }
    catch (e) {
      print("Error getting doctor data to create messenger contact: $e");
    }

    // searching firebase messages collection for contact
    CollectionReference messages = FirebaseFirestore.instance.collection('messages');
    try {
      QuerySnapshot querySnapshot = await messages
          .where('patient_id', isEqualTo: patientID)
          .where('doctor_id', isEqualTo: doctorID)
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      if(documents.length == 0){
        var random = Random();
        String randomId = DateTime.now().millisecondsSinceEpoch.toString() + random.nextInt(9999).toString();
        await messages.doc(randomId).set({
          'doctor_id': doctorID,
          'patient_id': patientID,
          'messages': [],
        });
        contact['chat_id'] = randomId;
        contact['last_sender'] = '';
        contact['last_message'] = 'Start a conversation';
      }
      else{
        documents.forEach((doc) {
          contact['chat_id'] = doc.id;
          Map chatDocument = doc.data() as Map<String, dynamic>;
          contact['last_sender'] = chatDocument['messages'].length > 0 ? chatDocument['messages'].last['sender'] : '';
          contact['last_message'] = chatDocument['messages'].length > 0 ? chatDocument['messages'].last['content'] : 'Start a conversation';
        });
      }

    } catch (e) {
      print("Error fetching messages from Firebase: $e");
    }

    return contact;
  }

  Future<Map> messagesOfSpecificContactForPatient(String chatID) async {
    CollectionReference messages = FirebaseFirestore.instance.collection(
        'messages');

    try {
      DocumentSnapshot snapshot = await messages.doc(chatID).get();

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

  Future<List> messagesOfSpecificContactForDoctor(String patientID, String doctorID) async {

    CollectionReference messages = FirebaseFirestore.instance.collection('messages');
    String chatID = '';

    try {
      QuerySnapshot querySnapshot = await messages
          .where('patient_id', isEqualTo: patientID)
          .where('doctor_id', isEqualTo: doctorID)
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      if(documents.length == 0){
        var random = Random();
        String randomId = DateTime.now().millisecondsSinceEpoch.toString() + random.nextInt(9999).toString();
        await messages.doc(randomId).set({
          'doctor_id': doctorID,
          'patient_id': patientID,
          'messages': [],
        });
        chatID = randomId;
      }
      else{
        documents.forEach((doc) {
          chatID = doc.id;
        });
      }
    } catch (e) {
      print("Error fetching messages from Firebase: $e");
    }

    List returnedData = [];
    returnedData.add(chatID);

    try {
      DocumentSnapshot snapshot = await messages.doc(chatID).get();

      if (!snapshot.exists) {
        return [];
      }

      returnedData.add(snapshot.data() as Map<String, dynamic>);
      return returnedData;
    }
    catch (e) {
      print("Error fetching patient data: $e");
      return [];
    }
  }

  Future<void> updateContactMessages(Map<String, dynamic> new_data, String chatID) async{
    CollectionReference messages = FirebaseFirestore.instance.collection('messages');

    try {
      await messages.doc(chatID).update(new_data);
    } catch (error) {
      print("Failed to send message: $error");
    }
  }

}
