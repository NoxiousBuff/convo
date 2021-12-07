import 'package:flutter/material.dart';

const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
const Widget horizontalSpaceRegular = SizedBox(width: 18.0);
const Widget horizontalSpaceMedium = SizedBox(width: 25.0);
const Widget horizontalSpaceLarge = SizedBox(width: 50.0);

const Widget sliverHorizontalSpaceTiny = SliverToBoxAdapter(child: SizedBox(width: 5.0));
const Widget sliverHorizontalSpaceSmall = SliverToBoxAdapter(child: SizedBox(width: 10.0));
const Widget sliverHorizontalSpaceRegular = SliverToBoxAdapter(child: SizedBox(width: 18.0));
const Widget sliverHorizontalSpaceMedium = SliverToBoxAdapter(child: SizedBox(width: 25.0));
const Widget sliverHorizontalSpaceLarge = SliverToBoxAdapter(child: SizedBox(width: 50.0));

const Widget horizontalDefaultMessageSpace = SizedBox(height: 0.5);
const Widget verticalSpaceTiny = SizedBox(height: 5.0);
const Widget verticalSpaceSmall = SizedBox(height: 10.0);
const Widget verticalSpaceRegular = SizedBox(height: 18.0);
const Widget verticalSpaceMedium = SizedBox(height: 25.0);
const Widget verticalSpaceLarge = SizedBox(height: 50.0);


const Widget sliverVerticalSpaceTiny = SliverToBoxAdapter(child: SizedBox(height: 5.0));
const Widget sliverVerticalSpaceSmall = SliverToBoxAdapter(child: SizedBox(height: 10.0));
const Widget sliverVerticalSpaceRegular = SliverToBoxAdapter(child: SizedBox(height: 18.0));
const Widget sliverVerticalSpaceMedium = SliverToBoxAdapter(child: SizedBox(height: 25.0));
const Widget sliverVerticalSpaceLarge = SliverToBoxAdapter(child: SizedBox(height: 50.0));

const Widget shrinkBox = SizedBox.shrink();

Widget bottomPadding(BuildContext context) => SizedBox(height:  MediaQuery.of(context).padding.bottom);
Widget topPadding(BuildContext context) => SizedBox(height:  MediaQuery.of(context).padding.top);

// Screen Size helpers

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;

double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;