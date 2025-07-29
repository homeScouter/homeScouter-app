import 'package:flutter/material.dart';

class DangerError extends StatelessWidget {
  final String message;

  const DangerError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 42.0, horizontal: 24.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
