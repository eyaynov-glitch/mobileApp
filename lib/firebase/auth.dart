import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../redux/actions/fetchUserData.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _user;
  final fetch = FetchData();
  static const String allowedDomain = '@ynov.com';

  User? getUser() {
    return _user;
  }

  bool _isAllowedEmail(String email) => email.toLowerCase().endsWith(allowedDomain);

  Auth() {
    auth.authStateChanges().listen((user) async {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool?> signIn({required String username, required String password, required bool isStudent}) async {
    if (!_isAllowedEmail(username)) {
      throw FirebaseAuthException(code: 'invalid-domain', message: 'Only @ynov.com email addresses are allowed.');
    }

    bool? success;
    try {
      success = await fetch.getUserType(username);
      if (success != null && isStudent == success) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password).then((result) async {
          _user = result.user;
          if (success!) {
            await fetch.fetchStudentData(username);
          } else {
            await fetch.fetchFacultyData(username);
          }
        });
        return true;
      }
      notifyListeners();
      return success == null ? null : false;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<bool?> createUser({required String username, required String password, required bool isStudent}) async {
    if (!_isAllowedEmail(username)) {
      throw FirebaseAuthException(code: 'invalid-domain', message: 'Only @ynov.com email addresses are allowed.');
    }

    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: username, password: password).then((result) async {
      _user = result.user;
      if (isStudent) {
        final prn = username.split('@').first;
        await FirebaseFirestore.instance.collection('Student_Detail').doc(prn).set({
          'Email': username,
          'PRN': prn,
          'Roll_No': prn,
          'Address': '8 Ibnou Katima (Ex Bournazel), Casablanca 20000',
          'Sem': 'S1',
          'Mobile': ['+212600000000'],
          'Year': '1',
          'DOB': '2000-01-01',
          'Name': {'First': 'New', 'Last': 'Student'},
          'Branch': 'Informatique',
        }, SetOptions(merge: true));
        await fetch.fetchStudentData(username);
      } else {
        await FirebaseFirestore.instance.collection('Faculty_Detail').doc(username).set({
          'Email': username,
          'Name': 'New Faculty',
          'Branch': 'Informatique',
          'Mobile': '+212600000001',
          'Subjects': ['Flutter'],
        }, SetOptions(merge: true));
        await fetch.fetchFacultyData(username);
      }
    });
    return true;
  }

  Future<bool> signInWithGoogle({required bool isStudent}) async {
    final account = await _googleSignIn.signIn();
    if (account == null) return false;
    if (!_isAllowedEmail(account.email)) {
      await _googleSignIn.signOut();
      throw FirebaseAuthException(code: 'invalid-domain', message: 'Use your @ynov.com account.');
    }

    final authData = await account.authentication;
    final credential = GoogleAuthProvider.credential(accessToken: authData.accessToken, idToken: authData.idToken);
    final result = await auth.signInWithCredential(credential);
    final email = result.user?.email;
    if (email == null) return false;

    final role = await fetch.getUserType(email);
    if (role == null || role != isStudent) {
      await auth.signOut();
      throw FirebaseAuthException(code: 'invalid-role', message: 'Wrong login portal for this role.');
    }

    if (isStudent) {
      await fetch.fetchStudentData(email);
    } else {
      await fetch.fetchFacultyData(email);
    }
    return true;
  }

  Future<bool> signInWithMicrosoft({required bool isStudent}) async {
    final provider = OAuthProvider('microsoft.com');
    provider.setCustomParameters({'tenant': 'common'});
    final result = await auth.signInWithProvider(provider);
    final email = result.user?.email;
    if (email == null || !_isAllowedEmail(email)) {
      await auth.signOut();
      throw FirebaseAuthException(code: 'invalid-domain', message: 'Use your @ynov.com Microsoft account.');
    }

    final role = await fetch.getUserType(email);
    if (role == null || role != isStudent) {
      await auth.signOut();
      throw FirebaseAuthException(code: 'invalid-role', message: 'Wrong login portal for this role.');
    }

    if (isStudent) {
      await fetch.fetchStudentData(email);
    } else {
      await fetch.fetchFacultyData(email);
    }
    return true;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future resetPassword(email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<void> saveUserProfile({required String email, required Map<String, dynamic> profile, required bool isStudent}) async {
    final collection = isStudent ? 'Student_Detail' : 'Faculty_Detail';
    await FirebaseFirestore.instance.collection(collection).doc(email).set(profile, SetOptions(merge: true));
  }
}
