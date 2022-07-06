import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';

class ChatWidget extends StatelessWidget {
  String uid;
  ChatWidget(this.uid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data!.docs;
          List<types.Message> msg = [];
          for (int i = 0; i < data.length; i++) {
            msg.add(types.TextMessage(
              author: types.User(id: FirebaseAuth.instance.currentUser!.uid),
              text: data[i]["message"],
              createdAt: DateTime.now().millisecondsSinceEpoch,
              id: const Uuid().v4(),
            ));
          }
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .where("to_id",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (_,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshot2) {
                if (snapshot2.hasData) {
                  var data2 = snapshot2.data!.docs;
                  List<types.Message> msg2 = [];
                  for (int i = 0; i < data2.length; i++) {
                    msg2.add(types.TextMessage(
                      author: types.User(id: data2[i]["uid"]),
                      text: data2[i]["message"],
                      createdAt: DateTime.parse(data2[i]["timestamp"])
                          .millisecondsSinceEpoch,
                      id: const Uuid().v4(),
                    ));
                  }

                  return Chat(
                    showUserAvatars: true,
                    showUserNames: true,
                    onSendPressed: (partialText) async {
                      await FirebaseFirestore.instance.collection("chats").add({
                        "uid": FirebaseAuth.instance.currentUser!.uid,
                        "to_id": uid,
                        "message": partialText.text,
                        "timestamp": DateTime.now().toString(),
                      });
                    },
                    user:
                        types.User(id: FirebaseAuth.instance.currentUser!.uid),
                    messages: List.from(msg)..addAll(msg2),
                  );
                } else {
                  return Container();
                }
              });
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text(snapshot.error.toString()));
        }
      },
    );
  }
}
