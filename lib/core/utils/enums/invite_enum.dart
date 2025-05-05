enum InviteStatus {
  pending,
  accepted,
  rejected;

  // Convert enum to String
  String toJson() => name; // or toString().split('.').last

  // Convert String to enum
  static InviteStatus fromJson(String json) {
    return InviteStatus.values.firstWhere(
      (e) => e.name == json, // or e.toString().split('.').last == json
      orElse: () => InviteStatus.pending, // default value if not found
    );
  }
}
