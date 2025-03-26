import 'package:hive/hive.dart';
import '../views/components/chat_message.dart';

class ChatService {
  late Box<ChatMessage> _chatBox;

  ChatService() {
    _initializeBox();
  }

  Future<void> _initializeBox() async {
    if (!Hive.isBoxOpen('chat_messages')) {
      _chatBox = await Hive.openBox<ChatMessage>('chat_messages');
    } else {
      _chatBox = Hive.box<ChatMessage>('chat_messages');
    }
  }

  Future<List<ChatMessage>> getMessages() async {
    await _initializeBox();
    return _chatBox.values.toList();
  }

  Future<void> addMessage(ChatMessage message) async {
    await _initializeBox();
    await _chatBox.add(message);
  }

  Future<void> clearMessages() async {
    await _initializeBox();
    await _chatBox.clear();
  }
}