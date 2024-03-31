import 'dart:async';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_mvvm_app/app.dart';
import 'package:my_mvvm_app/src/services/locator_service.dart';
import 'package:my_mvvm_app/src/settings/debug_settings.dart';

Future<void> initializeApp() async {
  /// Prevents debug logs from being printed in release mode
  if (kReleaseMode) {
    debugPrint = (_, {int? wrapWidth}) {};
  }

  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode && showDeviceBuilder,
      builder: (context) => const App(),
    ),
  );
}
