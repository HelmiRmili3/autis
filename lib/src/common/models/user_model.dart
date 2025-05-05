class UserModel {
  final String uid;
  final String email;
  final String firstname;
  final String lastname;
  final String avatarUrl;
  final String? phone;
  final String gender;
  final String role;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.avatarUrl,
    this.phone,
    required this.gender,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      avatarUrl: json['avatarUrl'],
      gender: json['gender'],
      phone: json['phone'],
      role: json['role'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'avatarUrl': avatarUrl,
      'gender': gender,
      'phone': phone,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
