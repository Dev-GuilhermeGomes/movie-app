class AppUser {
  final String id;
  final String email;

  const AppUser({
    required this.id,
    required this.email,
  });
}

//É a entidade do utilizador — só precisa do id (gerado pelo Firebase) e do email.