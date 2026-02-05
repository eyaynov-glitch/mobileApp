import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  static const String allowedDomain = '@ynov.com';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> authState() => _auth.authStateChanges();

  Future<UserCredential> registerWithEmail({required String email, required String password}) async {
    _enforceDomain(email);
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> loginWithEmail({required String email, required String password}) async {
    _enforceDomain(email);
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> loginWithGoogle() async {
    final account = await GoogleSignIn().signIn();
    if (account == null) {
      throw FirebaseAuthException(code: 'aborted', message: 'Google sign in aborted');
    }
    _enforceDomain(account.email);
    final authentication = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential> loginWithMicrosoft() async {
    final provider = OAuthProvider('microsoft.com');
    provider.addScope('email');
    provider.setCustomParameters({'tenant': 'common'});
    final credential = await _auth.signInWithProvider(provider);
    final email = credential.user?.email;
    if (email == null || !email.endsWith(allowedDomain)) {
      await credential.user?.delete();
      throw FirebaseAuthException(code: 'invalid-domain', message: 'Use only ynov.com email.');
    }
    return credential;
  }

  Future<void> signOut() => _auth.signOut();

  void _enforceDomain(String email) {
    if (!email.toLowerCase().endsWith(allowedDomain)) {
      throw FirebaseAuthException(code: 'invalid-domain', message: 'Use only @ynov.com email');
    }
  }
}
