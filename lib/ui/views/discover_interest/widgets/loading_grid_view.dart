import 'package:flutter/material.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

Widget loadingGridView(BuildContext context) {
  return SliverGrid(
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: screenWidthPercentage(context, percentage: 0.5),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      childAspectRatio: 1.0,
    ),
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      height: screenWidthPercentage(context, percentage: 0.2),
                      width: screenWidthPercentage(context, percentage: 0.2),
                      color: Colors.indigo.shade200.withAlpha(50),
                    )),
                verticalSpaceRegular,
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade300.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: screenWidthPercentage(context, percentage: 0.21),
                  child: const Text('         '),
                ),
                verticalSpaceSmall,
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade300.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: screenWidthPercentage(context, percentage: 0.1),
                  child: const Text('         '),
                ),
              ],
            ),
          ),
        );
      },
      childCount: 4,
    ),
  );
}
