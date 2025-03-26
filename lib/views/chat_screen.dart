import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/chat_bloc.dart';
import '../blocs/chat_event.dart';
import '../blocs/chat_state.dart';
import 'components/chat_message.dart';
import 'three_dots.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat"), backgroundColor: Colors.green[700]),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          List<ChatMessage> messages = [];
          bool isTyping = false;

          if (state is ChatLoadedState) {
            messages = state.messages;
          } else if (state is ChatLoadingState) {
            isTyping = true;
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) =>
                        _buildChatBubble(messages[index]),
                  ),
                ),
                if (isTyping) ThreeDotLoader(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTextComposer(context),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    return TextField(
      controller: _controller,
      onSubmitted: (_) => _sendMessage(context),
      decoration: InputDecoration(hintText: "Type a message..."),
    );
  }

  void _sendMessage(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageEvent(_controller.text));
      _controller.clear();
    }
  }

  Widget _buildChatBubble(ChatMessage message) {
    return Text("${message.sender}: ${message.text}");
  }
}
