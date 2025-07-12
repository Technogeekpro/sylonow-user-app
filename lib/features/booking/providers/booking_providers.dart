import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking_model.dart';
import '../models/payment_model.dart';
import '../models/order_model.dart';
import '../repositories/booking_repository.dart';
import '../repositories/payment_repository.dart';
import '../repositories/order_repository.dart';
import '../services/booking_service.dart';
import '../services/razorpay_service.dart';
import '../services/sylonow_qr_service.dart';
import '../services/notification_service.dart';
import '../../auth/providers/auth_providers.dart';

// Repository Providers
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return BookingRepository(supabase);
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return PaymentRepository(supabase);
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return OrderRepository(supabase);
});

// Service Providers
final bookingServiceProvider = Provider<BookingService>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return BookingService(repository);
});

final razorpayServiceProvider = Provider<RazorpayService>((ref) {
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  final orderRepository = ref.watch(orderRepositoryProvider);
  return RazorpayService(paymentRepository, orderRepository);
});

final sylonowQrServiceProvider = Provider<SylonowQrService>((ref) {
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  return SylonowQrService(paymentRepository);
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// Booking State Providers
final userBookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final service = ref.watch(bookingServiceProvider);
  return service.getUserBookingHistory(user.id);
});

final bookingDetailProvider = FutureProvider.family<BookingModel?, String>((ref, bookingId) async {
  final service = ref.watch(bookingServiceProvider);
  final result = await service.getBookingDetails(bookingId);
  return result.isSuccess ? result.booking : null;
});

// Time Slots Provider
final availableTimeSlotsProvider = FutureProvider.family<List<TimeSlotModel>, Map<String, dynamic>>((ref, params) async {
  final service = ref.watch(bookingServiceProvider);
  return service.getAvailableTimeSlots(
    vendorId: params['vendorId'] as String,
    serviceListingId: params['serviceListingId'] as String,
    date: params['date'] as DateTime,
  );
});

// Payment Providers
final paymentSummaryProvider = FutureProvider.family<PaymentSummaryModel?, String>((ref, bookingId) async {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.getPaymentSummary(bookingId);
});

final userPaymentHistoryProvider = FutureProvider<List<PaymentModel>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final repository = ref.watch(paymentRepositoryProvider);
  return repository.getUserPayments(user.id);
});

// Booking Creation State Notifier
class BookingCreationNotifier extends StateNotifier<AsyncValue<BookingModel?>> {
  final BookingService _bookingService;
  final NotificationService _notificationService;

  BookingCreationNotifier(this._bookingService, this._notificationService) 
      : super(const AsyncValue.data(null));

