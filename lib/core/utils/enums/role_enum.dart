enum Role {
  admin,
  doctor,
  patient;

  String get displayName {
    switch (this) {
      case Role.admin:
        return 'administrator';
      case Role.doctor:
        return 'doctor';
      case Role.patient:
        return 'patient';
    }
  }

  String toJson() => name; // or toString().split('.').last

  // Convert String to enum (for JSON deserialization)
  static Role fromJson(String json) {
    return Role.values.firstWhere(
      (e) => e.name == json.toLowerCase(), // Case-insensitive matching
      orElse: () => Role.patient, // Default value if not found
    );
  }
}
