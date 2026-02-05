import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/event.dart';

class StudentClubs extends StatelessWidget {
  const StudentClubs({super.key});

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Clubs'), backgroundColor: Colors.indigo[300]),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Clubs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final clubs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: clubs.length,
              itemBuilder: (_, i) {
                final club = clubs[i].data();
                final members = List<String>.from((club['Members'] ?? []) as List);
                final joined = members.contains(email);
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Text(club['Name'] ?? ''),
                    subtitle: Text(club['Description'] ?? ''),
                    trailing: TextButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance.collection('Clubs').doc(clubs[i].id).set({
                          'Members': joined ? FieldValue.arrayRemove([email]) : FieldValue.arrayUnion([email])
                        }, SetOptions(merge: true));
                      },
                      child: Text(joined ? 'Quit' : 'Join'),
                    ),
                    children: [
                      SizedBox(height: 350, child: Event(true, clubId: clubs[i].id)),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
