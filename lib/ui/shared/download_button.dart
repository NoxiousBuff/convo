import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'ui_helpers.dart';

class DownloadButton extends StatelessWidget {
  final String buttonTitle;
  final void Function()? onTap;
  const DownloadButton({Key? key, this.onTap, required this.buttonTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              buttonTitle,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            horizontalSpaceTiny,
            const Icon(FeatherIcons.arrowDown, color: Colors.white)
          ],
        ),
      ),
    );
  }
}
