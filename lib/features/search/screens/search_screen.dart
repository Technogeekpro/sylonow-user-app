import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:sylonow_user/features/search/providers/search_providers.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';
import 'package:sylonow_user/core/utils/image_cache_manager.dart';

class SearchScreen extends ConsumerStatefulWidget {
  static const String routeName = '/search';
  
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  String _currentQuery = '';

  // Search suggestions - predefined popular searches
  static const List<String> _searchSuggestions = [
    'Birthday Decoration',
    'Anniversary Setup',
    'Wedding Decoration',
    'Baby Shower',
    'Corporate Events',
    'Theme Parties',
    'Home Cleaning',
    'AC Repair',
    'Plumbing',
    'Electrical Work',
    'Painting',
    'Interior Design',
  ];

  @override
  void initState() {
    super.initState();
    // Auto-focus search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    
    // Debounce search queries - wait 500ms after user stops typing
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty && query.trim() != _currentQuery) {
        setState(() {
          _currentQuery = query.trim();
        });
        // Trigger search with the debounced query
        ref.read(searchResultsProvider(query.trim()));
      }
    });
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      _searchController.text = query;
      setState(() {
        _currentQuery = query.trim();
      });
      // Remove focus to hide keyboard
      _focusNode.unfocus();
      // Trigger search
      ref.read(searchResultsProvider(query.trim()));
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _debounceTimer?.cancel();
    setState(() {
      _currentQuery = '';
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = _currentQuery.isNotEmpty 
        ? ref.watch(searchResultsProvider(_currentQuery))
        : const AsyncValue<List<ServiceListingModel>>.data([]);
    
    final recentSearches = ref.watch(recentSearchesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSearchAppBar(),
      body: Column(
        children: [
          // Search suggestions or results
          Expanded(
            child: _currentQuery.isEmpty
                ? _buildSearchSuggestions(recentSearches)
                : _buildSearchResults(searchResults),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => context.pop(),
      ),
      title: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
          onSubmitted: _performSearch,
          decoration: InputDecoration(
            hintText: 'Search for services...',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: 'Okra',
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                    onPressed: _clearSearch,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Okra',
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions(List<String> recentSearches) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches section
          if (recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Okra',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(recentSearchesProvider.notifier).clearAll();
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Okra',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...recentSearches.map((search) => _buildSearchItem(
              search,
              Icons.history,
              onTap: () => _performSearch(search),
              onDelete: () => ref.read(recentSearchesProvider.notifier).remove(search),
            )),
            const SizedBox(height: 24),
          ],
          
          // Popular searches section
          const Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 8),
          ..._searchSuggestions.map((suggestion) => _buildSearchItem(
            suggestion,
            Icons.trending_up,
            onTap: () => _performSearch(suggestion),
          )),
        ],
      ),
    );
  }

  Widget _buildSearchItem(
    String text,
    IconData icon, {
    required VoidCallback onTap,
    VoidCallback? onDelete,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey, size: 20),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Okra',
        ),
      ),
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.close, color: Colors.grey, size: 18),
              onPressed: onDelete,
            )
          : const Icon(Icons.north_west, color: Colors.grey, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
    );
  }

  Widget _buildSearchResults(AsyncValue<List<ServiceListingModel>> searchResults) {
    return searchResults.when(
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.pink),
            SizedBox(height: 16),
            Text(
              'Searching...',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => _buildErrorState(error),
      data: (services) {
        if (services.isEmpty) {
          return _buildEmptyState();
        }
        
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(searchResultsProvider(_currentQuery));
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildServiceCard(service);
            },
          ),
        );
      },
    );
  }

  Widget _buildServiceCard(ServiceListingModel service) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Add to recent searches
          ref.read(recentSearchesProvider.notifier).add(_currentQuery);
          // Navigate to service detail - implement this route
          // context.push('/service-detail/${service.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Service image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: service.imageUrl?.isNotEmpty == true
                    ? AppImageCacheManager.buildOptimizedNetworkImage(
                        imageUrl: service.imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              
              // Service details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Okra',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (service.description?.isNotEmpty == true)
                      Text(
                        service.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'Okra',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (service.price != null) ...[
                          Text(
                            '₹${service.price}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                              fontFamily: 'Okra',
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (service.rating != null) ...[
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber[600],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            service.rating!.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'Okra',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Book',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Okra',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No results found for "$_currentQuery"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords\nor browse our categories',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _clearSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Try New Search',
              style: TextStyle(fontFamily: 'Okra'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(searchResultsProvider(_currentQuery));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(fontFamily: 'Okra'),
            ),
          ),
        ],
      ),
    );
  }
}