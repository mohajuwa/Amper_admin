import 'package:get/get.dart';
import 'package:ecom_modwir/models/payment_model.dart';
import 'package:ecom_modwir/services/api_service.dart';

class PaymentsController extends GetxController {
  var isLoading = false.obs;
  var payments = <PaymentModel>[].obs;
  var filteredPayments = <PaymentModel>[].obs;
  var selectedStatus = 'all'.obs;
  var totalAmount = 0.0.obs;
  var completedAmount = 0.0.obs;
  var pendingAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      isLoading.value = true;
      final response = await ApiService.getPayments();
      payments.value = response;
      filteredPayments.value = response;
      _calculateTotals();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load payments');
    } finally {
      isLoading.value = false;
    }
  }

  void filterPayments(String status) {
    selectedStatus.value = status;
    if (status == 'all') {
      filteredPayments.value = payments;
    } else {
      filteredPayments.value =
          payments.where((payment) => payment.paymentStatus == status).toList();
    }
  }

  void _calculateTotals() {
    totalAmount.value =
        payments.fold(0.0, (sum, payment) => sum + payment.amount);
    completedAmount.value = payments
        .where((p) => p.paymentStatus == 'completed')
        .fold(0.0, (sum, payment) => sum + payment.amount);
    pendingAmount.value = payments
        .where((p) => p.paymentStatus == 'pending')
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }
}
