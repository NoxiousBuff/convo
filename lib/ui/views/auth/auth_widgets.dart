import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/pick_interest/pick_interest_viewmodel.dart';

AppBar cwAuthAppBar(BuildContext context,
    {required String title,
    bool showLeadingIcon = true,
    void Function()? onPressed,
    List<Widget>? actions,
    IconData? leadingIcon}) {
  return AppBar(
    actions: actions,
    elevation: 0.0,
    title: Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.black,
          fontSize: 18),
    ),
    backgroundColor:
        MaterialStateColor.resolveWith((Set<MaterialState> states) {
      return states.contains(MaterialState.scrolledUnder)
          ? Theme.of(context).colorScheme.lightGrey
          : Theme.of(context).colorScheme.scaffoldColor;
    }),
    leadingWidth: showLeadingIcon ? 56.0 : 0.0,
    leading: showLeadingIcon
        ? IconButton(
            color: Theme.of(context).colorScheme.mediumBlack,
            icon: Icon(leadingIcon ?? FeatherIcons.arrowLeft),
            onPressed: onPressed,
          )
        : const SizedBox.shrink(),
  );
}

// Widget cwAuthProceedButton(BuildContext context,
//     {required String buttonTitle,
//     void Function()? onTap,
//     bool isLoading = false,
//     bool isActive = true}) {
//   return GestureDetector(
//     onTap: isActive
//         ? isLoading
//             ? null
//             : onTap
//         : null,
//     child: Material(
//       elevation: 8,
//       borderRadius: BorderRadius.circular(16),
//       shadowColor: isActive
//           ? Theme.of(context).colorScheme.blue.withAlpha(100)
//           : Colors.transparent,
//       child: Container(
//         height: 48,
//         width: screenWidth(context),
//         alignment: Alignment.center,
//         child: isLoading
//             ? SizedBox(
//                 height: 17,
//                 width: 17,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 1.5,
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                       Theme.of(context).colorScheme.white),
//                 ),
//               )
//             : Text(
//                 buttonTitle,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: isActive
//                       ? Theme.of(context).colorScheme.white
//                       : Theme.of(context).colorScheme.mediumBlack,
//                 ),
//               ),
//         decoration: BoxDecoration(
//             color: isActive
//                 ? Theme.of(context).colorScheme.blue
//                 : Theme.of(context).colorScheme.lightGrey,
//             borderRadius: BorderRadius.circular(16)),
//       ),
//     ),
//   );
// }

class CWAuthProceedButton extends StatelessWidget {
  const CWAuthProceedButton({
    Key? key,
    required this.buttonTitle,
    required this.onTap,
    this.isActive = true,
    this.isLoading = false,
  }) : super(key: key);

  final String buttonTitle;
  final void Function()? onTap;
  final bool isLoading;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive
          ? isLoading
              ? null
              : onTap
          : null,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        shadowColor: isActive
            ? Theme.of(context).colorScheme.blue.withAlpha(100)
            : Colors.transparent,
        child: Container(
          height: 48,
          width: screenWidth(context),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  height: 17,
                  width: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.white),
                  ),
                )
              : Text(
                  buttonTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? Theme.of(context).colorScheme.white
                        : Theme.of(context).colorScheme.mediumBlack,
                  ),
                ),
          decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).colorScheme.blue
                  : Theme.of(context).colorScheme.lightGrey,
              borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}

Widget cwAuthCheckingTile(BuildContext context,
    {required String title, required bool value}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Checkbox(
        activeColor: Theme.of(context).colorScheme.blueAccent.withAlpha(50),
        checkColor: Theme.of(context).colorScheme.blue,
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

Widget cwAuthDescription(BuildContext context,
    {required String title, Color? titleColor}) {
  return Text(
    title,
    style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: titleColor ?? Theme.of(context).colorScheme.mediumBlack),
  );
}

Widget cwAuthInterestTopicPicker(BuildContext context, String title,
    List<String> interestList, PickInterestsViewModel model,
    {Color? color, Icon? icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      verticalSpaceRegular,
      Row(
        children: [
          Container(
            child: icon ??
                Icon(
                  FeatherIcons.plus,
                  color: Theme.of(context).colorScheme.white,
                ),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: color ?? Theme.of(context).colorScheme.blue),
          ),
          horizontalSpaceRegular,
          Text(
            title,
            style: TextStyle(
                color: Theme.of(context).colorScheme.mediumBlack,
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
              (label) => CWAuthInterestChip(label, model),
            )
            .toList(),
      )
    ],
  );
}

// Widget cwAuthInterestChip(String label, PickInterestsViewModel model) {
//   bool isSelected = userSelectedInterests.contains(label);
//   return GestureDetector(
//     onTap: () {
//       if (!isSelected) {
//         userSelectedInterests.add(label);
//       } else {
//         userSelectedInterests.remove(label);
//       }
//       model.changeInterestLength();
//       model.notifyListeners();
//     },
//     child: Chip(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       backgroundColor: isSelected ? Theme.of(context).colorScheme.blue : Theme.of(context).colorScheme.grey,
//       label: Text(
//         label,
//         style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//             color: isSelected ? Theme.of(context).colorScheme.white :Theme.of(context).colorScheme.black),
//       ),
//     ),
//   );
// }

class CWAuthInterestChip extends StatelessWidget {
  const CWAuthInterestChip(this.label, this.model, {Key? key})
      : super(key: key);

  final String label;
  final PickInterestsViewModel model;

  @override
  Widget build(BuildContext context) {
    bool isSelected = userSelectedInterests.contains(label);
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          userSelectedInterests.add(label);
        } else {
          userSelectedInterests.remove(label);
        }
        model.changeInterestLength();
        model.notifyListeners();
      },
      child: Chip(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.blue
            : Theme.of(context).colorScheme.grey,
        label: Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: isSelected
                  ? Theme.of(context).colorScheme.white
                  : Theme.of(context).colorScheme.black),
        ),
      ),
    );
  }
}
