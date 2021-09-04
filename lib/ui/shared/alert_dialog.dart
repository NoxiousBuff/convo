import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

class BasicDialogContent extends StatelessWidget {
  const BasicDialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
  margin: EdgeInsets.symmetric(
    horizontal: screenWidthPercentage(context, percentage: 0.04),
  ),
  padding: const EdgeInsets.only(
    top: 32,
    left: 16,
    right: 16,
    bottom: 12,
  ),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      verticalSpaceSmall,
      Text('Something'),
      verticalSpaceSmall,
      Text('Something'),
      verticalSpaceMedium,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          
          TextButton(
            onPressed: () {},
            child:Text('Something'),
          ),
        ],
      ),
    ],
  ),
)
      ],
    );
  }
}