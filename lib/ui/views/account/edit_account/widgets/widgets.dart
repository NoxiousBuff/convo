import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

Widget cwEADescriptionTitle(BuildContext context, String title,
    {TextAlign textAlign = TextAlign.start}) {
  return Text(
    title,
    textAlign: textAlign,
    style:  TextStyle(
      fontSize: 14,
      color: Theme.of(context).colorScheme.mediumBlack,
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
        fontSize: 28, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.black),
    showCursor: true,
    cursorColor: Theme.of(context).colorScheme.blue,
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
  Color? color,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        color: color,
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
                        color: titleColor ?? Theme.of(context).colorScheme.black,
                        fontSize: 20),
                  ),
                  subtitle != null ? verticalSpaceTiny : shrinkBox,
                  subtitle != null
                      ? Text(
                          subtitle,
                          style:  TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.mediumBlack,
                          ),
                        )
                      : shrinkBox,
                ],
              ),
            ),
            horizontalDefaultMessageSpace,
            isLoading
                ?  Center(
                    child: SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.mediumBlack,
                        ),
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                : showTrailingIcon
                    ?  Icon(
                        FeatherIcons.chevronRight,
                        color: Theme.of(context).colorScheme.mediumBlack,
                        size: 28,
                      )
                    : const SizedBox.shrink(),
          ],
        ),
      ),
    ),
  );
}

// Widget cwEAHeading(String title,
//     {MainAxisSize mainAxisSize = MainAxisSize.max,
//     TextAlign textAlign = TextAlign.start,
//     Color? color,
//     MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 12),
//     child: Row(
//       mainAxisSize: mainAxisSize,
//       mainAxisAlignment: mainAxisAlignment,
//       children: [
//         Flexible(
//           flex: 1,
//           child: Text(
//             title,
//             textAlign: textAlign,
//             textWidthBasis: TextWidthBasis.parent,
//             style: TextStyle(
//                 color: color ?? Theme.of(context).colorScheme.black, fontWeight: FontWeight.w700, fontSize: 32),
//           ),
//         ),
//       ],
//     ),
//   );
// }

class CWEAHeading extends StatelessWidget {
  const CWEAHeading( this.title, { Key? key , this.mainAxisSize = MainAxisSize.max, this.color, this.textAlign = TextAlign.start, this.mainAxisAlignment = MainAxisAlignment.start }) : super(key: key);

  final String title;
  final MainAxisSize mainAxisSize;
  final TextAlign textAlign;
  final Color? color;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
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
                color: color ?? Theme.of(context).colorScheme.black, fontWeight: FontWeight.w700, fontSize: 32),
          ),
        ),
      ],
    ),
  );
  }
}