import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

Widget cwAccountButton(
  BuildContext context,
  String title, {
  required void Function()? onTap,
  double? height,
  double? width,
  bool isPrimaryFocus = true,
  double fontSize = 14,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(14.2),
    onTap: onTap,
    child: Container(
      height: height ?? 40,
      width: width,
      alignment: Alignment.center,
      decoration: isPrimaryFocus
          ? BoxDecoration(
              color: Theme.of(context).colorScheme.blue,
              borderRadius: BorderRadius.circular(14.2))
          : BoxDecoration(
              borderRadius: BorderRadius.circular(14.2),
              border: Border.all(color: Theme.of(context).colorScheme.darkGrey),
            ),
      child: Text(
        title,
        style: isPrimaryFocus
            ? TextStyle(
                fontSize: fontSize,
                color: Theme.of(context).colorScheme.white,
                fontWeight: FontWeight.w600,
              )
            : TextStyle(
                color: Theme.of(context).colorScheme.black,
                fontWeight: FontWeight.w600,
                fontSize: fontSize),
      ),
    ),
  );
}

Widget cwAccountIconButton(BuildContext context,
    {Icon? icon, void Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14.2),
    child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.2),
            border: Border.all(
              color: Theme.of(context).colorScheme.isDarkTheme
                      ? Theme.of(context).colorScheme.lightGrey
                      : Theme.of(context).colorScheme.darkGrey,
            )),
        child: icon ??
            Icon(
              FeatherIcons.send,
              color: Theme.of(context).colorScheme.black,
            )),
  );
}
