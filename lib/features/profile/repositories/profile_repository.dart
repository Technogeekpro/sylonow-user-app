import 'dart:io';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';

class ProfileRepository {
  final SupabaseClient _supabaseClient;

  ProfileRepository(this._supabaseClient);

  /// Get user profile by auth user ID
  Future<UserProfileModel?> getUserProfile(String authUserId) async {
    try {
      final response = await _supabaseClient
          .from('user_profiles')
          .select()
          .eq('auth_user_id', authUserId)
          .eq('app_type', 'customer')
          .maybeSingle();

      if (response == null) return null;

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Create a new user profile
  Future<UserProfileModel> createUserProfile(UserProfileModel profile) async {
    try {
      // First check if a profile already exists
      final existingProfile = await getUserProfile(profile.authUserId);
      if (existingProfile != null) {
        return existingProfile;
      }

      final response = await _supabaseClient
          .from('user_profiles')
          .insert(profile.toJson())
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  /// Update user profile
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    try {
      final response = await _supabaseClient
          .from('user_profiles')
          .update(profile.toJson())
          .eq('id', profile.id)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Upload profile image
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '$userId/$fileName';

      await _supabaseClient.storage
          .from('profile-images')
          .upload(filePath, imageFile);

      final publicUrl = _supabaseClient.storage
          .from('profile-images')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  /// Delete profile image
  Future<void> deleteProfileImage(String userId, String imageUrl) async {
    try {
      // Extract file path from URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      
      // Find the profile-images bucket segment and get the path after it
      final bucketIndex = pathSegments.indexOf('profile-images');
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
        
        await _supabaseClient.storage
            .from('profile-images')
            .remove([filePath]);
      }
    } catch (e) {
      throw Exception('Failed to delete profile image: $e');
    }
  }

  /// Create user profile from auth user
  Future<UserProfileModel> createUserProfileFromAuth(User authUser) async {
    try {
      // First check if a profile already exists
      final existingProfile = await getUserProfile(authUser.id);
      if (existingProfile != null) {
        return existingProfile;
      }

      // Create profile data without ID (let Supabase generate it)
      final profileData = {
        'auth_user_id': authUser.id,
        'app_type': 'customer',
        'full_name': authUser.userMetadata?['full_name'] ?? authUser.userMetadata?['name'],
        'email': authUser.email,
        'phone_number': authUser.phone,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Insert the new profile
      final response = await _supabaseClient
          .from('user_profiles')
          .insert(profileData)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      debugPrint('Error creating user profile: $e');
      throw Exception('Failed to create user profile: $e');
    }
  }
}