import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/chat_message_model.dart';
import '../repositories/chat_repository.dart';
import '../views/components/chat_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc(this._chatRepository) : super(ChatInitialState()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  void _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    final messages = await _chatRepository.getLocalMessages();
    emit(ChatLoadedState(messages));
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is ChatLoadedState) {
      final List<ChatMessageModel> updatedMessages = List.from(currentState.messages);

      // Add user message
      final userMessage = ChatMessageModel(
        message: event.message,
        sender: "user",
        timestamp: DateTime.now(),
      );
      updatedMessages.insert(0, userMessage);
      emit(ChatLoadedState(updatedMessages));

      // Fetch bot response
      final botMessage = await _chatRepository.sendMessage(event.message);
      updatedMessages.insert(0, botMessage);
      emit(ChatLoadedState(updatedMessages));
    }
  }
}