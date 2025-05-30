class PerformanceMonitor {
  static final Map<String, DateTime> _startTimes = {};

  static final List<PerformanceMetric> _metrics = [];

  static void startTimer(String operation) {
    _startTimes[operation] = DateTime.now();
  }

  static void endTimer(String operation) {
    final startTime = _startTimes[operation];

    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);

      _metrics.add(PerformanceMetric(
        operation: operation,
        duration: duration,
        timestamp: DateTime.now(),
      ));

      // Keep only last 100 metrics

      if (_metrics.length > 100) {
        _metrics.removeAt(0);
      }

      _startTimes.remove(operation);
    }
  }

  static List<PerformanceMetric> getMetrics() {
    return List.from(_metrics);
  }

  static void clearMetrics() {
    _metrics.clear();

    _startTimes.clear();
  }

  static double getAverageTime(String operation) {
    final operationMetrics = _metrics.where((m) => m.operation == operation);

    if (operationMetrics.isEmpty) return 0.0;

    final totalMs = operationMetrics.fold<int>(
      0,
      (sum, metric) => sum + metric.duration.inMilliseconds,
    );

    return totalMs / operationMetrics.length;
  }
}

class PerformanceMetric {
  final String operation;

  final Duration duration;

  final DateTime timestamp;

  PerformanceMetric({
    required this.operation,
    required this.duration,
    required this.timestamp,
  });
}
