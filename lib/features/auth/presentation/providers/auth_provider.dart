import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/datasources/firestore_profile_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';

// Provider do repositório de auth serve para injetar dependências e criar instâncias do repositório
final authRepositoryProvider = Provider((ref) {
  final dataSource = FirebaseAuthDataSource(FirebaseAuth.instance);
  return AuthRepositoryImpl(dataSource);
});

// Provider do datasource de perfil (nome, idade, foto)
final profileDataSourceProvider = Provider((ref) {
  return FirestoreProfileDataSource(FirebaseFirestore.instance);
});

// Estado do utilizador atual
class AuthNotifier extends Notifier<AppUser?> {
  @override
  AppUser? build() {
    final user = ref.read(authRepositoryProvider).getCurrentUser();
    if (user != null) {
      _loadProfile(user);
    }
    return user;
  }

  // Vai buscar nome, idade e foto guardados no Firestore
  Future<void> _loadProfile(AppUser user) async {
    final profile = await ref.read(profileDataSourceProvider).getProfile(user.id);
    if (profile != null) {
      state = user.copyWith(
        name: profile['name'] as String?,
        age: profile['age'] as int?,
        photoPath: profile['photoPath'] as String?,
      );
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    final user = await ref.read(authRepositoryProvider).login(email, password);
    state = user;
    await _loadProfile(user);
  }

  // Registo
  Future<void> register(String email, String password) async {
    final user = await ref.read(authRepositoryProvider).register(email, password);
    state = user;
  }

  // Logout
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = null;
  }

  // Atualiza o perfil (nome, idade, foto)
  Future<void> updateProfile({String? name, int? age, String? photoPath}) async {
    final user = state;
    if (user == null) return;

    await ref.read(profileDataSourceProvider).saveProfile(
      user.id,
      name: name,
      age: age,
      photoPath: photoPath,
    );

    state = user.copyWith(name: name, age: age, photoPath: photoPath);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AppUser?>(
  AuthNotifier.new,
);