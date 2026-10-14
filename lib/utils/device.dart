import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Native channel exposing Android form factor information.
const MethodChannel deviceChannel = MethodChannel('com.predidit.kazumi/device');

bool _isTelevision = false;
bool _televisionProbed = false;

/// Whether the app currently runs on an Android TV / Google TV / TV box.
///
/// Returns false until [initializeTelevisionStatus] has completed, so widgets
/// can query it synchronously during the first frame.
bool isTelevision() => _isTelevision;

/// Detects the Android TV form factor once, during startup.
Future<void> initializeTelevisionStatus() async {
  if (_televisionProbed) {
    return;
  }
  _televisionProbed = true;
  if (!Platform.isAndroid) {
    return;
  }
  try {
    _isTelevision = await deviceChannel.invokeMethod<bool>('isTelevision') ?? false;
  } on PlatformException catch (e) {
    debugPrint('Device: television detection failed: $e');
  } on MissingPluginException {
    // Platforms without the native channel are never televisions.
  }
}

/// Whether the app runs on any device driven by a remote control.
///
/// Some Android TV boxes do not expose the leanback feature; the platform
/// reporting directional navigation is the fallback signal.
bool isDpadDriven(BuildContext context) {
  if (isTelevision()) {
    return true;
  }
  return MediaQuery.maybeNavigationModeOf(context) == NavigationMode.directional;
}

Future<bool> isLowResolution() async {
  if (Platform.isMacOS) {
    return false;
  }
  final screenInfo = await getScreenInfo();
  return screenInfo['height']! / screenInfo['ratio']! < 900;
}

Future<Map<String, double>> getScreenInfo() async {
  final mediaQuery = MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.views.first,
  );
  final screenSize =
      WidgetsBinding.instance.platformDispatcher.displays.first.size;
  return {
    'width': screenSize.width,
    'height': screenSize.height,
    'ratio': mediaQuery.devicePixelRatio,
  };
}

bool isDesktop() {
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}
