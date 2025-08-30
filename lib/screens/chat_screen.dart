import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  static String id = 'ChatScreen';
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessageCollection,
  );
  TextEditingController controller = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(MessageModel.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(kLogo, height: 50),
                  Text('Chat', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, indx) {
                      return messagesList[indx].id == email
                          ? ChatBuble(message: messagesList[indx])
                          : ChatBubleToFriend(message: messagesList[indx]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      if (data.isNotEmpty) {
                        messages.add({
                          kMessage: data,
                          kCreatedAt: DateTime.now(),
                          'id': email,
                        });
                        controller.clear();
                        _controller.animateTo(
                          0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'send Message',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, size: 30, color: kPrimaryColor),
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            messages.add({
                              kMessage: controller.text,
                              kCreatedAt: DateTime.now(),
                              'id': email,
                            });
                            controller.clear();
                            _controller.animateTo(
                              0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(body: Center(child: Text('Loading.....')));
        }
      },
    );
  }
}
