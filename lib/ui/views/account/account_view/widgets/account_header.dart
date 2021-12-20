import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

Widget cwAccountHeader(BuildContext context, String photoUrl, String displayName, String relationShipStatus, List<dynamic> hashtags) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: CachedNetworkImage(
              imageUrl: photoUrl,
              height: 84,
              width: 84,
              fit: BoxFit.cover,
            ),
          ),
          horizontalSpaceRegular,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      horizontalSpaceTiny,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.darkGrey)),
                        child: Text(
                          relationShipStatus,
                          style:  TextStyle(
                              color: AppColors.black, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
                Wrap(
                  spacing: 8,
                  direction: Axis.horizontal,
                  children: List.generate(
                    hashtags.length,
                    (index) => Text(
                      hashtags[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.mediumBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ],
  );
}
