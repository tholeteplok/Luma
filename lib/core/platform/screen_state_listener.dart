import 'dart:async';
import 'package:flutter/services.dart';
import 'package:luma/data/db/models/event_type.dart';
import 'package:luma/data/db/models/raw_event.dart';
import 'package:logging/logging.dart';

/// Platform channel untuk mendengarkan screen state changes (ON/OFF).
/// 
/// Di Android, ini menggunakan BroadcastReceiver untuk SCREEN_ON dan SCREEN_OFF.
/// Di iOS, ini menggunakan DarwinNotificationCenter untuk didLock/lock notifications.
class ScreenStateListener {
  static const platform = MethodChannel('luma/screen_state');
  static final _log = Logger('ScreenStateListener');

  /// Stream controller untuk broadcast screen state events
  final _screenStateController = StreamController<ScreenStateEvent>.broadcast();

  /// Stream yang emit screen state events
  Stream<ScreenStateEvent> get screenStateStream => _screenStateController.stream;

  /// Initialize platform channel listener
  void initialize() async {
    _log.info('Initializing screen state listener');

    platform.setMethodCallHandler((call) async {
      try {
        if (call.method == 'onScreenStateChanged') {
          final isOn = call.arguments as bool;
          final event = ScreenStateEvent(
            timestamp: DateTime.now(),
            type: EventType.screen_state,
            isScreenOn: isOn,
          );

          _log.fine('Screen state changed: ${isOn ? "ON" : "OFF"}');
          _screenStateController.add(event);
        }
      } catch (e) {
        _log.severe('Error handling screen state callback: $e');
      }
    });

    // Invoke method untuk start listening di platform side
    try {
      await platform.invokeMethod('startScreenListening');
      _log.info('Screen state listening started');
    } catch (e) {
      _log.warning('Failed to start screen listening: $e');
    }
  }

  /// Stop listening untuk screen state changes
  Future<void> dispose() async {
    try {
      await platform.invokeMethod('stopScreenListening');
      _log.info('Screen state listening stopped');
    } catch (e) {
      _log.warning('Failed to stop screen listening: $e');
    }

    await _screenStateController.close();
  }

  /// Get current screen state (apakah layar sedang nyala atau tidak)
  Future<bool> isScreenOn() async {
    try {
      final result = await platform.invokeMethod<bool>('isScreenOn');
      return result ?? false;
    } catch (e) {
      _log.severe('Error getting screen state: $e');
      return false;
    }
  }
}

/// Event yang di-emit ketika screen state berubah
class ScreenStateEvent {
  final DateTime timestamp;
  final EventType type;
  final bool isScreenOn;

  ScreenStateEvent({
    required this.timestamp,
    required this.type,
    required this.isScreenOn,
  });

  /// Convert ke RawEvent untuk disimpan ke database
  RawEvent toRawEvent() {
    return RawEvent(
      timestamp: timestamp,
      type: type,
      packageName: '',
      appName: '',
      durationSeconds: 0,
      isForeground: isScreenOn,
      metadata: {
        'event_type': isScreenOn ? 'screen_on' : 'screen_off',
      },
    );
  }
}
