class AppUser {
  final String id;
  final String email;
  final String? name;
  final int? age;
  final String? photoPath;

  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.age,
    this.photoPath,
  });

  AppUser copyWith({ //O copyWith serve para atualizar só alguns campos sem recriar o objeto por completo. Por exemplo, se só quiser atualizar o nome, pode fazer: user.copyWith(name: 'Novo Nome').
    String? name,
    int? age,
    String? photoPath,
  }) {
    return AppUser(
      id: id,
      email: email,
      name: name ?? this.name,
      age: age ?? this.age,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}
//É a entidade do utilizador — só precisa do id (gerado pelo Firebase) e do email.