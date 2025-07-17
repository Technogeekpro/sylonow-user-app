import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/providers/home_providers.dart';
import '../../home/models/service_listing_model.dart';

class CategoryServicesScreen extends ConsumerStatefulWidget {
  final String categoryName;

  const CategoryServicesScreen({
    super.key,
    required this.categoryName,
  });

  static const String routeName = '/category';

  @override
  ConsumerState<CategoryServicesScreen> createState() => _CategoryServicesScreenState();
}

class _CategoryServicesScreenState extends ConsumerState<CategoryServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  double? _minPrice;
  double? _maxPrice;
  double? _minRating;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterModal(List<ServiceListingModel> allServices) {
    double? tempMinPrice = _minPrice;
    double? tempMaxPrice = _maxPrice;
    double? tempMinRating = _minRating;

    // Calculate price/rating bounds from data
    final prices = allServices
        .map((s) => s.offerPrice ?? s.originalPrice)
        .whereType<double>()
        .toList();
    final minPossiblePrice = prices.isEmpty ? 0.0 : prices.reduce((a, b) => a < b ? a : b);
    final maxPossiblePrice = prices.isEmpty ? 10000.0 : prices.reduce((a, b) => a > b ? a : b);
    final ratings = allServices.map((s) => s.rating ?? 0.0).toList();
    final minPossibleRating = 0.0;
    final maxPossibleRating = ratings.isEmpty ? 5.0 : ratings.reduce((a, b) => a > b ? a : b);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    // Price Range
                    const Text('Price Range (₹)', style: TextStyle(fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Min',
                              border: const OutlineInputBorder(),
                              isDense: true,
                            ),
                            controller: TextEditingController(text: tempMinPrice?.toStringAsFixed(0) ?? ''),
                            onChanged: (v) {
                              setModalState(() {
                                tempMinPrice = double.tryParse(v);
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Max',
                              border: const OutlineInputBorder(),
                              isDense: true,
                            ),
                            controller: TextEditingController(text: tempMaxPrice?.toStringAsFixed(0) ?? ''),
                            onChanged: (v) {
                              setModalState(() {
                                tempMaxPrice = double.tryParse(v);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Rating
                    const Text('Minimum Rating', style: TextStyle(fontWeight: FontWeight.w600)),
                    Slider(
                      value: tempMinRating ?? minPossibleRating,
                      min: minPossibleRating,
                      max: 5.0,
                      divisions: 10,
                      label: (tempMinRating ?? minPossibleRating).toStringAsFixed(1),
                      onChanged: (v) {
                        setModalState(() {
                          tempMinRating = v;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _minPrice = null;
                              _maxPrice = null;
                              _minRating = null;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Clear'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _minPrice = tempMinPrice;
                              _maxPrice = tempMaxPrice;
                              _minRating = tempMinRating;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesByCategoryProvider(widget.categoryName));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search services...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFF34E5F)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE1E2E4)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE1E2E4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF34E5F)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                servicesAsync.maybeWhen(
                  data: (allServices) => IconButton(
                    icon: const Icon(Icons.filter_alt_outlined, color: Color(0xFFF34E5F)),
                    onPressed: () => _openFilterModal(allServices),
                  ),
                  orElse: () => IconButton(
                    icon: const Icon(Icons.filter_alt_outlined, color: Color(0xFFF34E5F)),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: servicesAsync.when(
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error.toString()),
              data: (services) {
                var filtered = services;
                if (_searchQuery.isNotEmpty) {
                  filtered = filtered.where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                }
                if (_minPrice != null) {
                  filtered = filtered.where((s) {
                    final price = s.offerPrice ?? s.originalPrice;
                    return price == null || price >= _minPrice!;
                  }).toList();
                }
                if (_maxPrice != null) {
                  filtered = filtered.where((s) {
                    final price = s.offerPrice ?? s.originalPrice;
                    return price == null || price <= _maxPrice!;
                  }).toList();
                }
                if (_minRating != null) {
                  filtered = filtered.where((s) => (s.rating ?? 0.0) >= _minRating!).toList();
                }
                return _buildServicesList(context, filtered);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.pink),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(BuildContext context, List<ServiceListingModel> services) {
    if (services.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.category_outlined,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'No services in ${widget.categoryName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Check back later for new services in this category',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65
        ,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceImage(context, service);
      },
    );
  }

  Widget _buildServiceImage(BuildContext context, ServiceListingModel service) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/service/${service.id}',
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(70),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            child: CachedNetworkImage(
              imageUrl: service.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 116,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.pink,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,

            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatNumberWithCommas(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}