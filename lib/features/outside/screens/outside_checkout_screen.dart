import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/outside/providers/outside_providers.dart';
import 'package:sylonow_user/features/outside/models/theater_screen_model.dart';
import 'package:sylonow_user/features/theater/models/occasion_model.dart';
import 'package:sylonow_user/features/theater/models/special_service_model.dart';
import 'package:sylonow_user/features/outside/models/addon_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sylonow_user/core/utils/price_calculator.dart';

class OutsideCheckoutScreen extends ConsumerStatefulWidget {
  static const String routeName = '/outside/checkout';

  final String screenId;
  final String selectedDate;
  final Map<String, dynamic> selectionData;

  const OutsideCheckoutScreen({
    super.key,
    required this.screenId,
    required this.selectedDate,
    required this.selectionData,
  });

  @override
  ConsumerState<OutsideCheckoutScreen> createState() =>
      _OutsideCheckoutScreenState();
}

class _OutsideCheckoutScreenState extends ConsumerState<OutsideCheckoutScreen> {
  bool _isProcessingPayment = false;
  bool _isBillDetailsExpanded = false;
  
  // Form controllers
  final TextEditingController _celebrationNameController = TextEditingController();
  int _numberOfPeople = 2;
  TheaterScreen? _currentScreen;

  @override
  void initState() {
    super.initState();
    // Pre-fill celebration name if available from onboarding
    final celebrationName = widget.selectionData['celebrationName'] as String?;
    if (celebrationName != null) {
      _celebrationNameController.text = celebrationName;
    }
  }

  @override
  void dispose() {
    _celebrationNameController.dispose();
    super.dispose();
  }

  // Calculate pricing
  double get _packagePrice {
    final selectedPackage = widget.selectionData['selectedPackage'] as Map<String, dynamic>?;
    return selectedPackage?['packagePrice']?.toDouble() ?? 0.0;
  }

  double get _specialServicesPrice {
    final selectedSpecialServices = widget.selectionData['selectedSpecialServices'] as List<dynamic>?;
    if (selectedSpecialServices == null) return 0.0;
    
    final specialServicesAsync = ref.read(specialServicesProvider);
    return specialServicesAsync.when(
      data: (services) {
        double total = 0;
        for (final service in selectedSpecialServices) {
          final serviceId = service['id'] as String;
          final quantity = service['quantity'] as int;
          final serviceModel = services.firstWhere(
            (s) => s.id == serviceId,
            orElse: () => SpecialServiceModel(
              id: '',
              name: '',
              price: 0,
              isActive: false,
            ),
          );
          total += serviceModel.price * quantity;
        }
        return total;
      },
      loading: () => 0,
      error: (_, __) => 0,
    );
  }

  double get _addonsPrice {
    final selectedAddons = widget.selectionData['selectedAddons'] as List<dynamic>?;
    if (selectedAddons == null) return 0.0;
    
    final addOnsAsync = ref.read(addOnsProvider);
    return addOnsAsync.when(
      data: (addons) {
        double total = 0;
        for (final addon in selectedAddons) {
          final addonId = addon['id'] as String;
          final quantity = addon['quantity'] as int;
          final addonModel = addons.firstWhere(
            (a) => a.id == addonId,
            orElse: () => AddonModel(
              id: '',
              name: '',
              price: 0,
              isActive: false,
              category: '',
            ),
          );
          total += addonModel.price * quantity;
        }
        return total;
      },
      loading: () => 0,
      error: (_, __) => 0,
    );
  }

  // Calculate extra person charges
  double get _extraPersonCharges {
    if (_currentScreen == null) return 0.0;

    final allowedCapacity = _currentScreen!.allowedCapacity ?? 0;
    final chargesPerPerson = _currentScreen!.chargesExtraPerPerson ?? 0.0;

    if (_numberOfPeople <= allowedCapacity) return 0.0;

    final extraPeople = _numberOfPeople - allowedCapacity;
    return extraPeople * chargesPerPerson;
  }

  double get _subtotal => _packagePrice + _specialServicesPrice + _addonsPrice + _extraPersonCharges;
  double get _taxes => PriceCalculator.calculateTaxes(_subtotal);
  double get _totalAmount => _subtotal + _taxes;
  double get _advanceAmount => PriceCalculator.calculateAdvancePayment(_totalAmount);

