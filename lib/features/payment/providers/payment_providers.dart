import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_method_model.dart';
import '../services/payment_service.dart';

// Payment service provider
final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

// Payment methods provider
final paymentMethodsProvider = FutureProvider<List<PaymentMethodModel>>((ref) async {
  final paymentService = ref.watch(paymentServiceProvider);
  return paymentService.getPaymentMethods();
});

// Selected payment method provider
final selectedPaymentMethodProvider = StateProvider<PaymentMethodModel?>((ref) => null);

// Payment processing state provider
final paymentProcessingProvider = StateProvider<bool>((ref) => false);