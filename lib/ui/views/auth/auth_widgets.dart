import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/pick_interest/pick_interest_viewmodel.dart';

AppBar cwAuthAppBar(BuildContext context,
    {required String title,
    bool showLeadingIcon = true,
    void Function()? onPressed,
    List<Widget>? actions, IconData? leadingIcon}) {
  return AppBar(
    actions: actions,
    elevation: 0.0,
    systemOverlayStyle:
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    title: Text(
      title,
      style:  TextStyle(
          fontWeight: FontWeight.w700, color: AppColors.black, fontSize: 18),
    ),
    backgroundColor:
        MaterialStateColor.resolveWith((Set<MaterialState> states) {
      return states.contains(MaterialState.scrolledUnder)
          ? AppColors.grey
          : AppColors.white;
    }),
    leadingWidth: showLeadingIcon ? 56.0 : 0.0,
    leading: showLeadingIcon
        ? IconButton(
            color: AppColors.mediumBlack,
            icon: Icon(leadingIcon ?? FeatherIcons.arrowLeft),
            onPressed: onPressed,
          )
        : const SizedBox.shrink(),
  );
}

Widget cwAuthProceedButton(BuildContext context,
    {required String buttonTitle,
    void Function()? onTap,
    bool isLoading = false,
    bool isActive = true}) {
  return GestureDetector(
    onTap: isActive
        ? isLoading
            ? null
            : onTap
        : null,
    child: Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      shadowColor:
          isActive ? AppColors.blue.withAlpha(100) : AppColors.transparent,
      child: Container(
        height: 48,
        width: screenWidth(context),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                height: 17,
                width: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(
                buttonTitle,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? AppColors.blue
                        : AppColors.mediumBlack,
            ),),
        decoration: BoxDecoration(
            color: isActive ? AppColors.blue : AppColors.lightGrey,
            borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}

Widget cwAuthCheckingTile({required String title, required bool value}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Checkbox(
        activeColor: AppColors.blueAccent.withAlpha(50),
        checkColor: AppColors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        value: value,
        onChanged: (value) {},
      ),
      horizontalDefaultMessageSpace,
      Text(title),
    ],
  );
}

Widget cwAuthHeadingTitle(BuildContext context, {required String title}) {
  return Text(
    title,
    textAlign: TextAlign.start,
    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
  );
}

Widget cwAuthDescription(BuildContext context, {required String title}) {
  return Text(
    title,
    style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.mediumBlack),
  );
}

Widget cwAuthInterestTopicPicker(
    String title, List<String> interestList, PickInterestsViewModel model,
    {Color? color, Icon? icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      verticalSpaceRegular,
      Row(
        children: [
          Container(
            child: icon ??
                const Icon(
                  FeatherIcons.plus,
                  color: AppColors.white,
                ),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: color ?? AppColors.blue),
          ),
          horizontalSpaceRegular,
          Text(
            title,
            style: const TextStyle(
                color: AppColors.mediumBlack,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
      verticalSpaceRegular,
      Wrap(
        spacing: 8,
        children: interestList
            .map(
              (label) => cwAuthInterestChip(label, model),
            )
            .toList(),
      )
    ],
  );
}

Widget cwAuthInterestChip(String label, PickInterestsViewModel model) {
  bool isSelected = userSelectedInterests.contains(label);
  return GestureDetector(
    onTap: () {
      if (!isSelected) {
        userSelectedInterests.add(label);
      } else {
        userSelectedInterests.remove(label);
      }
      model.changeUserInterestLength();
      model.notifyListeners();
    },
    child: Chip(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      backgroundColor: isSelected ? AppColors.blue : AppColors.grey,
      label: Text(
        label,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isSelected ? AppColors.white :AppColors.black),
      ),
    ),
  );
}
