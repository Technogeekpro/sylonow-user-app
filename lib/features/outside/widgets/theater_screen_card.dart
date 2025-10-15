import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/price_calculator.dart';
import '../models/theater_screen_model.dart';
import '../screens/theater_screen_detail_screen.dart';

class TheaterScreenCard extends StatelessWidget {
  const TheaterScreenCard({
    super.key,
    required this.screen,
    this.selectedAddress,
  });

  final TheaterScreen screen;
  final dynamic selectedAddress;

  @override
  Widget build(BuildContext context) {
    // Use the hourly rate as base price and calculate theater listing price with fees
    final basePrice = screen.hourlyRate;
    final totalPriceWithFees = PriceCalculator.calculateTheaterListingPriceWithTaxes(basePrice);

    // For display purposes, show the base price as discounted and calculate original from total
    final discountedPrice = basePrice;
    final originalPrice = totalPriceWithFees;
    final discountAmount = originalPrice - discountedPrice;

    return GestureDetector(
      onTap: () {
        // Navigate to theater screen detail
        context.push(TheaterScreenDetailScreen.routeName, extra: {
          'screen': screen,
          'selectedDate': DateTime.now().toIso8601String().split('T')[0],
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            _buildImageSection(),

            // Content Section
            _buildContentSection(
              discountedPrice,
              originalPrice,
              discountAmount,
              basePrice,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Expanded(
      flex: 7,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFD4D4D4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: screen.images?.isNotEmpty == true
              ? Image.network(
                  screen.images!.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFD4D4D4),
                      child: Icon(
                        Icons.movie,
                        size: 32,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                )
              : Icon(Icons.movie, size: 32, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildContentSection(
    double discountedPrice,
    double originalPrice,
    double discountAmount,
    double basePrice,
  ) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPricingSection(discountedPrice, originalPrice),
            const SizedBox(height: 2),
            _buildDiscountSection(discountAmount),
            _buildScreenDetailsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection(double discountedPrice, double originalPrice) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Green Price Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF33872E),
            borderRadius: BorderRadius.circular(4),
            border: const Border(
              bottom: BorderSide(color: Color(0xFF04401A), width: 2),
              right: BorderSide(color: Color(0xFF04401A), width: 2),
            ),
          ),
          child: Text(
            '₹${discountedPrice.round()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              fontFamily: 'Okra',
            ),
          ),
        ),
        const SizedBox(width: 4),
        // Original Price (Strikethrough)
        Text(
          '₹${originalPrice.round()}',
          style: const TextStyle(
            color: Color(0xFF505661),
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily: 'Okra',
            decoration: TextDecoration.lineThrough,
            decorationColor: Color(0xFF505661),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountSection(double discountAmount) {
    return Row(
      children: [
        // Discount Amount
        Text(
          '₹${discountAmount.round()} OFF',
          style: const TextStyle(
            color: Color(0xFF33872E),
            fontSize: 9,
            fontWeight: FontWeight.w500,
            fontFamily: 'Okra',
          ),
        ),
        const SizedBox(width: 4),
        // Decorative Dashed Line
        Expanded(
          child: SizedBox(
            height: 1,
            child: LayoutBuilder(
              builder: (context, constraints) {
                const dashWidth = 4.0;
                const dashSpace = 4.0;
                final dashCount =
                    (constraints.constrainWidth() / (dashWidth + dashSpace))
                        .floor();
                return Row(
                  children: List.generate(dashCount, (index) {
                    return Container(
                      width: dashWidth,
                      height: 1,
                      margin: EdgeInsets.only(
                        right: index < dashCount - 1 ? dashSpace : 0,
                      ),
                      color: Colors.grey[400],
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScreenDetailsSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Screen Name
          Text(
            screen.screenName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Capacity Info
          Row(
            children: [
              //Seat Icon from Hero package
              Icon(Icons.event_seat, color: Colors.grey[600], size: 10),
              const SizedBox(width: 4),
              Text(
                '${screen.allowedCapacity} Seats',
                style: const TextStyle(
                  color: Color(0xFF666E7B),
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
