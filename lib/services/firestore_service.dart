import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/club.dart';
import '../models/event.dart';
import '../models/app_user.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Club>> clubs() => _db.collection('clubs').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Club.fromMap(doc.id, doc.data())).toList(),
      );

  Stream<List<CampusEvent>> events({String? clubId}) {
    Query<Map<String, dynamic>> query = _db.collection('events');
    if (clubId != null) {
      query = query.where('clubId', isEqualTo: clubId);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => CampusEvent.fromMap(doc.id, doc.data())).toList(),
        );
  }

  Stream<List<Map<String, dynamic>>> roomMessages(String roomId) => _db
      .collection('chatRooms')
      .doc(roomId)
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Future<void> sendMessage(String roomId, AppUser user, String text) {
    return _db.collection('chatRooms').doc(roomId).collection('messages').add({
      'text': text,
      'author': user.displayName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> joinClub(String uid, String clubId) => _db.collection('users').doc(uid).set({
        'clubIds': FieldValue.arrayUnion([clubId]),
      }, SetOptions(merge: true));

  Future<void> quitClub(String uid, String clubId) => _db.collection('users').doc(uid).set({
        'clubIds': FieldValue.arrayRemove([clubId]),
      }, SetOptions(merge: true));

  Future<void> updateProfile(String uid, Map<String, dynamic> data) =>
      _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
}
