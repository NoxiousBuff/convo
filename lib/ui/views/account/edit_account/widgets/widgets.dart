import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

Widget cwEADescriptionTitle(BuildContext context, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Widget cwEATextField(
    BuildContext context, TextEditingController controller, String hintText,
    {int? maxLength, bool expands = false}) {
  return TextField(
    controller: controller,
    maxLength: maxLength ?? TextField.noMaxLength,
    minLines: 1,
    maxLines: 10,
    maxLengthEnforcement: MaxLengthEnforcement.enforced,
    style: const TextStyle(
        fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black87),
    showCursor: true,
    cursorColor: LightAppColors.primary,
    cursorHeight: 32,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      contentPadding: const EdgeInsets.all(0),
      border: const OutlineInputBorder(
          borderSide: BorderSide.none, gapPadding: 0.0),
    ),
  );
}

Widget cwEADetailsTile(BuildContext context, String title,
    {String descriptionTitle = '', void Function()? onTap, Color? titleColor}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w700, color: titleColor ?? Colors.black, fontSize: 20),
          ),
          const Spacer(),
          Text(
            descriptionTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
          horizontalDefaultMessageSpace,
          const Icon(
            FeatherIcons.chevronRight,
            color: Colors.black54,
            size: 28,
          ),
        ],
      ),
    ),
  );
}
