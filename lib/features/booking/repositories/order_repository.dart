import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderRepository {
  final SupabaseClient _supabase;

  OrderRepository(this._supabase);

  /// Create a new order in the database
  Future<OrderModel> createOrder({
    required String userId,
    required String vendorId,
    required String customerName,
    required String serviceListingId,
    required String serviceTitle,
    required DateTime bookingDate,
    required double totalAmount,
    required double advanceAmount,
    required double remainingAmount,
    String? customerPhone,
    String? customerEmail,
    String? serviceDescription,
    String? bookingTime,
    String? specialRequirements,
    String? venueAddress,
    Map<String, dynamic>? venueCoordinates,
  }) async {
    try {
      // Validate and clean UUID inputs
      final cleanUserId = userId.trim().isEmpty ? null : userId;
      final cleanVendorId = vendorId.trim().isEmpty || vendorId == 'unknown-vendor' ? null : vendorId;
      final cleanServiceListingId = serviceListingId.trim().isEmpty ? null : serviceListingId;

      final orderData = <String, dynamic>{
        'customer_name': customerName,
        'service_title': serviceTitle,
        'booking_date': bookingDate.toIso8601String(),
        'total_amount': totalAmount,
        'advance_amount': advanceAmount,
        'remaining_amount': remainingAmount,
        'status': 'pending',
        'payment_status': 'pending',
      };

      // Add optional fields only if they have valid values
      if (cleanUserId != null) orderData['user_id'] = cleanUserId;
      if (cleanVendorId != null) orderData['vendor_id'] = cleanVendorId;
      if (cleanServiceListingId != null) orderData['service_listing_id'] = cleanServiceListingId;
      if (customerPhone?.isNotEmpty == true) orderData['customer_phone'] = customerPhone;
      if (customerEmail?.isNotEmpty == true) orderData['customer_email'] = customerEmail;
      if (serviceDescription?.isNotEmpty == true) orderData['service_description'] = serviceDescription;
      if (bookingTime?.isNotEmpty == true) orderData['booking_time'] = bookingTime;
      if (specialRequirements?.isNotEmpty == true) orderData['special_requirements'] = specialRequirements;
      if (venueAddress?.isNotEmpty == true) orderData['venue_address'] = venueAddress;
      if (venueCoordinates != null) orderData['venue_coordinates'] = venueCoordinates;

      final response = await _supabase
          .from('orders')
          .insert(orderData)
          .select()
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  /// Update order payment status and payment IDs
  Future<OrderModel> updateOrderPayment({
    required String orderId,
    String? paymentStatus,
    String? advancePaymentId,
    String? remainingPaymentId,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (paymentStatus != null) {
        updateData['payment_status'] = paymentStatus;
      }
      if (advancePaymentId != null) {
        updateData['advance_payment_id'] = advancePaymentId;
      }
      if (remainingPaymentId != null) {
        updateData['remaining_payment_id'] = remainingPaymentId;
      }
      
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('orders')
          .update(updateData)
          .eq('id', orderId)
          .select()
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update order payment: $e');
    }
  }

  /// Update order status
  Future<OrderModel> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final response = await _supabase
          .from('orders')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId)
          .select()
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  /// Get order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select()
          .eq('id', orderId)
          .maybeSingle();

      if (response == null) return null;
      return OrderModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

  /// Get user orders
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get user orders: $e');
    }
  }

  /// Get vendor orders
  Future<List<OrderModel>> getVendorOrders(String vendorId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select()
          .eq('vendor_id', vendorId)
          .order('created_at', ascending: false);

      return response.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get vendor orders: $e');
    }
  }
}