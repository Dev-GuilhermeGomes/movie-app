import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../../movies/presentation/screens/movie_list_screen.dart';

//serve para criar a tela de login, com campos para email e password, e botões para login e registro
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

// Estado da tela de login, com controladores para os campos de email e password, e métodos para login e registro fazendo uso do AuthNotifier
class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _login() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      await ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const MovieListScreen()));
      }
    } catch (e) {
      setState(() { _error = 'Email ou password incorretos'; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  // Registro de um novo utilizador, chamando o método register do AuthNotifier e tratando erros
  Future<void> _register() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      await ref.read(authProvider.notifier).register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const MovieListScreen()));
      }
    } catch (e) {
      setState(() { _error = 'Erro ao criar conta'; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  // Construção da interface da tela de login, com campos de texto para email e password, mensagens de erro e botões para login e registro
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('RattingSee',
              style: TextStyle(color: Color(0xFFE8C547),
                fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE8C547))),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE8C547))),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            _isLoading
              ? const CircularProgressIndicator(color: Color(0xFFE8C547))
              : Column(children: [
                  SizedBox(width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8C547),
                        foregroundColor: Colors.black),
                      child: const Text('Entrar'))),
                  const SizedBox(height: 12),
                  SizedBox(width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _register,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE8C547),
                        side: const BorderSide(color: Color(0xFFE8C547))),
                      child: const Text('Criar conta'))),
                ]),
          ],
        ),
      ),
    );
  }
}