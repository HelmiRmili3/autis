import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/enums/notification_enum.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// Shows an auto-dismissible notification (disappears after timeout)
  void showAutoDismissibleNotification({
    required dynamic message,
    required NotificationType type,
    ToastGravity gravity = ToastGravity.TOP,
    int durationSeconds = 3,
  }) {
    final (bgColor, textColor, webBgColor) = _getColorsForType(type);

    Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: _getToastLength(durationSeconds),
      gravity: gravity,
      backgroundColor: bgColor,
      textColor: textColor,
      timeInSecForIosWeb: durationSeconds,
      webShowClose: false, // No close button for auto-dismiss
      webBgColor: webBgColor,
    );
  }

  /// Shows a dismissible notification (user must click to dismiss)
  void showDismissibleNotification({
    required dynamic message,
    required NotificationType type,
    ToastGravity gravity = ToastGravity.TOP,
  }) {
    final (bgColor, textColor, webBgColor) = _getColorsForType(type);

    Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_LONG, // Long duration for dismissible
      gravity: gravity,
      backgroundColor: bgColor,
      textColor: textColor,
      timeInSecForIosWeb: 0, // Doesn't auto-dismiss
      webShowClose: true, // Show close button
      webBgColor: webBgColor,
    );
  }

  // Helper methods
  (Color, Color, String) _getColorsForType(NotificationType type) {
    return switch (type) {
      NotificationType.error => (
          Colors.red[700]!,
          Colors.white,
          "linear-gradient(to right, #ff0000, #cc0000)"
        ),
      NotificationType.warning => (
          Colors.orange[700]!,
          Colors.white,
          "linear-gradient(to right, #ff8c00, #ff6b00)"
        ),
      NotificationType.success => (
          Colors.green[700]!,
          Colors.white,
          "linear-gradient(to right, #4CAF50, #2E7D32)"
        ),
    };
  }

  Toast _getToastLength(int seconds) {
    return switch (seconds) {
      <= 2 => Toast.LENGTH_SHORT,
      >= 5 => Toast.LENGTH_LONG,
      _ => Toast.LENGTH_SHORT, // Default
    };
  }

  void showCustomManualDismissNotification({
    required BuildContext context,
    required String message,
    required NotificationType type,
    String buttonText = 'OK',
    VoidCallback? onDismiss,
  }) {
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: _NotificationCard(
            message: message,
            type: type,
            buttonText: buttonText,
            onDismiss: () {
              overlayEntry!.remove();
              onDismiss?.call();
            },
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }
}

class _NotificationCard extends StatelessWidget {
  final String message;
  final NotificationType type;
  final String buttonText;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.message,
    required this.type,
    required this.buttonText,
    required this.onDismiss,
  });

  (Color, Color) _getColorsForType(NotificationType type) {
    return switch (type) {
      NotificationType.error => (Colors.red[700]!, Colors.white),
      NotificationType.warning => (Colors.orange[700]!, Colors.white),
      NotificationType.success => (Colors.green[700]!, Colors.white),
    };
  }

  IconData? _getIconForType(NotificationType type) {
    return switch (type) {
      NotificationType.error => Icons.error_outline,
      NotificationType.warning => Icons.warning_amber_rounded,
      NotificationType.success => Icons.check_circle_outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor) = _getColorsForType(type);
    final icon = _getIconForType(type);

    return Card(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor),
              ),
            ),
            TextButton(
              onPressed: onDismiss,
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
