import 'package:hive/hive.dart';

part 'chat_message_model.g.dart'; // This is generated automatically

@HiveType(typeId: 0) // Ensure typeId is unique
class ChatMessageModel extends HiveObject {
  @HiveField(0)
  final String message;

  @HiveField(1)
  final String sender;

  @HiveField(2)
  final DateTime timestamp;

  ChatMessageModel(
      {required this.message, required this.sender, required this.timestamp});
}
