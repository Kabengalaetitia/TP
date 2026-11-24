/// Compte utilisateur renvoyé par /accounts/login et /accounts/register.
class User {
  final int id;
  final String email;
  final String? createdAt;

  const User({required this.id, required this.email, this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: int.parse(json['id'].toString()),
        email: json['email'].toString(),
        createdAt: json['created_at']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'created_at': createdAt,
      };
}
