import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

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
              fontSize: 28,
              color: Theme.of(context).colorScheme.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
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
            icon: const Icon(FeatherIcons.arrowLeft),
            onPressed: () => Navigator.pop(context),
          )
        : const SizedBox.shrink(),
  );
}
