import 'dart:async';

import 'package:flutter/services.dart';

class Debouncer {
  final Duration delay;
  late Timer _timer;
  final VoidCallback action;

  Debouncer({
    required this.delay,
    required this.action,
  }) {
    _timer = Timer(delay, action);
  }

  void reset() {
    _timer.cancel();
    _timer = Timer(delay, action);
  }
}
