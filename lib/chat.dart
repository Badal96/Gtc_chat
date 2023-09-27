import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtc_chat/auth.dart';

class ChatPage extends StatefulWidget {
  final User user;
  const ChatPage({required this.user, super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.email!), actions: [
        IconButton(
            onPressed: () {
              showAlertDialog(context, Auth().signOut,
                  'Are you sure you want to sign out?');
            },
            icon: const Icon(Icons.logout)),
      ]),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: StreamBuilder(
              stream: db.collection('Gtcchat').snapshots(),
              builder: (context, snapshots) {
                if (snapshots.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List messages = List.from(snapshots.data!.docs);

                messages.sort((a, b) =>
                    (a.data()['created'] as Timestamp)
                        .compareTo(b.data()['created'] as Timestamp) *
                    -1);

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var data = messages[index].data();
                    var messageid = messages[index].id;
                    return messageTile(
                        messageid,
                        data['messages'],
                        data['from'],
                        (data['created'] as Timestamp).toDate(),
                        widget.user);
                  },
                );
              }),
        ),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(flex: 6, child: inputField()),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send),
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }

  void sendMessage() async {
    String messageText = messageController.text;

    if (messageText.isNotEmpty) {
      await db.collection('Gtcchat').add({
        'messages': messageController.text,
        'from': widget.user.email!,
        'created': Timestamp.fromDate(DateTime.now())
      });

      messageController.clear();
    }
  }

  Widget inputField() {
    return TextField(
      controller: messageController,
      decoration: const InputDecoration(
        hintText: 'Type Here...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }

  Widget messageTile(
      String messageid, String text, String from, DateTime date, User user) {
    bool iscurrentuser = from == user.email;
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      width: MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: iscurrentuser ? Colors.green : Colors.blue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'from $from      ${date..toIso8601String()}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
          iscurrentuser
              ? IconButton(
                  onPressed: () {
                    showAlertDialog(
                        context,
                        db.collection('Gtcchat').doc(messageid).delete,
                        'delete message?');
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                  iconSize: 19,
                )
              : Container(),
        ],
      ),
    );
  }
}

showAlertDialog(
    BuildContext context, Future<void> Function() ontap, String text) {
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    onPressed: () {
      ontap();
      Navigator.of(context).pop();
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: Text(text),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
