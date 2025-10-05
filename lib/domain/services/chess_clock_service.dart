// file: chess_clock_controller.dart
import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

typedef TimeoutCallback = void Function(Side player);

class ChessClockService {
  // time in milliseconds
  final RxInt whiteTimeMs = 0.obs;
  final RxInt blackTimeMs = 0.obs;

  // config
  int initialTimeMs;
  int incrementMs; // Fischer increment per move in ms

  // runtime
  final Rx<Side> currentTurn = Side.white.obs;
  Timer? _ticker;
  final RxBool isRunning = false.obs;
  final RxBool isPaused = false.obs;
  TimeoutCallback? onTimeout;

  // tick interval: 200ms for responsiveness but we display per second
  static const Duration tickInterval = Duration(milliseconds: 200);

  ChessClockService({
    required this.initialTimeMs,
    this.incrementMs = 0,
    this.onTimeout,
  }) {
    whiteTimeMs.value = initialTimeMs;
    blackTimeMs.value = initialTimeMs;
  }

  int _incrementalValue = 0;
  int get incrementalValue => _incrementalValue;
  // int get whiteTimeSeconds => (whiteTimeMs.value / 1000).ceil();
  // int get blackTimeSeconds => (blackTimeMs.value / 1000).ceil();
  // set incremental value
  void setIncrementalValue({required int value}) {
    _incrementalValue = value;
  }

  /// Start the clock for the currentTurn
  void start() {
    if (isRunning.value) return;
    isRunning.value = true;
    isPaused.value = false;
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(tickInterval, (_) => _onTick());
  }

  void _onTick() {
    if (!isRunning.value || isPaused.value) return;

    final int delta = tickInterval.inMilliseconds;
    if (currentTurn.value == Side.white) {
      whiteTimeMs.value = (whiteTimeMs.value - delta).clamp(
        0,
        initialTimeMs + incrementMs,
      );
      if (whiteTimeMs.value <= 0) _handleTimeout(Side.white);
    } else {
      blackTimeMs.value = (blackTimeMs.value - delta).clamp(
        0,
        initialTimeMs + incrementMs,
      );
      if (blackTimeMs.value <= 0) _handleTimeout(Side.black);
    }
  }

  void _handleTimeout(Side player) {
    stop();
    onTimeout?.call(player);
  }

  /// Switch turn (call this after a move)
  void switchTurn(Side turn) {
    currentTurn.value = turn == Side.white ? Side.black : Side.white;
    // apply increment to the player who just moved (Fischer)
    if (currentTurn.value == Side.white) {
      // white just moved, so add increment to white
      whiteTimeMs.value = (whiteTimeMs.value + incrementMs);
      currentTurn.value = Side.black;
    } else {
      blackTimeMs.value = (blackTimeMs.value + incrementMs);
      currentTurn.value = Side.white;
    }
    if (isRunning.value && _ticker == null) _startTicker();
  }

  void pause() {
    isPaused.value = true;
    _ticker?.cancel();
    _ticker = null;
    isRunning.value = false;
  }

  void resume() {
    if (!isPaused.value) return;
    isPaused.value = false;
    isRunning.value = true;
    _startTicker();
  }

  void stop() {
    isRunning.value = false;
    isPaused.value = false;
    _ticker?.cancel();
    _ticker = null;
  }

  void reset({int? newInitialMs}) {
    stop();
    if (newInitialMs != null) {
      initialTimeMs = newInitialMs;
    }
    whiteTimeMs.value = initialTimeMs;
    blackTimeMs.value = initialTimeMs;
    currentTurn.value = Side.white;
  }

  void onClose() {
    _ticker?.cancel();
  }

  // WidgetsBindingObserver: handle app lifecycle
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // App backgrounded -> pause to avoid time drain (or implement server-side sync)
      if (isRunning.value) {
        pause();
      }
    }
    // Optionally resume on resumed depending on design choice:
    else if (state == AppLifecycleState.resumed) {
      resume();
    }
    // super.didChangeAppLifecycleState(state);
  }
}