  Future<void> createBooking({
    required String userId,
    required String vendorId,
    required String serviceListingId,
    required String serviceTitle,
    required DateTime bookingDate,
    required String bookingTime,
    required String customerName,
    required String customerPhone,
    required String venueAddress,
    required double totalAmount,
    String? serviceDescription,
    String? customerEmail,
    Map<String, dynamic>? venueCoordinates,
    String? specialRequirements,
    List<Map<String, dynamic>>? addOns,
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await _bookingService.validateAndCreateBooking(
        userId: userId,
        vendorId: vendorId,
        serviceListingId: serviceListingId,
        serviceTitle: serviceTitle,
        bookingDate: bookingDate,
        bookingTime: bookingTime,
        customerName: customerName,
        customerPhone: customerPhone,
        venueAddress: venueAddress,
        totalAmount: totalAmount,
        serviceDescription: serviceDescription,
        customerEmail: customerEmail,
        venueCoordinates: venueCoordinates,
        specialRequirements: specialRequirements,
        addOns: addOns,
      );

      if (result.isSuccess && result.booking != null) {
        state = AsyncValue.data(result.booking);
        
        // Send notification to vendor
        await _notificationService.sendBookingConfirmationToVendor(
          vendorId: vendorId,
          booking: result.booking!,
        );
      } else {
        state = AsyncValue.error(result.message, StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final bookingCreationProvider = StateNotifierProvider<BookingCreationNotifier, AsyncValue<BookingModel?>>((ref) {
  final bookingService = ref.watch(bookingServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return BookingCreationNotifier(bookingService, notificationService);
});

// Payment Processing State Notifiers
class RazorpayPaymentNotifier extends StateNotifier<AsyncValue<RazorpayPaymentResult?>> {
  final RazorpayService _razorpayService;

  RazorpayPaymentNotifier(this._razorpayService) : super(const AsyncValue.data(null));

  Future<void> processPayment({
    required String bookingId,
    required String userId,
    required String vendorId,
    required double amount,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required Map<String, dynamic> metadata,
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await _razorpayService.processPayment(
        bookingId: bookingId,
        userId: userId,
        vendorId: vendorId,
        amount: amount,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        metadata: metadata,
      );

      state = AsyncValue.data(result);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final razorpayPaymentProvider = StateNotifierProvider<RazorpayPaymentNotifier, AsyncValue<RazorpayPaymentResult?>>((ref) {
  final razorpayService = ref.watch(razorpayServiceProvider);
  return RazorpayPaymentNotifier(razorpayService);
});

class SylonowQrPaymentNotifier extends StateNotifier<AsyncValue<QrPaymentResult?>> {
  final SylonowQrService _qrService;

  SylonowQrPaymentNotifier(this._qrService) : super(const AsyncValue.data(null));

  Future<void> generateQrPayment({
    required String bookingId,
    required String userId,
    required String vendorId,
    required double amount,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await _qrService.generateQrPayment(
        bookingId: bookingId,
        userId: userId,
        vendorId: vendorId,
        amount: amount,
        customerName: customerName,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
      );

      state = AsyncValue.data(result);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> verifyPayment({
    required String paymentTransactionId,
    required String paymentReference,
    required String verificationCode,
    String? verifiedBy,
  }) async {
    try {
      final result = await _qrService.verifyQrPayment(
        paymentTransactionId: paymentTransactionId,
        paymentReference: paymentReference,
        verificationCode: verificationCode,
        verifiedBy: verifiedBy,
      );

      if (result.isSuccess) {
        // Refresh the current state to reflect payment completion
        // You might want to navigate or show success message here
      }
    } catch (e) {
      // Handle error
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final sylonowQrPaymentProvider = StateNotifierProvider<SylonowQrPaymentNotifier, AsyncValue<QrPaymentResult?>>((ref) {
  final qrService = ref.watch(sylonowQrServiceProvider);
  return SylonowQrPaymentNotifier(qrService);
});

// Booking Status Management
class BookingStatusNotifier extends StateNotifier<AsyncValue<BookingModel?>> {
  final BookingRepository _repository;

  BookingStatusNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
    bool? vendorConfirmation,
    DateTime? confirmedAt,
    DateTime? completedAt,
  }) async {
    state = const AsyncValue.loading();

    try {
      final updatedBooking = await _repository.updateBookingStatus(
        bookingId: bookingId,
        status: status,
        vendorConfirmation: vendorConfirmation,
        confirmedAt: confirmedAt,
        completedAt: completedAt,
      );

      state = AsyncValue.data(updatedBooking);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updatePaymentStatus({
    required String bookingId,
    required String paymentStatus,
    String? razorpayPaymentId,
    String? razorpayOrderId,
    String? sylonowQrPaymentId,
  }) async {
    try {
      final updatedBooking = await _repository.updateBookingPaymentStatus(
        bookingId: bookingId,
        paymentStatus: paymentStatus,
        razorpayPaymentId: razorpayPaymentId,
        razorpayOrderId: razorpayOrderId,
        sylonowQrPaymentId: sylonowQrPaymentId,
      );

      state = AsyncValue.data(updatedBooking);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final bookingStatusProvider = StateNotifierProvider<BookingStatusNotifier, AsyncValue<BookingModel?>>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return BookingStatusNotifier(repository);
});

// Utility Providers
final paymentBreakdownProvider = Provider.family<Map<String, double>, double>((ref, totalAmount) {
  final service = ref.watch(bookingServiceProvider);
  return service.calculatePaymentBreakdown(totalAmount);
});

// Current Booking Provider (for tracking active booking during flow)
final currentBookingProvider = StateProvider<BookingModel?>((ref) => null);

// Selected Time Slot Provider
final selectedTimeSlotProvider = StateProvider<String?>((ref) => null);

// Selected Date Provider
final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

// Selected Address Provider
final selectedAddressProvider = StateProvider<String?>((ref) => null);

// Order State Providers
final userOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final repository = ref.watch(orderRepositoryProvider);
  return repository.getUserOrders(user.id);
});

final orderDetailProvider = FutureProvider.family<OrderModel?, String>((ref, orderId) async {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getOrderById(orderId);
});

// Order Creation State Notifier
class OrderCreationNotifier extends StateNotifier<AsyncValue<OrderModel?>> {
  final OrderRepository _orderRepository;

  OrderCreationNotifier(this._orderRepository) : super(const AsyncValue.data(null));

  Future<OrderModel> createOrder({
    required String userId,
    required String vendorId,
    required String customerName,
    required String serviceListingId,
    required String serviceTitle,
    required DateTime bookingDate,
    required double totalAmount,
    String? customerPhone,
    String? customerEmail,
    String? serviceDescription,
    String? bookingTime,
    String? specialRequirements,
    String? venueAddress,
    Map<String, dynamic>? venueCoordinates,
  }) async {
    state = const AsyncValue.loading();

    try {
      final advanceAmount = totalAmount * 0.6; // 60% advance
      final remainingAmount = totalAmount * 0.4; // 40% remaining

      final order = await _orderRepository.createOrder(
        userId: userId,
        vendorId: vendorId,
        customerName: customerName,
        serviceListingId: serviceListingId,
        serviceTitle: serviceTitle,
        bookingDate: bookingDate,
        totalAmount: totalAmount,
        advanceAmount: advanceAmount,
        remainingAmount: remainingAmount,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
        serviceDescription: serviceDescription,
        bookingTime: bookingTime,
        specialRequirements: specialRequirements,
        venueAddress: venueAddress,
        venueCoordinates: venueCoordinates,
      );

      state = AsyncValue.data(order);
      return order;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateOrderPayment({
    required String orderId,
    String? paymentStatus,
    String? advancePaymentId,
    String? remainingPaymentId,
  }) async {
    try {
      final updatedOrder = await _orderRepository.updateOrderPayment(
        orderId: orderId,
        paymentStatus: paymentStatus,
        advancePaymentId: advancePaymentId,
        remainingPaymentId: remainingPaymentId,
      );

      state = AsyncValue.data(updatedOrder);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final orderCreationProvider = StateNotifierProvider<OrderCreationNotifier, AsyncValue<OrderModel?>>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return OrderCreationNotifier(orderRepository);
});

// Current Order Provider (for tracking active order during payment flow)
final currentOrderProvider = StateProvider<OrderModel?>((ref) => null); 