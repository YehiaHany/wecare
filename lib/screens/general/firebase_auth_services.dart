import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
import 'package:wecare/screens/general/toast.dart';
import 'package:wecare/screens/general/usermodel.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ignore: non_constant_identifier_names
  Future<User?> signUpWithEmailAndPassword(
      String email,
      String password,
      String username,
      String phonenumber,
      String gender,
      int age,
      // ignore: non_constant_identifier_names
      bool is_doctor,
      [File? image]) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await credential.user!.updateDisplayName(username);
      String userId = credential.user!.uid;
      String collectionName = is_doctor ? 'doctors' : 'patients';
      String downloadUrl = '';
      if (image != null) {
        downloadUrl = await _uploadImageToStorage(image, userId);
      }
      _createData(
          UserModel(
            username: username,
            age: age,
            gender: gender,
            email: email,
            password: password,
            phonenumber: phonenumber,
            profileImage: downloadUrl,
          ),
          collectionName,
          userId);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: e.code);
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: e.code);
      }
    }
    return null;
  }

  void _createData(UserModel userModel, String collectionName, String id) {
    final userCollection =
        FirebaseFirestore.instance.collection(collectionName);

    final newUser = UserModel(
      username: userModel.username,
      age: userModel.age,
      email: userModel.email,
      phonenumber: userModel.phonenumber,
      gender: userModel.gender,
      password: userModel.password,
      profileImage: userModel.profileImage,
    ).toJson();

    userCollection.doc(id).set(newUser);
  }

  Future<String> _uploadImageToStorage(File image, String userId) async {
    // ignore: unnecessary_null_comparison
    if (image != null) {
      final path = 'images/$userId.png';
      final ref = FirebaseStorage.instance.ref().child(path);
      UploadTask? uploadTask = ref.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      return urlDownload;
    } else {
      return ''; // Return an empty string if no image is provided
    }
  }
}
