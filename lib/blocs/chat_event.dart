import '../model/chat_message_model.dart';

abstract class ChatEvent {}

class LoadMessagesEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;
  SendMessageEvent(this.message);
}