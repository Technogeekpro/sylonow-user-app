import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/core/providers/core_providers.dart';
import 'package:sylonow_user/features/home/models/vendor_model.dart';
import 'package:sylonow_user/features/home/repositories/home_repository.dart';

// Repository provider
final vendorRepositoryProvider = Provider<HomeRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return HomeRepository(supabase);
});

// Vendor by ID provider
final vendorByIdProvider = FutureProvider.family<VendorModel?, String>((ref, vendorId) async {
  final repository = ref.watch(vendorRepositoryProvider);
  return repository.getVendorById(vendorId);
});

// Vendor online status provider
final vendorOnlineStatusProvider = FutureProvider.family<bool, String>((ref, vendorId) async {
  final vendor = await ref.watch(vendorByIdProvider(vendorId).future);
  return vendor?.isOnline ?? false;
});

// Vendor business hours provider
final vendorBusinessHoursProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, vendorId) async {
  final vendor = await ref.watch(vendorByIdProvider(vendorId).future);
  if (vendor == null) {
    return {
      'startTime': '09:00',
      'closeTime': '18:00',
      'advanceBookingHours': 2,
    };
  }
  
  return {
    'startTime': vendor.startTime ?? '09:00',
    'closeTime': vendor.closeTime ?? '18:00',
    'advanceBookingHours': vendor.advanceBookingHours,
  };
});

// Available time slots for vendor provider
final vendorAvailableTimeSlotsProvider = FutureProvider.family<List<String>, Map<String, dynamic>>((ref, params) async {
  final vendorId = params['vendorId'] as String;
  final selectedDate = params['selectedDate'] as String;
  final currentTime = params['currentTime'] as DateTime;
  
  final vendor = await ref.watch(vendorByIdProvider(vendorId).future);
  if (vendor == null || !vendor.isOnline) {
    return [];
  }
  
  final businessHours = await ref.watch(vendorBusinessHoursProvider(vendorId).future);
  final advanceBookingHours = businessHours['advanceBookingHours'] as int;
  
  // Parse business hours
  final startTime = _parseTime(businessHours['startTime'] as String);
  final closeTime = _parseTime(businessHours['closeTime'] as String);
  
  if (startTime == null || closeTime == null) {
    return [];
  }
  
  // Calculate available time slots
  final availableSlots = <String>[];
  final selectedDateTime = DateTime.parse(selectedDate);
  final isToday = selectedDateTime.year == currentTime.year &&
                  selectedDateTime.month == currentTime.month &&
                  selectedDateTime.day == currentTime.day;
  
  // Start from current time + advance booking hours if today, otherwise from start time
  DateTime slotStart;
  if (isToday) {
    final currentPlusAdvance = currentTime.add(Duration(hours: advanceBookingHours));
    slotStart = DateTime(
      selectedDateTime.year,
      selectedDateTime.month,
      selectedDateTime.day,
      currentPlusAdvance.hour,
      currentPlusAdvance.minute,
    );
    
    // If current time + advance is before start time, use start time
    final startDateTime = DateTime(
      selectedDateTime.year,
      selectedDateTime.month,
      selectedDateTime.day,
      startTime.hour,
      startTime.minute,
    );
    
    if (slotStart.isBefore(startDateTime)) {
      slotStart = startDateTime;
    }
  } else {
    slotStart = DateTime(
      selectedDateTime.year,
      selectedDateTime.month,
      selectedDateTime.day,
      startTime.hour,
      startTime.minute,
    );
  }
  
  // Generate time slots until close time
  final closeDateTime = DateTime(
    selectedDateTime.year,
    selectedDateTime.month,
    selectedDateTime.day,
    closeTime.hour,
    closeTime.minute,
  );
  
  while (slotStart.isBefore(closeDateTime)) {
    final slotEnd = slotStart.add(const Duration(hours: 1));
    if (slotEnd.isBefore(closeDateTime) || slotEnd.isAtSameMomentAs(closeDateTime)) {
      availableSlots.add('${_formatTime(slotStart)}-${_formatTime(slotEnd)}');
    }
    slotStart = slotStart.add(const Duration(hours: 1));
  }
  
  return availableSlots;
});

// Helper function to parse time string (HH:mm) to DateTime
DateTime? _parseTime(String timeStr) {
  try {
    final parts = timeStr.split(':');
    if (parts.length != 2) return null;
    
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    
    return DateTime(2024, 1, 1, hour, minute);
  } catch (e) {
    return null;
  }
}

// Helper function to format DateTime to HH:mm string
String _formatTime(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

