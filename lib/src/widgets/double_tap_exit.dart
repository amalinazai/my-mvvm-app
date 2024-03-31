import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_mvvm_app/src/constants/settings.dart';
import 'package:my_mvvm_app/src/widgets/common_snackbar.dart';

/// Wrap around a widget to prevent a user from accidentally closing the app
/// by accident. This widget will display a snackbar informing users to tap 
/// the exit button again if they are looking to quit. 
class DoubleTapExit extends StatefulWidget {
  const DoubleTapExit({
    required this.child,
    this.onWillPopOverride,
    super.key,
  });
  final Widget child;
  final Future<bool> Function()? onWillPopOverride;

  @override
  DoubleTapExitState createState() => DoubleTapExitState();
}

class DoubleTapExitState extends State<DoubleTapExit> {
  int? _lastTimeBackButtonWasTapped;

  bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    if (_isAndroid) {
      return PopScope(
        onPopInvoked: (didPop) async => widget.onWillPopOverride != null
            ? widget.onWillPopOverride!()
            : _handleWillPop(),
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  Future<bool> _handleWillPop() async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (_lastTimeBackButtonWasTapped != null &&
        (currentTime - _lastTimeBackButtonWasTapped!) <
            androidDoubleTapExitDelayMs) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      exit(1);
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      CommonSnackbar.show(
        title: 'Tap again to exit.',
      );
      return false;
    }
  }
}
