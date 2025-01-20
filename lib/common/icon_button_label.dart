import 'package:flutter/material.dart';

class IconButtonWithLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const IconButtonWithLabel({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // Remove default padding
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8), // Spacing between icon and label
          Text(label, style: const TextStyle(fontSize: 12),),
        ],
      ),
    );
  }
}