  @override
  Widget build(BuildContext context) {
    final screenAsync = ref.watch(theaterScreenProvider(widget.screenId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Okra',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: screenAsync.when(
        data: (screen) => _buildCheckoutContent(screen),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (error, stackTrace) => _buildErrorContent(error),
      ),
    );
  }

  Widget _buildCheckoutContent(TheaterScreen? screen) {
    // Store screen data for calculations
    if (screen != null && _currentScreen == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _currentScreen = screen;
        });
      });
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Screen Info Card
                _buildScreenInfoCard(screen),
                const SizedBox(height: 16),

                // Celebration Details Card
                _buildCelebrationDetailsCard(screen),
                const SizedBox(height: 16),

                // Selected Items Summary
                _buildSelectedItemsCard(),
                const SizedBox(height: 16),

                // Bill Details Card
                _buildBillDetailsCard(),
                const SizedBox(height: 16),

                // Terms and Important Notes
                _buildTermsCard(),
                const SizedBox(height: 100), // Extra space for floating button
              ],
            ),
          ),
        ),

        // Payment Button
        _buildPaymentButton(),
      ],
    );
  }

  Widget _buildScreenInfoCard(TheaterScreen? screen) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: screen?.images?.isNotEmpty == true
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: screen!.images!.first,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.movie, color: Colors.grey),
                    ),
                  )
                : const Icon(Icons.movie, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  screen?.screenName ?? 'Private Theater',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Okra',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  screen?.description ?? 'Theater Screen',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Okra',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(DateTime.parse(widget.selectedDate)),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Confirmed',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebrationDetailsCard(TheaterScreen? screen) {
    final allowedCapacity = screen?.allowedCapacity ?? 0;
    final totalCapacity = screen?.totalCapacity ?? 20;
    final chargesPerPerson = screen?.chargesExtraPerPerson ?? 0.0;
    final isExceedingAllowed = _numberOfPeople > allowedCapacity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Celebration Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 12),

          // Celebration Name Input
          TextField(
            controller: _celebrationNameController,
            decoration: InputDecoration(
              labelText: 'Celebration Name',
              hintText: 'e.g., John\'s Birthday Party',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.primaryColor),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            style: const TextStyle(fontFamily: 'Okra'),
          ),
          const SizedBox(height: 16),

          // Number of People
          Row(
            children: [
              const Text(
                'Number of People:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _numberOfPeople > 1
                          ? () => setState(() => _numberOfPeople--)
                          : null,
                      icon: const Icon(Icons.remove, size: 18),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: Text(
                        '$_numberOfPeople',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _numberOfPeople < totalCapacity
                          ? () => setState(() => _numberOfPeople++)
                          : null,
                      icon: const Icon(Icons.add, size: 18),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Capacity info and extra charges warning
          if (allowedCapacity > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isExceedingAllowed
                    ? Colors.orange[50]
                    : Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isExceedingAllowed
                      ? Colors.orange[200]!
                      : Colors.blue[200]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isExceedingAllowed ? Icons.warning_amber : Icons.info_outline,
                    color: isExceedingAllowed ? Colors.orange[700] : Colors.blue[700],
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isExceedingAllowed
                          ? 'Extra charges: ₹${chargesPerPerson.round()}/person beyond $allowedCapacity people'
                          : 'Package includes up to $allowedCapacity people',
                      style: TextStyle(
                        fontSize: 12,
                        color: isExceedingAllowed ? Colors.orange[700] : Colors.blue[700],
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectedItemsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 12),

          // Selected Package
          if (widget.selectionData['selectedPackage'] != null) ...[
            _buildSelectedItemRow(
              'Theater Package',
              widget.selectionData['selectedPackage']['packageName'] ?? 'Package',
              _packagePrice,
              Icons.movie,
            ),
          ],

          // Selected Occasion
          if (widget.selectionData['selectedOccasion'] != null) ...[
            const SizedBox(height: 8),
            _buildSelectedItemInfo(
              'Occasion',
              (widget.selectionData['selectedOccasion'] as OccasionModel).name,
              Icons.celebration,
            ),
          ],

          // Selected Special Services
          if (widget.selectionData['selectedSpecialServices'] != null) ...[
            const SizedBox(height: 8),
            _buildSpecialServicesSection(),
          ],

          // Selected Addons
          if (widget.selectionData['selectedAddons'] != null) ...[
            const SizedBox(height: 8),
            _buildAddonsSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectedItemRow(String category, String name, double price, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: 'Okra',
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
        ),
        Text(
          '₹${price.round()}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
            fontFamily: 'Okra',
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedItemInfo(String category, String name, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: 'Okra',
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Included',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialServicesSection() {
    final selectedSpecialServices = widget.selectionData['selectedSpecialServices'] as List<dynamic>;
    final specialServicesAsync = ref.watch(specialServicesProvider);
    
    return specialServicesAsync.when(
      data: (services) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: selectedSpecialServices.map((service) {
            final serviceId = service['id'] as String;
            final quantity = service['quantity'] as int;
            final serviceModel = services.firstWhere(
              (s) => s.id == serviceId,
              orElse: () => SpecialServiceModel(
                id: '',
                name: 'Unknown Service',
                price: 0,
                isActive: false,
              ),
            );
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildSelectedItemRow(
                'Special Service${quantity > 1 ? ' (x$quantity)' : ''}',
                serviceModel.name,
                serviceModel.price * quantity,
                Icons.card_giftcard,
              ),
            );
          }).toList(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildAddonsSection() {
    final selectedAddons = widget.selectionData['selectedAddons'] as List<dynamic>;
    final addOnsAsync = ref.watch(addOnsProvider);
    
    return addOnsAsync.when(
      data: (addons) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: selectedAddons.map((addon) {
            final addonId = addon['id'] as String;
            final quantity = addon['quantity'] as int;
            final addonModel = addons.firstWhere(
              (a) => a.id == addonId,
              orElse: () => AddonModel(
                id: '',
                name: 'Unknown Addon',
                price: 0,
                isActive: false,
                category: '',
              ),
            );
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildSelectedItemRow(
                'Add-on${quantity > 1 ? ' (x$quantity)' : ''}',
                addonModel.name,
                addonModel.price * quantity,
                Icons.add_box,
              ),
            );
          }).toList(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildBillDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bill Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Okra',
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _isBillDetailsExpanded = !_isBillDetailsExpanded),
                icon: Icon(
                  _isBillDetailsExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),

          if (_isBillDetailsExpanded) ...[
            const SizedBox(height: 8),
            _buildBillRow('Package & Add-ons', _packagePrice + _specialServicesPrice + _addonsPrice),
            if (_extraPersonCharges > 0)
              _buildBillRow(
                'Extra Person Charges (${_numberOfPeople - (_currentScreen?.allowedCapacity ?? 0)} ${(_numberOfPeople - (_currentScreen?.allowedCapacity ?? 0)) == 1 ? 'person' : 'people'})',
                _extraPersonCharges,
              ),
            _buildBillRow('Taxes & Fees', _taxes),
            const Divider(),
            _buildBillRow('Total Amount', _totalAmount, isTotal: true),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Advance Payment',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                        Text(
                          'Pay ₹${_advanceAmount.round()} now, remaining ₹${(_totalAmount - _advanceAmount).round()} at venue',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontFamily: 'Okra',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pay Now (Advance)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                  ),
                ),
                Text(
                  '₹${_advanceAmount.round()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Okra',
            ),
          ),
          Text(
            '₹${amount.round()}',
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.primaryColor : Colors.black87,
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Important Notes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• This is an advance payment booking\n'
            '• Remaining amount to be paid at venue\n'
            '• Cancellation allowed up to 24 hours before\n'
            '• Please arrive 15 minutes before your slot',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange[700],
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isProcessingPayment ? null : _proceedToPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: _isProcessingPayment
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payment, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Pay ₹${_advanceAmount.round()} Now',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildErrorContent(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to load checkout',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.refresh(theaterScreenProvider(widget.screenId)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _proceedToPayment() {
    if (_celebrationNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter celebration name',
            style: TextStyle(fontFamily: 'Okra'),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    // TODO: Implement actual payment integration
    // For now, just show a success message
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessingPayment = false;
      });
      
      _showBookingConfirmation();
    });
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your booking for ${_formatDate(DateTime.parse(widget.selectedDate))} has been confirmed.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Okra',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}