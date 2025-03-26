import '../views/components/chat_message.dart';

abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<ChatMessage> messages;
  ChatLoadedState(this.messages);
}