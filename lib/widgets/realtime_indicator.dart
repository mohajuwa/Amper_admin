import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:ecom_modwir/controllers/realtime_controller.dart';

import 'package:ecom_modwir/services/websocket_service.dart';

import 'package:ecom_modwir/constants.dart';

class RealtimeIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wsService = Get.find<WebSocketService>();

    final realtimeController = Get.find<RealtimeController>();

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Connection status

          Row(
            children: [
              Obx(() => Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: wsService.isConnected.value
                          ? Colors.green
                          : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  )),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(() => Text(
                      wsService.connectionStatus.value,
                      style: Theme.of(context).textTheme.bodySmall,
                    )),
              ),
            ],
          ),

          const SizedBox(height: defaultPadding),

          // New orders indicator

          Obx(() {
            if (realtimeController.newOrdersCount.value > 0) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications, color: Colors.orange, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${realtimeController.newOrdersCount.value} new orders',
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          }),

          const SizedBox(height: defaultPadding),

          // Recent events

          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleSmall,
          ),

          const SizedBox(height: 8),

          Obx(() => Column(
                children: realtimeController.realtimeEvents
                    .take(5)
                    .map((event) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                margin: const EdgeInsets.only(top: 6),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      event.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              )),
        ],
      ),
    );
  }
}
