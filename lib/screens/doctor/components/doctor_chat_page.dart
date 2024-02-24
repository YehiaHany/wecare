import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wecare/screens/patient/patient_firebase_functions.dart';

class DoctorChatPage extends StatefulWidget {
  const DoctorChatPage({super.key});

  @override
  State<DoctorChatPage> createState() => _DoctorChatPageState();
}

class _DoctorChatPageState extends State<DoctorChatPage> {
  TextEditingController messageController = TextEditingController();
  ScrollController chatScroll = ScrollController();
  DateTime now = DateTime.now();

  String chatID = '';
  String patientID = '';
  String doctorID = '';
  String patientName = '';
  Map<String, dynamic> retrievedMessagesData = {};
  List messages = [];
  FirebaseInterface F = new FirebaseInterface();

  Future<Map> getContactMessages() async{
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    patientID = arguments['patient_id'];
    doctorID = arguments['doctor_id'];
    patientName = arguments['patient_name'];
    List retrievedData = await F.messagesOfSpecificContactForDoctor(patientID, doctorID);
    chatID = retrievedData[0];
    retrievedMessagesData = retrievedData[1];
    messages = retrievedMessagesData['messages'];
    return retrievedMessagesData;
  }

  /*
  List messages = [
    {
      'sender': 'patient',
      'content': 'I would like to revise my prescription.',
      'time': '10:20',
    },
    {
      'sender': 'doctor',
      'content': 'Why?',
      'time': '10:21',
    },
    {
      'sender': 'patient',
      'content': 'Because I am on new skin treatment meds and I am not sure it is compatible with the meds in my prescription.',
      'time': '10:22',
    },
    {
      'sender': 'doctor',
      'content': 'Well then send me the original prescription and the names of your new meds.',
      'time': '10:23',
    },
    {
      'sender': 'patient',
      'content': 'Ok I will text you back as soon as I return home.',
      'time': '10:24',
    },
  ];

   */

  Widget createPatientMessage(message){
    return Row(
      children: [
        Container(
          width: 300,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message['content']),
                  Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Text(message['time']),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }

  Widget createDoctorMessage(message){
    return Row(
      children: [
        Expanded(
          child: Container(),
        ),
        Container(
          width: 300,
          child: Card(
            color: Colors.pinkAccent,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['content'],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        message['time'],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget createMessage(message){
    if(message['sender'] == 'doctor'){
      return createDoctorMessage(message);
    }
    return createPatientMessage(message);
  }

  void updateTime(Timer timer){
    setState(() {
      now = DateTime.now();
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), updateTime);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<dynamic, dynamic>>(
        future: getContactMessages(),
        builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_outlined),
                    ),
                    Text(patientName),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          controller: chatScroll,
                          child: Container(
                            child: Column(
                              children: messages.map((message) => createMessage(message)).toList(),
                            ),
                          ),
                        ),
                      )
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () async{
                            if(messageController.text != ''){
                              Map newMessage = {
                                'sender': 'doctor',
                                'content': messageController.text,
                                'time': '${now.hour}:${now.minute}',
                              };

                              messageController.text = '';
                              messages.add(newMessage);
                              retrievedMessagesData['messages'] = messages;
                              await F.updateContactMessages(retrievedMessagesData, chatID);

                              setState(() {});
                              chatScroll.jumpTo(chatScroll.position.maxScrollExtent);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}

