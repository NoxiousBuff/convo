import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_button.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_save_indicator.dart';
import 'package:hint/ui/views/profile/profile_view.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';

class DulePersonDialog extends StatelessWidget {
  const DulePersonDialog({Key? key, required this.fireUser}) : super(key: key);

  final FireUser fireUser;

  Widget _buildDialogHeader(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: () => navService.materialPageRoute(context, ProfileView(fireUser: fireUser)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(64),
                      child: Container(
                        height: screenWidthPercentage(context, percentage: 0.4),
                        width: screenWidthPercentage(context, percentage: 0.4),
                        child: CachedNetworkImage(
                          imageUrl: fireUser.photoUrl,
                          fit: BoxFit.cover,
                        ),
                        color: Colors.indigo.shade200.withAlpha(50),
                      )),
                  verticalSpaceRegular,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          fireUser.username,
                          style:
                              const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                        horizontalSpaceTiny,
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Theme.of(context).colorScheme.darkGrey)),
                          child: Text(
                            fireUser.romanticStatus ?? '',
                            style:  TextStyle(
                                color: Theme.of(context).colorScheme.black, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                  verticalSpaceRegular,
                  SizedBox(
                    width: screenWidthPercentage(context, percentage: 0.9),
                    child: 
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        direction: Axis.horizontal,
                        children: List.generate(
                          fireUser.hashTags.length,
                          (index) => Text(
                            fireUser.hashTags[index],
                            style:  TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color:Theme.of(context).colorScheme.mediumBlack,
                            ),
                          ),
                        ),
                      ),
                    
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogFooter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: cwAccountButton(
            context,
            'Message',
            onTap: () {
              Navigator.pop(context);
              chatService.startDuleConversation(context, fireUser);
            },
          ),
        ),
        horizontalSpaceSmall,
        cwAccountIconButton(
          context,
          onTap: () => navService.materialPageRoute(
              context,
              WriteLetterView(
                fireUser: fireUser,
              )),
        ),
        horizontalSpaceSmall,
        cwAccountSaveIndicator(context, fireUser.id),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          verticalSpaceMedium,
          _buildDialogHeader(context),
          verticalSpaceLarge,
          _buildDialogFooter(context),
          const Flexible(child: verticalSpaceLarge),
          bottomPadding(context)
        ],
      ),
    );
  }
}
