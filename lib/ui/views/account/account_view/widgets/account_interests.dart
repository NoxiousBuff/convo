import 'package:flutter/cupertino.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/explore_interest_chip.dart';
import 'package:hint/ui/views/discover_interest/discover_interest_view.dart';

Widget cwAccountInterests(BuildContext context, List<dynamic> interests) {
  return SizedBox(
    child: Wrap(
      spacing: 4,
      children: List.generate(
        interests.length,
        (index) => exploreInterestChip(
          context,
          interests[index],
          onTap: () {
            navService.materialPageRoute(
              context,
              DiscoverInterestView(
                interestName: interests[index],
              ),
            );
          },
        ),
      ),
    ),
  );
}
