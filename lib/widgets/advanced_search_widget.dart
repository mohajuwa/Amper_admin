import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controllers/search_controller.dart';
import 'package:ecom_modwir/constants.dart';

class AdvancedSearchWidget extends StatelessWidget {
  final AdvancedSearchController searchController =
      Get.put(AdvancedSearchController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          // Search input with filters
          Row(
            children: [
              // Search type dropdown
              Obx(() => DropdownButton<String>(
                    value: searchController.searchType.value,
                    items: [
                      DropdownMenuItem(value: 'global', child: Text('All')),
                      DropdownMenuItem(value: 'orders', child: Text('Orders')),
                      DropdownMenuItem(value: 'users', child: Text('Users')),
                      DropdownMenuItem(
                          value: 'vehicles', child: Text('Vehicles')),
                      DropdownMenuItem(
                          value: 'services', child: Text('Services')),
                    ],
                    onChanged: (value) {
                      searchController.searchType.value = value!;
                    },
                  )),

              const SizedBox(width: defaultPadding),

              // Search input
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Obx(() => searchController.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              textController.clear();
                              searchController.clearSearch();
                            },
                          )),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (value) {
                    searchController.performSearch(value,
                        type: searchController.searchType.value);
                  },
                ),
              ),

              const SizedBox(width: defaultPadding),

              // Search button
              ElevatedButton.icon(
                onPressed: () {
                  searchController.performSearch(
                    textController.text,
                    type: searchController.searchType.value,
                  );
                },
                icon: const Icon(Icons.search),
                label: Text('Search'),
              ),
            ],
          ),

          const SizedBox(height: defaultPadding),

          // Recent searches
          Obx(() {
            if (searchController.recentSearches.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Searches',
                          style: Theme.of(context).textTheme.titleSmall),
                      TextButton(
                        onPressed: searchController.clearRecentSearches,
                        child: Text('Clear'),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: searchController.recentSearches
                        .take(5)
                        .map(
                          (search) => Chip(
                            label: Text(search),
                            onDeleted: () =>
                                searchController.recentSearches.remove(search),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              );
            }
            return const SizedBox.shrink();
          }),

          // Search results
          Obx(() {
            if (searchController.searchResults.isEmpty) {
              return const SizedBox.shrink();
            }

            return SearchResultsWidget(results: searchController.searchResults);
          }),
        ],
      ),
    );
  }
}

class SearchResultsWidget extends StatelessWidget {
  final Map<String, dynamic> results;

  const SearchResultsWidget({Key? key, required this.results})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Search Results', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: defaultPadding),
        ...results.entries.map((entry) {
          final categoryName = entry.key;
          final items = List<Map<String, dynamic>>.from(entry.value);

          if (items.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                categoryName.capitalize!,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              ...items.map((item) => ListTile(
                    title: Text(item['title'] ?? 'Unknown'),
                    subtitle: Text(item['subtitle'] ?? ''),
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.1),
                      child: Icon(
                        _getIconForType(item['type']),
                        color: primaryColor,
                      ),
                    ),
                    onTap: () => _navigateToDetails(item),
                  )),
              const SizedBox(height: defaultPadding),
            ],
          );
        }).toList(),
      ],
    );
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'user':
        return Icons.person;
      case 'order':
        return Icons.shopping_cart;
      case 'service':
        return Icons.build;
      case 'vehicle':
        return Icons.directions_car;
      default:
        return Icons.search;
    }
  }

  void _navigateToDetails(Map<String, dynamic> item) {
    // Implement navigation based on item type
    Get.snackbar('Info', 'Navigate to ${item['type']} details');
  }
}
