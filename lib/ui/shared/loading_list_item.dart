import 'package:flutter/material.dart';
import 'package:hint/constants/interest.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

Widget loadingUserListItem(BuildContext context, {bool showInterestChips = false}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListTile(
        onTap: () {},
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        leading: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.indigo.shade300.withAlpha(30),
                Colors.indigo.shade400.withAlpha(50),
              ],
              focal: Alignment.topLeft,
              radius: 0.8,
            ),
            borderRadius: BorderRadius.circular(20)
          ),

          height: 56.0,
          width: 56.0,
          child:  Text(
            '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.black,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Container(
            margin: EdgeInsets.only(
                right: screenWidthPercentage(context, percentage: 0.1)),
            decoration: BoxDecoration(
              color: Colors.indigo.shade400.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(''),
          ),
        ),
        subtitle: Container(
          margin: EdgeInsets.only(
              right: screenWidthPercentage(context, percentage: 0.4)),
          decoration: BoxDecoration(
            color: Colors.indigo.shade300.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(''),
        ),
      ),
      showInterestChips ? verticalSpaceTiny : const SizedBox.shrink(),
      showInterestChips ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(
          runSpacing: 8.0,
          children: Interest.activities
              .take(6)
              .map(
                (e) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.indigo.shade200.withAlpha(30)),
                      child: Text(
                        e,
                        style: const TextStyle(
                            color: Colors.transparent,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              )
              .toList(),
        ),
      ) : const SizedBox.shrink(),
      showInterestChips ? verticalSpaceSmall : const SizedBox.shrink(),
    ],
  );
}
