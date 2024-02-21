import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:wecare/screens/patient/patient_firebase_functions.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  FirebaseInterface F = new FirebaseInterface();

  String doctor_id = 'GEwjhsBNgpfZqvmcWtxZDOh9Sdm2';
  String patient_id = '26q6nWwawl2tIxk12Zi1';
  String chat_id = '';

  List<types.Message> _messages = [];
  List<types.TextMessage> messages_list = [];
  Map firebaseData = {};

  int last_id = 0;

  final doctor_user = const types.User(
    id: 'GEwjhsBNgpfZqvmcWtxZDOh9Sdm2',
  );

  final patient_user = const types.User(
    id: '26q6nWwawl2tIxk12Zi1',
  );

  Future<Map> getContactMessages() async{
    firebaseData = await F.getMessagesFromFirebase('26q6nWwawl2tIxk12Zi1', 'GEwjhsBNgpfZqvmcWtxZDOh9Sdm2');
    chat_id = firebaseData['chat_id'];
    _loadMessages(firebaseData['messages']);
    return firebaseData;
  }


  void _addMessage(types.Message message) {

    setState(() {});
  }

  void _handleSendPressed(types.PartialText message) async{
    final textMessage = types.TextMessage(
      author: patient_user,
      id: (last_id + 1).toString(),
      text: message.text,
    );

    last_id += 1;
    //_messages.insert(0, textMessage);
    messages_list.add(textMessage);
    F.updateMessages(patient_id, doctor_id, chat_id, messages_list);
    setState(() {});
  }



  void _loadMessages(List retrieved_firebase_messages) async {

    print(retrieved_firebase_messages);

    for(int i=retrieved_firebase_messages.length-1; i>=0; i--){
      types.TextMessage single_message = types.TextMessage(
        author: retrieved_firebase_messages[i]['sender'] == 'doctor'? doctor_user : patient_user,
        id: (i - retrieved_firebase_messages.length + 2).toString(),
        text: retrieved_firebase_messages[i]['content']
      );

      last_id = i - retrieved_firebase_messages.length + 2;
      messages_list.add(single_message);
    }

    _messages = messages_list.cast<types.Message>();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<dynamic, dynamic>>(
        future: getContactMessages(),
        builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(),
              body: Chat(
                messages: _messages,
                onSendPressed: _handleSendPressed,
                showUserAvatars: true,
                showUserNames: true,
                user: patient_user,
                theme: const DefaultChatTheme(
                  seenIcon: Text(
                    'read',
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}
