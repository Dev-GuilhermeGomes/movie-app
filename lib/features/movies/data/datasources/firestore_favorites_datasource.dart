import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreFavoritesDataSource {
  final FirebaseFirestore _firestore;

  FirestoreFavoritesDataSource(this._firestore);

  // Vai buscar os IDs dos filmes favoritos do utilizador
  Future<List<String>> getFavoriteIds(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  // Adiciona ou remove um filme dos favoritos
  Future<void> toggleFavorite(String userId, int movieId, bool isFavorite) async {
    final ref = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(movieId.toString());

    if (isFavorite) {
      await ref.delete();
    } else {
      await ref.set({'addedAt': FieldValue.serverTimestamp()});
    }
  }
}

//Isto gere os favoritos no Firestore. Cada utilizador tem uma subcoleção favorites com os IDs dos filmes que favoritou.