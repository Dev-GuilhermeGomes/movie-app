import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProfileDataSource {
  final FirebaseFirestore _firestore;

  FirestoreProfileDataSource(this._firestore);

  // Guarda ou atualiza o perfil do utilizador
  Future<void> saveProfile(String userId, {
    String? name,
    int? age,
    String? photoPath,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (age != null) data['age'] = age;
    if (photoPath != null) data['photoPath'] = photoPath;

    await _firestore.collection('users').doc(userId).set(
      data,
      SetOptions(merge: true),
    );
  }

  // Vai buscar o perfil do utilizador
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data();
  }
}