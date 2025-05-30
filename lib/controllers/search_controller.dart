import 'package:get/get.dart';

import '../services/enhanced_api_service.dart';

class AdvancedSearchController extends GetxController {
  var isLoading = false.obs;

  var searchResults = <String, dynamic>{}.obs;

  var searchQuery = ''.obs;

  var searchType = 'global'.obs;

  var recentSearches = <String>[].obs;

  Future<void> performSearch(String query, {String type = 'global'}) async {
    if (query.trim().isEmpty) return;

    try {
      isLoading.value = true;

      searchQuery.value = query;

      searchType.value = type;

      final results = await EnhancedApiService.advancedSearch(
        type: type,
        query: query,
      );

      searchResults.value = results;

      _addToRecentSearches(query);
    } catch (e) {
      Get.snackbar('Error', 'Search failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _addToRecentSearches(String query) {
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);

      if (recentSearches.length > 10) {
        recentSearches.removeLast();
      }
    }
  }

  void clearSearch() {
    searchResults.clear();

    searchQuery.value = '';
  }

  void clearRecentSearches() {
    recentSearches.clear();
  }
}
