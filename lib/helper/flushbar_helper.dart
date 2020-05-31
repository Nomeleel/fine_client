import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushBarHelper {
  static void showSuccess({
    @required BuildContext context,
    @required String message,
    String title,
    Duration duration = const Duration(seconds: 3),
  }) {
    Flushbar<dynamic>(
      title: title,
      message: message,
      backgroundColor: Colors.greenAccent,
      duration: duration,
    ).show(context);
  }

  static void showError({
    @required BuildContext context,
    @required String message,
    String title,
    Duration duration = const Duration(seconds: 3),
  }) {
    Flushbar<dynamic>(
      title: title,
      message: message,
      backgroundColor: Colors.redAccent,
      duration: duration,
    ).show(context);
  }

  static void showSuccessAction({
    @required BuildContext context,
    @required String message,
    String title,
    Duration duration = const Duration(seconds: 3),
    @required String actionLabel,
    VoidCallback action,
  }) {
    Flushbar<dynamic>(
      title: title,
      message: message,
      backgroundColor: Colors.greenAccent,
      duration: duration,
      mainButton: FlatButton(
        child: Center(
          child: Text(
            actionLabel,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        onPressed: action,
      ),
    ).show(context);
  }

  static void showErrorAction({
    @required BuildContext context,
    @required String message,
    String title,
    Duration duration = const Duration(seconds: 3),
    @required String actionLabel,
    VoidCallback action,
  }) {
    Flushbar<dynamic>(
      title: title,
      message: message,
      backgroundColor: Colors.redAccent,
      duration: duration,
      mainButton: FlatButton(
        child: Center(
          child: Text(
            actionLabel,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        onPressed: action,
      ),
    ).show(context);
  }
}
