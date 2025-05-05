import '../../utils/enums/gender_enum.dart';

class UpdateUserProfile {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final Gender gender;
  final String? avatarUrl;
  final String? location;
  final DateTime updatedAt;

  UpdateUserProfile({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    this.phone,
    this.avatarUrl,
    this.location,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender.toString().split('.').last, // Convert enum to string
      if (phone != null) 'phone': phone,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (location != null) 'location': location,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory UpdateUserProfile.fromJson(Map<String, dynamic> json) {
    return UpdateUserProfile(
      uid: json['uid'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: Gender.values.firstWhere(
        (e) => e.toString() == 'Gender.${json['gender']}',
        orElse: () => Gender.preferNotToSay,
      ),
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      location: json['location'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Create a copy with updated fields
  UpdateUserProfile copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    Gender? gender,
    String? avatarUrl,
    String? location,
  }) {
    return UpdateUserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      location: location ?? this.location,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'UpdateUserProfile('
        'uid::$uid'
        'email: $email, '
        'firstName: $firstName, '
        'lastName: $lastName, '
        'phone: $phone, '
        'gender: $gender, '
        'avatarUrl: $avatarUrl, '
        'location: $location, '
        'updatedAt: $updatedAt)';
  }
}
