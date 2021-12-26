import 'package:flutter/material.dart';

class FlushBarHelper {
  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    // TODO(Nomeleel): 是的 你要被开除了
    /*
    Flushbar<dynamic>(
      title: title,
      message: message,
      backgroundColor: Colors.greenAccent,
      duration: duration,
    ).show(context);
    */
  }

  static void showError({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    // TODO(Nomeleel): 是的 你要被开除了
    /*
    Flushbar<dynamic>(
      title: title,
      message: message,
      backgroundColor: Colors.redAccent,
      duration: duration,
    ).show(context);
    */
  }

  static void showSuccessAction({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    required String actionLabel,
    required VoidCallback action,
  }) {
    // TODO(Nomeleel): 是的 你要被开除了
    /*
    Flushbar<dynamic>(
      title: title,
      message: message,
      backgroundColor: Colors.greenAccent,
      duration: duration,
      mainButton: TextButton(
        child: Center(
          child: Text(
            actionLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        onPressed: action,
      ),
    ).show(context);
    */
  }

  static void showErrorAction({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    required String actionLabel,
    required VoidCallback action,
  }) {
    // TODO(Nomeleel): 是的 你要被开除了
    /*
    Flushbar<dynamic>(
      title: title,
      message: message,
      backgroundColor: Colors.redAccent,
      duration: duration,
      mainButton: TextButton(
        child: Center(
          child: Text(
            actionLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        onPressed: action,
      ),
    ).show(context);
    */
  }
}
