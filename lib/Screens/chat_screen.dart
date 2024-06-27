import 'dart:ffi';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;


final _firestore = FirebaseFirestore.instance;
User? signedInUser;

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final record=AudioRecorder();
  bool is_record=false;
  String path='';
  String url='';
start_record()async{

 final location = await getApplicationDocumentsDirectory();
  String name = Uuid().v1();
  path = p.join(location.path, '$name.m4a');
if(await record.hasPermission()){
  await record.start(RecordConfig(), path: path);
  setState(() {
    is_record=true;
  });


}
  print('Start recording at $path');
}

stop_record()async{

await record.stop();

  setState(() {
    is_record=false;
 
  });
  print('Stop recording at $path');
  await upload();
}



  
Future<void> upload() async {
  File file = File(path);
  if (!file.existsSync()) {
    print('Error: File does not exist at path: $path');
    return;
  }

  String name = p.basename(path);
  print('Uploading file: $name');

  final ref = FirebaseStorage.instance.ref('voice/$name');
  try {
    await ref.putFile(file);
    String downloadUrl = await ref.getDownloadURL();
    setState(() {
      url = downloadUrl;
    });
    print('Uploaded successfully. Download URL: $downloadUrl');
    
    // Send message with the audio URL
    sendMessage(audioUrl: downloadUrl);
  } catch (e) {
    print('Error during file upload: $e');
  }
}


  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          signedInUser = user;
        });
        print(signedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

void sendMessage({String? text, String? audioUrl}) {
  if (signedInUser != null) {
    messageTextController.clear();
    _firestore.collection('messages').add({
      if (text != null) 'text': text,
      if (audioUrl != null) 'audioUrl': audioUrl,
      'sender': signedInUser!.email,
      'time': FieldValue.serverTimestamp(),
    });
  } else {
    print('User is not signed in');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 150, 149, 147),
        title: Row(
          children: [
            Image.asset(
              'lib/images/chat.png',
              height: 25,
            ),
            SizedBox(width: 10),
            Text(
              "ContactMe",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: 
               
                  IconButton(
                    icon: is_record?Icon(Icons.stop):Icon(Icons.mic),
                    onPressed: () {
if(!is_record){
  start_record();
}else{
  stop_record();
}
                    },
                    
                  ),
                                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy("time").snapshots(),
      builder: (context, snapshot) {
        List<MessageLine> messageWidgets = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
   final messages = snapshot.data!.docs.reversed;
for (var message in messages) {
  final messageAudioUrl = message.get('audioUrl') as String?;
  final messageSender = message.get('sender');
  final currentUser = signedInUser?.email;
  final messageWidget = MessageLine(
    sender: messageSender,
    audioUrl: messageAudioUrl,
    isMe: currentUser == messageSender,
  );
  messageWidgets.add(messageWidget);
}

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageLine extends StatelessWidget {
   const MessageLine({
    super.key,
    required this.sender,
    this.text,
    this.audioUrl,
    required this.isMe,
  });

 final String sender;
  final String? text;
  final String? audioUrl;
  final bool isMe;


@override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
      bool isPlaying = false;


    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
          Material(
            borderRadius: BorderRadius.circular(10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   VoiceMessageView(
                      controller: VoiceController(
                        audioSrc:audioUrl!,
                        maxDuration: const Duration(seconds:10),
                        isFile: false,
                        onComplete: () {
                        },
                        onPause: () {
                        },
                        onPlaying: () {
 player.play();
                         },
                        onError: (err) {
                        },
                      ),
              )],
              ),
            ),
          ),
          
        ],
        
      ),
      
    );
  
  }
  
}

