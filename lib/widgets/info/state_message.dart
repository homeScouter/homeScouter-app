import 'package:flutter/material.dart';

class StateMessage extends StatelessWidget {
  final String message;
  final bool isDanger;

  const StateMessage({super.key, required this.message, this.isDanger = true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 42.0, horizontal: 24.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDanger ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
