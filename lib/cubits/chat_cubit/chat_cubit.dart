import 'package:chat_app/cubits/chat_cubit/chat_states.dart';
import 'package:chat_app/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  Future<void> sendMessage(String message, String email) async {
    try {
      await messages.add({
        'message': message,
        'createdAt': DateTime.now(),
        'id': email,
      });
    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }

  void fetchMessages() {
    emit(ChatLoading());
    messages.orderBy('createdAt', descending: true).snapshots().listen((event) {
      List<MessageModel> messageList =
          event.docs.map((doc) => MessageModel.fromJson(doc)).toList();
      emit(ChatSuccess(messageList));
    }, onError: (error) {
      emit(ChatError(error.toString()));
    });
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }
}
