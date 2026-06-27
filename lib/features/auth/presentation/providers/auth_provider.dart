import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';

// Provider do repositório de auth serve para injetar dependências e criar instâncias do repositório
final authRepositoryProvider = Provider((ref) {
  final dataSource = FirebaseAuthDataSource(FirebaseAuth.instance);
  return AuthRepositoryImpl(dataSource);
});

// Estado do utilizador atual
class AuthNotifier extends Notifier<AppUser?> {
  @override
  AppUser? build() {
    return ref.read(authRepositoryProvider).getCurrentUser();
  }

  // Login
  Future<void> login(String email, String password) async {
    final user = await ref.read(authRepositoryProvider).login(email, password);
    state = user;
  }

  // Registro
  Future<void> register(String email, String password) async {
    final user = await ref.read(authRepositoryProvider).register(email, password);
    state = user;
  }

  // Logout 
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = null;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AppUser?>(
  AuthNotifier.new,
);