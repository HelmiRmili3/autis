class UpdateDoctorParams {
  final String doctorId;
  final String firstname;
  final String lastname;
  final String phone;
  final String avatarUrl;

  UpdateDoctorParams({
    required this.doctorId,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
  }
}
