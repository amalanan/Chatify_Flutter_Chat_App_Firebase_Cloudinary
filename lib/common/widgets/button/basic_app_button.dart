import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  const BasicAppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.height,
  });

  final VoidCallback onPressed;
  final String title;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 80),
      ),
      onPressed: onPressed,
      child: Text(title, style: TextStyle(color: Colors.white)),
    );
  }
}
