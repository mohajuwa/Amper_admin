import 'dart:convert';

import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:get/get.dart';



class WebSocketService extends GetxService {

  WebSocketChannel? _channel;

  var isConnected = false.obs;

  var connectionStatus = 'Disconnected'.obs;

  var lastMessage = <String, dynamic>{}.obs;

  

  final String _wsUrl = 'ws://modwir.com:8080';

  final Map<String, List<Function(Map<String, dynamic>)>> _listeners = {};

  

  // Auto-reconnection

  var _reconnectAttempts = 0;

  final int _maxReconnectAttempts = 5;

  var _reconnectTimer;



  @override

  void onInit() {

    super.onInit();

    connect();

  }



  void connect() async {

    try {

      connectionStatus.value = 'Connecting...';

      

      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));

      

      await _channel!.ready;

      

      isConnected.value = true;

      connectionStatus.value = 'Connected';

      _reconnectAttempts = 0;

      

      // Listen for messages

      _channel!.stream.listen(

        _handleMessage,

        onError: _handleError,

        onDone: _handleDisconnection,

      );

      

      // Send ping every 30 seconds

      _startPingTimer();

      

    } catch (e) {

      _handleError(e);

    }

  }



  void _handleMessage(dynamic message) {

    try {

      final data = jsonDecode(message);

      lastMessage.value = data;

      

      final type = data['type'];

      if (type != null && _listeners.containsKey(type)) {

        for (final listener in _listeners[type]!) {

          listener(data);

        }

      }

      

      // Handle built-in message types

      switch (type) {

        case 'auth_success':

          print('WebSocket authenticated successfully');

          break;

        case 'auth_error':

          print('WebSocket authentication failed: ${data['message']}');

          break;

        case 'pong':

          // Keep alive response

          break;

      }

      

    } catch (e) {

      print('Error parsing WebSocket message: $e');

    }

  }



  void _handleError(error) {

    print('WebSocket error: $error');

    isConnected.value = false;

    connectionStatus.value = 'Error: $error';

    _attemptReconnection();

  }



  void _handleDisconnection() {

    print('WebSocket disconnected');

    isConnected.value = false;

    connectionStatus.value = 'Disconnected';

    _attemptReconnection();

  }



  void _attemptReconnection() {

    if (_reconnectAttempts < _maxReconnectAttempts) {

      _reconnectAttempts++;

      final delay = Duration(seconds: _reconnectAttempts * 2);

      connectionStatus.value = 'Reconnecting in ${delay.inSeconds}s...';

      

      _reconnectTimer = Future.delayed(delay, () {

        if (!isConnected.value) {

          connect();

        }

      });

    } else {

      connectionStatus.value = 'Connection failed';

    }

  }



  void authenticate(String token) {

    if (isConnected.value) {

      send({

        'type': 'authenticate',

        'token': token,

      });

    }

  }



  void subscribe(String channel) {

    if (isConnected.value) {

      send({

        'type': 'subscribe',

        'channel': channel,

      });

    }

  }



  void send(Map<String, dynamic> data) {

    if (isConnected.value && _channel != null) {

      _channel!.sink.add(jsonEncode(data));

    }

  }



  void addListener(String eventType, Function(Map<String, dynamic>) callback) {

    if (!_listeners.containsKey(eventType)) {

      _listeners[eventType] = [];

    }

    _listeners[eventType]!.add(callback);

  }



  void removeListener(String eventType, Function(Map<String, dynamic>) callback) {

    if (_listeners.containsKey(eventType)) {

      _listeners[eventType]!.remove(callback);

    }

  }



  void _startPingTimer() {

    Future.delayed(Duration(seconds: 30), () {

      if (isConnected.value) {

        send({'type': 'ping'});

        _startPingTimer();

      }

    });

  }



  @override

  void onClose() {

    _channel?.sink.close();

    _reconnectTimer?.cancel();

    super.onClose();

  }

}
