import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? username;
  final int? age;
  final String? email;
  final String? phonenumber;
  final String? gender;
  final String? password;
  final String? profileImage;


  UserModel({this.username,this.age, this.email, this.phonenumber, this.gender, this.password, this.profileImage});


  static UserModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    return UserModel(
      username: snapshot['username'],
      age: snapshot['age'],
      email: snapshot['email'],
      password: snapshot['password'],
      phonenumber: snapshot['phonenumber'],
      gender: snapshot['gender'],
      profileImage: snapshot['pprofileImage'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "username": username,
      "age": age,
      "password": password,
      "email": email,
      "phonenumber": phonenumber,
      "gender": gender,
      "profileImage": profileImage,

    };
  }
}