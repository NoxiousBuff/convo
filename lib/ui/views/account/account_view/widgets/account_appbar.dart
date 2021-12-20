import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_colors.dart';

AppBar cwAccountAppBar(BuildContext context, String title,
    {List<Widget>? actions, bool showLeadingIcon = true}) {
  return AppBar(
    
    actions: actions,
    elevation: 0.0,
    toolbarHeight: 60,
    title: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:  TextStyle(
              fontSize: 32,
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
    backgroundColor:
        MaterialStateColor.resolveWith((Set<MaterialState> states) {
      return states.contains(MaterialState.scrolledUnder)
          ? AppColors.lightGrey
          : AppColors.white;
    }),
    leadingWidth: showLeadingIcon ? 56.0 : 0.0,
    leading: showLeadingIcon
        ? IconButton(
            color: AppColors.mediumBlack,
            icon: const Icon(FeatherIcons.arrowLeft),
            onPressed: () => Navigator.pop(context),
          )
        : const SizedBox.shrink(),
  );
}
