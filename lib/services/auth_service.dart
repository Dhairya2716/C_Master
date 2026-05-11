import '../core/utils/import_export.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> login(String email, String password) async{
    final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
    );

    return result.user;
  }

  Future<User?> register(String email, String password) async{
    final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
    );

    return result.user;
  }

  Future<User?> signInWithGoogle() async{

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    final result = await _auth.signInWithCredential(credential);

    return result.user;

  }

  Future<void> logout() async{
    await _auth.signOut();
  }

}