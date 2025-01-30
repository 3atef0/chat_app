import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/constants/constans.dart';
import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/cubits/chat_cubit/chat_states.dart';
import 'package:chat_app/features/authentications/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String?;

    if (email == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
        ),
        body: const Center(
          child: Text("No email provided!"),
        ),
      );
    }

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ChatError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Error"),
            ),
            body: Center(
              child: Text("Error: ${state.error}"),
            ),
          );
        } else if (state is ChatSuccess) {
          final messages = state.messages;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.grey,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Chat",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<ChatCubit>().signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return message.id == email
                          ? ChatBubble(message: message)
                          : ChatBubbleForFriend(message: message);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (data) {
                      if (data.trim().isNotEmpty) {
                        context
                            .read<ChatCubit>()
                            .sendMessage(data.trim(), email);
                        _controller.clear();
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: AppColors.darkBlueGreen),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          final data = _controller.text.trim();
                          if (data.isNotEmpty) {
                            context.read<ChatCubit>().sendMessage(data, email);
                            _controller.clear();
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          color: AppColors.darkBlueGreen,
                        ),
                      ),
                      hintText: "Send Message",
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text("No messages yet."),
            ),
          );
        }
      },
    );
  }
}
