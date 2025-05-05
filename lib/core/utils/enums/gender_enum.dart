enum Gender {
  male,
  female,
  preferNotToSay;

  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';

      case Gender.preferNotToSay:
        return 'Prefer not to say';
    }
  }
}

extension GenderExtension on Gender {
  static Gender fromDisplayName(String name) {
    switch (name.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'prefernottosay':
        return Gender.preferNotToSay;
      default:
        throw ArgumentError('Invalid gender name: $name');
    }
  }
}
