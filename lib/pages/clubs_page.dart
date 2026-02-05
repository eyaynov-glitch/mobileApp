import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import 'events_page.dart';

class ClubsPage extends StatelessWidget {
  const ClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Ynov Clubs')),
      body: StreamBuilder(
        stream: FirestoreService.instance.clubs(),
        builder: (context, snapshot) {
          final clubs = snapshot.data ?? [];
          return ListView(
            children: clubs
                .map((club) => Card(
                      child: ListTile(
                        title: Text(club.name),
                        subtitle: Text(club.description),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            TextButton(
                              onPressed: uid == null ? null : () => FirestoreService.instance.joinClub(uid, club.id),
                              child: const Text('Join'),
                            ),
                            TextButton(
                              onPressed: uid == null ? null : () => FirestoreService.instance.quitClub(uid, club.id),
                              child: const Text('Quit'),
                            ),
                            IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => EventsPage(clubId: club.id)),
                              ),
                              icon: const Icon(Icons.event_note),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
