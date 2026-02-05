import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/firestore_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const roomId = 'global';
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final appUser = AppUser(
      uid: firebaseUser?.uid ?? 'anonymous',
      email: firebaseUser?.email ?? '',
      displayName: firebaseUser?.displayName ?? 'Anonymous',
      role: UserRole.student,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Real-time Messaging')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirestoreService.instance.roomMessages(roomId),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];
                return ListView(
                  reverse: true,
                  children: messages
                      .map((m) => ListTile(
                            title: Text((m['author'] ?? 'Unknown').toString()),
                            subtitle: Text((m['text'] ?? '').toString()),
                          ))
                      .toList(),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(child: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Message...'))),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  await FirestoreService.instance.sendMessage(roomId, appUser, ctrl.text.trim());
                  ctrl.clear();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
