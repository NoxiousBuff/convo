import 'package:flutter/cupertino.dart';
import 'package:hint/ui/shared/explore_interest_chip.dart';

Widget cwAccountInterests(BuildContext context, List<dynamic> interests) {
  return SizedBox(
    child: Wrap(
      spacing: 4,
      children: List.generate(
        interests.length,
        (index) => exploreInterestChip(interests[index]),
      ),
    ),
  );
}
