import 'dart:async';

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:get/get.dart';

import 'package:ecom_modwir/utils/app_utils.dart';

class NetworkService extends GetxService {
  static NetworkService get to => Get.find();

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  var isConnected = true.obs;

  var connectionType = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();

    _initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();

    super.onClose();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();

      _updateConnectionStatus(result);
    } catch (e) {
      isConnected.value = false;
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    connectionType.value = result;

    isConnected.value = result != ConnectivityResult.none;

    if (!isConnected.value) {
      AppUtils.showError('No internet connection');
    }
  }

  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  String get connectionStatusText {
    switch (connectionType.value) {
      case ConnectivityResult.wifi:
        return 'Connected via WiFi';

      case ConnectivityResult.mobile:
        return 'Connected via Mobile Data';

      case ConnectivityResult.ethernet:
        return 'Connected via Ethernet';

      case ConnectivityResult.none:
        return 'No Connection';

      default:
        return 'Unknown Connection';
    }
  }
}
