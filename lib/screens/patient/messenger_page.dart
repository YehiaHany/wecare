import 'package:flutter/material.dart';
import 'package:wecare/screens/patient/patient_firebase_functions.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({super.key});

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {

  List contacts = [];
  FirebaseInterface F = new FirebaseInterface();

  Future<List> getContacts() async{
    contacts = await F.getChatContacts('26q6nWwawl2tIxk12Zi1');
    return contacts;
  }

  /*
  List<Map> contacts = [
    {
      'first_name': 'Juan',
      'last_name': 'Cervantes',
      'Id': '35f623f2',
      'image_url': 'https://static.wikia.nocookie.net/mindyourlanguage/images/4/4f/Juan_Cervantes.jpg/revision/latest/thumbnail/width/360/height/360?cb=20191207161808',
      'last_message': 'Send me a photo of the bottle.',
      'you_last': false,
    },
    {
      'first_name': 'Maria',
      'last_name': 'Almeida',
      'Id': '7898jh7jhb9yg7',
      'image_url': 'https://cdn-images.kyruus.com/providermatch/umiami/photos/200/bastos-maria-1861625378.jpg',
      'last_message': 'I broke my back.',
      'you_last': true,
    },
    {
      'first_name': 'Ali',
      'last_name': 'Rezai',
      'Id': 'c26835r93',
      'image_url': 'https://miro.medium.com/v2/resize:fit:679/1*S-231RWlCztUPIi72QEy9Q.jpeg',
      'last_message': 'I am dying.',
      'you_last': true,
    },
    {
      'first_name': 'Andrew',
      'last_name': 'Rochford',
      'Id': '32910x9h417934s',
      'image_url': 'https://www.digitalwellness.com/media/02lfeu4r/drandrew_headbanner_image_600px.jpg',
      'last_message': 'You did not pay the bill.',
      'you_last': false,
    },
  ];
  */

  Widget chatHead(contact){
    String message_header = '';
    if(contact['messages'].last['sender'] == 'patient') {
      message_header = 'You: ';
    } else {
      message_header = 'Dr.${contact['last_name']}: ';
    }

    return Card(
      color: Colors.grey[100],
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/chat', arguments: {
            'patient_id': '26q6nWwawl2tIxk12Zi1',
            'doctor_id': contact['doctor_id'],
          });
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(contact['image_url']),
                radius: 30.0,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Dr. ' + contact['first_name'] + ' ' + contact['last_name'],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(message_header + contact['messages'].last['content']),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getContacts(),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                title: Text('Messages'),
              ),
              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: contacts.map((contact) => chatHead(contact)).toList(),
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
