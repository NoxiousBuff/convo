import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

Widget cwEADescriptionTitle(BuildContext context, String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget cwEATextField(
    BuildContext context, TextEditingController controller, String hintText,
    {int? maxLength, bool expands = false, void Function(String)? onChanged, String? Function(String?)? validator}) {
  return TextFormField(
    controller: controller,
    maxLength: maxLength,
    minLines: 1,
    maxLines: 10,
    validator: validator,
    maxLengthEnforcement: MaxLengthEnforcement.enforced,
    style: const TextStyle(
        fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black87),
    showCursor: true,
    cursorColor: LightAppColors.primary,
    cursorHeight: 32,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      contentPadding: const EdgeInsets.all(0),
      border: const OutlineInputBorder(
          borderSide: BorderSide.none, gapPadding: 0.0),
    ),
  );
}

Widget cwEADetailsTile(
  BuildContext context,
  String title, {
  String descriptionTitle = '',
  String? subtitle,
  void Function()? onTap,
  Color? titleColor,
  bool showTrailingIcon = true,
  bool isLoading = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: titleColor ?? Colors.black,
                      fontSize: 20),
                ),
                subtitle != null ? verticalSpaceTiny : shrinkBox,
                subtitle != null
                    ? Text(
                        subtitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      )
                    : shrinkBox,
              ],
            ),
          ),
          // const Spacer(),
          Text(
            descriptionTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
          horizontalDefaultMessageSpace,
          isLoading
              ? const Center(
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Colors.black54,
                      ),
                      strokeWidth: 1.5,
                    ),
                  ),
                )
              : showTrailingIcon
                  ? const Icon(
                      FeatherIcons.chevronRight,
                      color: Colors.black54,
                      size: 28,
                    )
                  : const SizedBox.shrink(),
        ],
      ),
    ),
  );
}

Widget cwEAHeading(String title, {MainAxisSize mainAxisSize = MainAxisSize.max, TextAlign textAlign = TextAlign.start,  Color color = Colors.black}) {

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: textAlign,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w700, fontSize: 32),
        ),
      ],
    ),
  );
}
