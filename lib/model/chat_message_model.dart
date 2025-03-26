import 'package:hive/hive.dart';

part 'chat_message_model.g.dart'; // Auto-generated file

@HiveType(typeId: 0) // Unique type ID
class ChatMessageModel {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final String sender; // "user" or "bot"

  @HiveField(2)
  final DateTime timestamp;

  ChatMessageModel({required this.text, required this.sender, required this.timestamp});
}