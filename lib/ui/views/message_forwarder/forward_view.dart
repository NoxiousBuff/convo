import 'dart:developer';
import 'package:hint/app/app.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/models/message_model.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/shared/empty_state.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/shared/circular_progress.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/views/chat_list/chat_list_viewmodel.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';

class ForwardView extends StatelessWidget {
  final Message message;
  const ForwardView({Key? key, required this.message}) : super(key: key);

  CupertinoSliverNavigationBar _buildAppBar(
          BuildContext context, ChatListViewModel model) =>
      CupertinoSliverNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        automaticallyImplyLeading: false,
        leading: Material(
          color: Colors.transparent,
          child: SizedBox(
            height: 30,
            width: 30,
            child: Image.asset('assets/appicon_mdpi_gradient.png'),
          ),
        ),
        stretch: true,
        largeTitle: Text(
          'Convo',
          style: TextStyle(
            color: Theme.of(context).colorScheme.black,
          ),
        ),
        border: Border.all(width: 0.0, color: Colors.transparent),
        trailing: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
                color: Theme.of(context).colorScheme.blue, fontSize: 20),
          ),
        ),
      );

  Widget _buildChatList(BuildContext context, ChatListViewModel model) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      sliver: Builder(
        builder: (context) {
          final data = model.data;
          if (model.hasError) {
            log(model.error().toString());
            return const SliverToBoxAdapter(
              child: Center(
                child: Text('Model has Error'),
              ),
            );
          }
          if (!model.dataReady) {
            return const SliverToBoxAdapter(
                child: Center(child: CircularProgress()));
          }
          if (data != null) {
            return data.docs.isNotEmpty
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final doc = data.docs[index];
                        final userUid = doc[RecentUserField.userUid];
                        final String currentUserUid =
                            hiveApi.getUserData(FireUserField.id);
                        return userUid != currentUserUid
                            ? UserListItem(
                                onTap: (fireUser) {
                                  switch (message.type) {
                                    case MediaType.image:
                                      {
                                        chatService.addNewMessage(
                                          receiverUid: fireUser.id,
                                          type: MediaType.image,
                                          mediaUrl: message
                                              .message[MessageField.mediaUrl],
                                          blurHash: message
                                              .message[MessageField.blurHash],
                                        );
                                      }

                                      break;
                                    default:
                                  }
                                  chatService.startDuleConversation(
                                      context, fireUser);
                                },
                                userUid: userUid,
                                onLongPress: (fireUser) {},
                              )
                            : shrinkBox;
                      },
                      childCount: data.docs.length,
                    ),
                  )
                : SliverToBoxAdapter(
                    child: emptyState(context,
                        lowerGap:
                            screenHeightPercentage(context, percentage: 0.2),
                        upperGap:
                            screenHeightPercentage(context, percentage: 0.2),
                        emoji: '🙂',
                        heading:
                            'It\'s pretty quiet in here\ndon\'t you think?',
                        description:
                            'Nobody is in you recent to begin a\nconversation.',
                        proceedButton: CWAuthProceedButton(
                          buttonTitle: 'Invite Friends Over',
                          onTap: () => model.invitePeople(),
                        ),
                        secondaryButton: TextButton(
                            onPressed: () => mainViewTabController.index = 2,
                            child: const Text('Or Discover Friends'))),
                  );
          } else {
            return const SliverToBoxAdapter(
              child: Text('Data is null'),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatListViewModel>.reactive(
      viewModelBuilder: () => ChatListViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          body: CustomScrollView(
            scrollBehavior: const CupertinoScrollBehavior(),
            slivers: [
              _buildAppBar(context, model),
              sliverVerticalSpaceRegular,
              _buildChatList(context, model),
            ],
          ),
        );
      },
    );
  }
}
