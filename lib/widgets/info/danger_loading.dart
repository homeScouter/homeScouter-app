import 'package:flutter/material.dart';

class DangerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 42.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
