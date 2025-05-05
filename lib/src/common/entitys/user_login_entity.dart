class UserLoginEntity {
  final String email;
  final String password;

  UserLoginEntity({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory UserLoginEntity.fromJson(Map<String, dynamic> json) {
    return UserLoginEntity(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}
