import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

class DuleAlertDialog extends StatelessWidget {
  const DuleAlertDialog({
    Key? key,
    required this.title,
    required this.icon,
    required this.primaryButtonText,
    this.description,
    this.descriptionTextStyle,
    this.iconBackgroundColor,
    this.primaryButtonTextStyle,
    this.secondaryButtonTextStyle,
    this.secondaryButtontext,
    this.titleTextStyle,
    this.backgroundColor,
    required this.primaryOnPressed,
    this.secondaryOnPressed,
    this.iconColor,
  }) : super(key: key);

  final String title;
  final TextStyle? titleTextStyle;
  final IconData icon;
  final Color? iconBackgroundColor;
  final String? description;
  final TextStyle? descriptionTextStyle;
  final String primaryButtonText;
  final String? secondaryButtontext;
  final TextStyle? primaryButtonTextStyle;
  final TextStyle? secondaryButtonTextStyle;
  final Color? backgroundColor;
  final Function() primaryOnPressed;
  final Function()? secondaryOnPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: screenWidthPercentage(context, percentage: 0.8),
              padding: const EdgeInsets.only(
                top: 32,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  verticalSpaceRegular,
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Material(
                        child: Text(
                      title,
                      style: titleTextStyle ??
                          const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                    )),
                  ),
                  description != null
                      ? verticalSpaceRegular
                      : const SizedBox.shrink(),
                  description != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Material(
                              child: Text(
                            description!,
                            style: descriptionTextStyle ??
                                const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.mediumBlack,),
                          )),
                        )
                      : const SizedBox.shrink(),
                  verticalSpaceMedium,
                  Material(
                    color: AppColors.transparent,
                    child: InkWell(
                      onTap: primaryOnPressed,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 56,
                            child: Text(
                              primaryButtonText,
                              style: primaryButtonTextStyle ??
                                  const TextStyle(color: AppColors.blue, fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                  ),
                  secondaryButtontext != null
                      ? Material(
                          color: AppColors.transparent,
                          child: InkWell(
                            onTap: secondaryOnPressed,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 56,
                                  child: Text(
                                    secondaryButtontext!,
                                    style: secondaryButtonTextStyle ??
                                        const TextStyle(color: AppColors.blue, fontSize: 18, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            Positioned(
              top: -28,
              // left: 50,
              child: CircleAvatar(
                minRadius: 16,
                maxRadius: 28,
                backgroundColor: iconBackgroundColor ?? AppColors.blue,
                child: Icon(
                  icon,
                  size: 28,
                  color: iconColor ?? AppColors.white,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
