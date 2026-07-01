import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

// Implementação real do contrato definido no Domain
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<AppUser> login(String email, String password) async {
    return await _dataSource.login(email, password);
  }

  @override
  Future<AppUser> register(String email, String password) async {
    return await _dataSource.register(email, password);
  }

  @override
  Future<void> logout() async {
    await _dataSource.logout();
  }

  @override
  AppUser? getCurrentUser() {
    return _dataSource.getCurrentUser();
  }
}