import 'package:get/get.dart';

import 'package:ecom_modwir/models/user_model.dart';

import 'package:ecom_modwir/services/api_service.dart';

class UsersController extends GetxController {
  var isLoading = false.obs;

  var users = <UserModel>[].obs;

  var filteredUsers = <UserModel>[].obs;

  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      isLoading.value = true;

      final response = await ApiService.getUsers();

      users.value = response;

      filteredUsers.value = response;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load users');
    } finally {
      isLoading.value = false;
    }
  }

  void searchUsers(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredUsers.value = users;
    } else {
      filteredUsers.value = users
          .where((user) =>
              user.fullName.toLowerCase().contains(query.toLowerCase()) ||
              (user.phone?.toLowerCase().contains(query.toLowerCase()) ??
                  false))
          .toList();
    }
  }

  Future<void> updateUserStatus(int userId, String status) async {
    try {
      await ApiService.updateUserStatus(userId, status);

      await loadUsers();

      Get.snackbar('Success', 'User status updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user status');
    }
  }
}
