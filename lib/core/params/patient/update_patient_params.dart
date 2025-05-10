class UpdatePatientParams {
  final String uid;
  final String firstname;
  final String lastname;
  final String? phone;
  final String? location;
  final String avatarUrl;

  UpdatePatientParams({
    required this.uid,
    required this.firstname,
    required this.lastname,
    this.phone,
    this.location,
    required this.avatarUrl,
  });

  // Convert to JSON for API/Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstname': firstname,
      'lastname': lastname,
      if (phone != null) 'phone': phone, // Only include if not null
      if (location != null) 'location': location, // Only include if not null
      'avatarUrl': avatarUrl,
      'updatedAt': DateTime.now().toIso8601String(), // Add update timestamp
    };
  }

  // Create from JSON (useful for testing)
  factory UpdatePatientParams.fromJson(Map<String, dynamic> json) {
    return UpdatePatientParams(
      uid: json['uid'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      avatarUrl: json['avatarUrl'] as String,
    );
  }

  // Create a copy with updated fields
  UpdatePatientParams copyWith({
    String? uid,
    String? email,
    String? firstname,
    String? lastname,
    String? phone,
    String? location,
    String? avatarUrl,
  }) {
    return UpdatePatientParams(
      uid: uid ?? this.uid,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  String toString() {
    return 'UpdatePatientParams('
        'uid: $uid, '
        'firstname: $firstname, '
        'lastname: $lastname, '
        'phone: $phone, '
        'location: $location, '
        'avatarUrl: $avatarUrl)';
  }
}
