import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String message, Color color) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
      backgroundColor: color,
    ),
  );
}
