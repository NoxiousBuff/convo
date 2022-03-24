import 'package:flutter/material.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

class ChatOptions extends StatelessWidget {
  final String label;
  final IconData icon;
  const ChatOptions({Key? key, required this.label, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          horizontalSpaceSmall,
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
