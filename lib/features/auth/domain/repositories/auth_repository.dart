import '../entities/app_user.dart';

// Contrato do repositório de autenticação
// Define O QUÊ fazer, não O COMO
abstract interface class AuthRepository {
  
  Future<AppUser> login(String email, String password); // Faz login com email e password
  
  Future<AppUser> register(String email, String password); // Regista um novo utilizador
  
  Future<void> logout(); // Faz logout do utilizador atual
  
  AppUser? getCurrentUser(); // Devolve o utilizador atual (null se não estiver autenticado)
}