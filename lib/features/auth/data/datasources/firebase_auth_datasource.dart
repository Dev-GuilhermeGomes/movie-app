import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/app_user.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth;

  FirebaseAuthDataSource(this._auth);

  // Faz login com email e password
  Future<AppUser> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return AppUser(
      id: credential.user!.uid,
      email: credential.user!.email!,
    );
  }

  // Regista um novo utilizador
  Future<AppUser> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return AppUser(
      id: credential.user!.uid,
      email: credential.user!.email!,
    );
  }

  // Faz logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Devolve o utilizador atual
  AppUser? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AppUser(id: user.uid, email: user.email!);
  }
}

//Isto usa o Firebase Auth para fazer login, registo e logout, e converte o utilizador do Firebase num AppUser da nossa app.