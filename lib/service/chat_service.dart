import 'package:hive/hive.dart';
import 'package:spring_ai_agent/model/chat_message_model.dart';
import '../views/components/chat_message.dart';

class ChatService {
  late Box<ChatMessageModel> _chatBox;

  ChatService() {
    _initializeBox();
  }

  Future<void> _initializeBox() async {
    if (!Hive.isBoxOpen('chat_messages')) {
      _chatBox = await Hive.openBox<ChatMessageModel>('chat_messages');
    } else {
      _chatBox = Hive.box<ChatMessageModel>('chat_messages');
    }
  }

  Future<List<ChatMessageModel>> getMessages() async {
    if (!Hive.isBoxOpen('chat_messages')) {
      await _initializeBox();
    }
    return _chatBox.values.toList();
  }

  Future<void> addMessage(ChatMessageModel message) async {
    if (!Hive.isBoxOpen('chat_messages')) {
      await _initializeBox(); // Ensure box is initialized
    }

    _chatBox = Hive.box<ChatMessageModel>(
        'chat_messages'); // Re-assign _chatBox if needed
    await _chatBox.add(message);
  }

  Future<void> clearMessages() async {
    if (!Hive.isBoxOpen('chat_messages')) {
      await _initializeBox();
    }
    await _chatBox.clear();
  }
}
