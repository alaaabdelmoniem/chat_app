import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  static String id = 'ChatScreen';

  TextEditingController controller = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;

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
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                var messagesList =
                    BlocProvider.of<ChatCubit>(context).messagesList;
                return ListView.builder(
                  reverse: true,
                  controller: _controller,
                  itemCount: messagesList.length,
                  itemBuilder: (context, indx) {
                    return messagesList[indx].id == email
                        ? ChatBuble(message: messagesList[indx])
                        : ChatBubleToFriend(message: messagesList[indx]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              onSubmitted: (data) {
                print(
                  'email : $email in chat screen before adding to collection',
                );

                if (data.isNotEmpty) {
                  BlocProvider.of<ChatCubit>(
                    context,
                  ).sendMessage(message: data, email: email);
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
                    print(
                      'email : $email before adding to collection and during click on send botton ',
                    );

                    if (controller.text.isNotEmpty) {
                      BlocProvider.of<ChatCubit>(
                        context,
                      ).sendMessage(message: controller.text, email: email);
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
  }
}
