import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

Widget buildEmptyListUi(
  BuildContext context, {
  double? height,
  String? title,
  String? buttonTitle,
  Function? onTap,
  Color? color,
  bool showImages = true,
}) {
  return Container(
    decoration: BoxDecoration(
        color: color ?? AppColors.blueAccent.withAlpha(100),
        borderRadius: BorderRadius.circular(32)),
    alignment: Alignment.center,
    height: height ?? 400,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Text(
              title ?? "You don't have \n any friends,,, yet.",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ))
          ],
        ),
        verticalSpaceMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if(onTap != null) onTap();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(24)),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: Text(
                  buttonTitle ?? 'Add some friends.',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        showImages?verticalSpaceLarge : const SizedBox.shrink(),
        showImages ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1621349375404-01f48593be7a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
                height: 64,
                width: 64,
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.overlay,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1621318165483-1cfd49a88ef5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=751&q=80',
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1620598852012-5ebc7712a3b8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80',
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1596698749858-7a2ce0a09220?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=376&q=80',
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1621377674852-0b332949ef25?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80',
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ) : const SizedBox.shrink(),
      ],
    ),
  );
}
