import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/profile_providers.dart';
import '../models/user_profile_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;
  File? _selectedImage;
  UserProfileModel? _currentProfile;
  bool _isLoading = false;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  String? _mapGenderValue(String? gender) {
    if (gender == null) return null;
    switch (gender.toLowerCase()) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      case 'other':
        return 'Other';
      case 'prefer_not_to_say':
      case 'prefer not to say':
        return 'Prefer not to say';
      default:
        return _genderOptions.contains(gender) ? gender : null;
    }
  }

  String? _mapGenderToDatabase(String? gender) {
    if (gender == null) return null;
    switch (gender) {
      case 'Male':
        return 'male';
      case 'Female':
        return 'female';
      case 'Other':
        return 'other';
      case 'Prefer not to say':
        return 'prefer_not_to_say';
      default:
        return gender.toLowerCase();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  void _loadProfileData() {
    final profileAsyncValue = ref.read(currentUserProfileProvider);
    profileAsyncValue.whenData((profile) {
      if (profile != null) {
        setState(() {
          _currentProfile = profile;
          _fullNameController.text = profile.fullName ?? '';
          _emailController.text = profile.email ?? '';
          _phoneController.text = profile.phoneNumber ?? '';
          _bioController.text = profile.bio ?? '';
          _cityController.text = profile.city ?? '';
          _stateController.text = profile.state ?? '';
          _postalCodeController.text = profile.postalCode ?? '';
          _emergencyNameController.text = profile.emergencyContactName ?? '';
          _emergencyPhoneController.text = profile.emergencyContactPhone ?? '';
          _selectedDate = profile.dateOfBirth;
          _selectedGender = _mapGenderValue(profile.gender);
        });
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_currentProfile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile not loaded. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final updatedProfile = _currentProfile!.copyWith(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
        bio: _bioController.text.trim().isNotEmpty ? _bioController.text.trim() : null,
        city: _cityController.text.trim().isNotEmpty ? _cityController.text.trim() : null,
        state: _stateController.text.trim().isNotEmpty ? _stateController.text.trim() : null,
        postalCode: _postalCodeController.text.trim().isNotEmpty ? _postalCodeController.text.trim() : null,
        emergencyContactName: _emergencyNameController.text.trim().isNotEmpty ? _emergencyNameController.text.trim() : null,
        emergencyContactPhone: _emergencyPhoneController.text.trim().isNotEmpty ? _emergencyPhoneController.text.trim() : null,
        dateOfBirth: _selectedDate,
        gender: _mapGenderToDatabase(_selectedGender),
      );

      final controller = ref.read(profileControllerProvider.notifier);
      
      // First update the profile data
      bool success = await controller.updateProfile(updatedProfile);
      
      // Then update the image if one is selected
      if (success && _selectedImage != null) {
        success = await controller.updateProfileImage(_selectedImage!);
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else if (mounted) {
        final errorMessage = controller.errorMessage ?? 'Failed to update profile';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Okra',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Okra',
                    ),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileImageSection(),
              const SizedBox(height: 24),
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildPersonalDetailsSection(),
              const SizedBox(height: 24),
              _buildLocationSection(),
              const SizedBox(height: 24),
              _buildEmergencyContactSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppTheme.primaryColor,
                  backgroundImage: _getProfileImage(),
                  child: _getProfileImage() == null
                      ? Text(
                          _currentProfile?.fullName?.isNotEmpty == true
                              ? _currentProfile!.fullName!.substring(0, 1).toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Okra',
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to change photo',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (_currentProfile?.profileImageUrl != null) {
      return CachedNetworkImageProvider(_currentProfile!.profileImageUrl!);
    }
    return null;
  }

  Widget _buildBasicInfoSection() {
    return _buildSection(
      title: 'Basic Information',
      children: [
        _buildTextField(
          controller: _fullNameController,
          label: 'Full Name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value?.trim().isEmpty ?? true) {
              return 'Full name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.trim().isEmpty ?? true) {
              return 'Email is required';
            }
            if (!RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$').hasMatch(value!)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _bioController,
          label: 'Bio',
          icon: Icons.info_outline,
          maxLines: 3,
          maxLength: 150,
        ),
      ],
    );
  }

  Widget _buildPersonalDetailsSection() {
    return _buildSection(
      title: 'Personal Details',
      children: [
        _buildDateField(),
        const SizedBox(height: 16),
        _buildGenderField(),
      ],
    );
  }

  Widget _buildLocationSection() {
    return _buildSection(
      title: 'Location',
      children: [
        _buildTextField(
          controller: _cityController,
          label: 'City',
          icon: Icons.location_city_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _stateController,
          label: 'State',
          icon: Icons.map_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _postalCodeController,
          label: 'Postal Code',
          icon: Icons.markunread_mailbox_outlined,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildEmergencyContactSection() {
    return _buildSection(
      title: 'Emergency Contact',
      children: [
        _buildTextField(
          controller: _emergencyNameController,
          label: 'Emergency Contact Name',
          icon: Icons.contact_emergency_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emergencyPhoneController,
          label: 'Emergency Contact Phone',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor),
        ),
        labelStyle: const TextStyle(fontFamily: 'Okra'),
      ),
      style: const TextStyle(fontFamily: 'Okra'),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Date of Birth',
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedDate != null ? Colors.black87 : Colors.grey[600],
                  fontFamily: 'Okra',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          labelText: 'Gender',
          prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryColor),
          border: InputBorder.none,
          labelStyle: const TextStyle(fontFamily: 'Okra'),
        ),
        items: _genderOptions.map((gender) {
          return DropdownMenuItem(
            value: gender,
            child: Text(
              gender,
              style: const TextStyle(fontFamily: 'Okra'),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
      ),
    );
  }
}