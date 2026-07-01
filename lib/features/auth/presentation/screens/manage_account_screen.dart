import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';

class ManageAccountScreen extends ConsumerStatefulWidget {
  const ManageAccountScreen({super.key});

  @override
  ConsumerState<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends ConsumerState<ManageAccountScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _photoPath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);
    _nameController.text = user?.name ?? '';
    _ageController.text = user?.age?.toString() ?? '';
    _photoPath = user?.photoPath;
  }

  // Abre a câmara do telemóvel para tirar uma foto
  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _photoPath = photo.path;
      });
    }
  }

  Future<void> _save() async {
    setState(() { _isSaving = true; });

    await ref.read(authProvider.notifier).updateProfile(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()),
      photoPath: _photoPath,
    );

    setState(() { _isSaving = false; });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A22),
        iconTheme: const IconThemeData(color: Color(0xFFE8C547)),
        title: const Text('Gerir conta',
          style: TextStyle(color: Color(0xFFE8C547), fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _takePhoto,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: const Color(0xFF1A1A22),
                    backgroundImage: _photoPath != null
                      ? FileImage(File(_photoPath!))
                      : null,
                    child: _photoPath == null
                      ? const Icon(Icons.person, size: 56, color: Colors.grey)
                      : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8C547),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text('Toca para tirar uma foto',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nome',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE8C547))),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Idade',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE8C547))),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              enabled: false,
              controller: TextEditingController(text: user?.email ?? ''),
              style: const TextStyle(color: Colors.grey),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8C547),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}