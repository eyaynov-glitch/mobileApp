import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoleHomePage extends StatelessWidget {
  const RoleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Center(child: Text('No user'));
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        final role = snapshot.data?.data()?['role']?.toString() ?? 'student';
        final title = switch (role) {
          'admin' => 'Admin Dashboard',
          'professor' => 'Professor Dashboard',
          'clubLead' => 'Club Lead Dashboard',
          _ => 'Student Dashboard',
        };
        return Center(
          child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}
