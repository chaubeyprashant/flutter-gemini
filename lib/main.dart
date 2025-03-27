import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spring_ai_agent/service/chat_service.dart';
import 'package:spring_ai_agent/views/components/chat_message.dart';
import 'blocs/chat_bloc.dart';
import 'blocs/chat_event.dart';
import 'model/chat_message_model.dart';
import 'repositories/chat_repository.dart';
import 'views/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageModelAdapter()); // Ensure this is added
  await Hive.openBox<ChatMessageModel>('chat_messages');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(ChatRepository(ChatService()))..add(LoadMessagesEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Virtual Agent Chat',
        theme: ThemeData(primarySwatch: Colors.green),
        home: ChatScreen(),
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Virtual Agent Chat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              icon: Icon(Icons.chat, color: Colors.white),
              label: Text("Start Chat"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}