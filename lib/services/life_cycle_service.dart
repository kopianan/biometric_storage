import 'package:biometric/services/stoppable_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService extends StoppableService {
  final lastKnownStateKey = 'lastKnownStateKey';
  final backgroundedTimeKey = 'backgroundedTimeKey';

  Future _paused() async {
    final sp = await SharedPreferences.getInstance();
    sp.setInt(lastKnownStateKey, AppLifecycleState.paused.index);
  }

  Future _inactive() async {
    print('inactive');
    final sp = await SharedPreferences.getInstance();
    final prevState = sp.getInt(lastKnownStateKey);

    final prevStateIsNotPaused = prevState != null &&
        AppLifecycleState.values[prevState] != AppLifecycleState.paused;

    if (prevStateIsNotPaused) {
      sp.setInt(backgroundedTimeKey, DateTime.now().millisecondsSinceEpoch);
    }

    sp.setInt(lastKnownStateKey, AppLifecycleState.inactive.index);
  }

  final pinLockMillis = 2000;
  Future _resumed() async {
    print('resumed');
    final sp = await SharedPreferences.getInstance();

    final bgTime = sp.getInt(backgroundedTimeKey) ?? 0;
    final allowedBackgroundTime = bgTime + pinLockMillis;
    final shouldShowPIN =
        DateTime.now().millisecondsSinceEpoch > allowedBackgroundTime;

    if (shouldShowPIN) {
      // show PIN screen
      print("Go to pin screen");
    }

    sp.remove(backgroundedTimeKey);
    sp.setInt(lastKnownStateKey, AppLifecycleState.resumed.index);
  }

  @override
  void start() {
    super.start();
    _resumed();
    // start subscription again
  }

  @override
  void stop() {
    super.stop();
    _paused();
    // cancel stream subscription
  }
}
