import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

Widget cwEADescriptionTitle(BuildContext context, String title,
    {TextAlign textAlign = TextAlign.start}) {
  return Text(
    title,
    textAlign: textAlign,
    style: const TextStyle(
      fontSize: 14,
      color: AppColors.mediumBlack,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget cwEATextField(
    BuildContext context, TextEditingController controller, String hintText,
    {int? maxLength,
    bool expands = false,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    bool autoFocus = false, List<TextInputFormatter>? inputFormatters, TextInputAction textInputAction = TextInputAction.done}) {
  return TextFormField(
    inputFormatters: inputFormatters,
    textInputAction: textInputAction,
    controller: controller,
    maxLength: maxLength,
    minLines: 1,
    maxLines: null,
    validator: validator,
    autofocus: autoFocus,
    maxLengthEnforcement: MaxLengthEnforcement.enforced,
    style:  TextStyle(
        fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.black),
    showCursor: true,
    cursorColor: AppColors.blue,
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
  String? subtitle,
  void Function()? onTap,
  Color? titleColor,
  bool showTrailingIcon = true,
  bool isLoading = false,
  EdgeInsets? padding,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 0),
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
                        color: titleColor ?? AppColors.black,
                        fontSize: 20),
                  ),
                  subtitle != null ? verticalSpaceTiny : shrinkBox,
                  subtitle != null
                      ? Text(
                          subtitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.mediumBlack,
                          ),
                        )
                      : shrinkBox,
                ],
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
                          AppColors.mediumBlack,
                        ),
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                : showTrailingIcon
                    ? const Icon(
                        FeatherIcons.chevronRight,
                        color: AppColors.mediumBlack,
                        size: 28,
                      )
                    : const SizedBox.shrink(),
          ],
        ),
      ),
    ),
  );
}

Widget cwEAHeading(String title,
    {MainAxisSize mainAxisSize = MainAxisSize.max,
    TextAlign textAlign = TextAlign.start,
    Color? color,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Flexible(
          flex: 1,
          child: Text(
            title,
            textAlign: textAlign,
            textWidthBasis: TextWidthBasis.parent,
            style: TextStyle(
                color: color ?? AppColors.black, fontWeight: FontWeight.w700, fontSize: 32),
          ),
        ),
      ],
    ),
  );
}
