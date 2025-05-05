import 'dart:convert';
import 'package:autis/src/common/entitys/user_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/web.dart';

class UserProfileStorage {
  final FlutterSecureStorage _secureStorage;
  final _logger = Logger();
  static const String _storageKey = 'currentuser';
  UserProfileStorage(
    this._secureStorage,
  );

  /// Save a UserProfileModel to secure storage
  Future<void> saveUserProfile(UserEntity userProfile) async {
    try {
      final jsonString = jsonEncode(userProfile.toMap());
      await _secureStorage.write(key: _storageKey, value: jsonString);
    } catch (e) {
      _logger.i('Error saving user profile: $e');
      throw Exception('Failed to save user profile');
    }
  }

  /// Retrieve a UserProfileModel from secure storage
  Future<UserEntity?> getUserProfile() async {
    try {
      final jsonString = await _secureStorage.read(key: _storageKey);
      if (jsonString == null) return null;

      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return UserEntity.fromMap(jsonMap);
    } catch (e) {
      _logger.i('Error reading user profile: $e');
      throw Exception('Failed to read user profile');
    }
  }

  /// Update an existing UserProfileModel in secure storage
  // Future<void> updateUserProfile(UserModel updatedProfile) async {
  //   try {
  //     final existingProfile = await getUserProfile();

  //     if (existingProfile != null) {
  //       final updatedData = existingProfile.copyWith(
  //         uid: updatedProfile.uid,
  //         firstName: updatedProfile.firstName,
  //         lastName: updatedProfile.lastName,
  //         email: updatedProfile.email,
  //         createdAt: updatedProfile.createdAt,
  //         updatedAt: updatedProfile.updatedAt,
  //         birthDay: updatedProfile.birthDay,
  //         phoneNumber: updatedProfile.phoneNumber,
  //         role: updatedProfile.role,
  //         sexe: updatedProfile.sexe,
  //         imageUrl: updatedProfile.imageUrl,
  //       );

  //       await saveUserProfile(updatedData);
  //     } else {
  //       await saveUserProfile(updatedProfile);
  //     }
  //   } catch (e) {
  //     _logger.i('Error updating user profile: $e');
  //     throw Exception('Failed to update user profile');
  //   }
  // }

  /// Delete the UserProfileModel from secure storage
  Future<void> deleteUserProfile() async {
    try {
      await _secureStorage.delete(key: _storageKey);
    } catch (e) {
      _logger.i('Error deleting user profile: $e');
      throw Exception('Failed to delete user profile');
    }
  }
}
