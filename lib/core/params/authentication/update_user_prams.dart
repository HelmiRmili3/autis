class UpdateUserPrams {
  String? name;
  String? email;
  String? phone;
  String? password;
  String? avatarUrl;
  String? token;

  UpdateUserPrams({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.avatarUrl,
    this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'avatarUrl': avatarUrl,
      'token': token,
    };
  }
}
