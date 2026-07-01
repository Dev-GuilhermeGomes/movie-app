import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A22),
        iconTheme: const IconThemeData(color: Color(0xFFE8C547)),
        title: const Text('Definições',
          style: TextStyle(color: Color(0xFFE8C547), fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          const _SectionTitle('Conta'),
          _SettingsTile(
            icon: Icons.person_outline,
            title: 'Gerir conta',
            subtitle: 'Alterar email ou password',
            onTap: () => _showDialog(context, 'Gerir conta',
              'Esta funcionalidade estará disponível em breve.'),
          ),
          const Divider(color: Color(0xFF2A2A35)),
          const _SectionTitle('Notificações'),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Gerir notificações',
            subtitle: 'Ativar ou desativar notificações',
            onTap: () => _showDialog(context, 'Notificações',
              'Esta funcionalidade estará disponível em breve.'),
          ),
          const Divider(color: Color(0xFF2A2A35)),
          const _SectionTitle('Sessão'),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Terminar sessão',
            color: Colors.red,
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A22),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFFE8C547))),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title,
        style: const TextStyle(color: Color(0xFFE8C547),
          fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}