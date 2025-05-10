enum AppointementStatus {
  pending,
  accepted,
  rejected;

  // Convert enum to String
  String toJson() => name; // or toString().split('.').last

  // Convert String to enum
  static AppointementStatus fromJson(String json) {
    return AppointementStatus.values.firstWhere(
      (e) => e.name == json, // or e.toString().split('.').last == json
      orElse: () => AppointementStatus.pending, // default value if not found
    );
  }
}
