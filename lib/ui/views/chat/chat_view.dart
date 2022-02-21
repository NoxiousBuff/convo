
import 'chat_messages.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:timeago/timeago.dart' as time;
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/chat_service.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:hint/ui/views/profile_view/profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hint/ui/components/hint/textfield/textfield.dart';

class ChatView extends StatelessWidget {
  final FireUser fireUser;
  final Color randomColor;
  final String conversationId;
  const ChatView({
    Key? key,
    required this.fireUser,
    required this.randomColor,
    required this.conversationId,
  }) : super(key: key);

  @override
  build(BuildContext context) {

    return ViewModelBuilder<ChatViewModel>.reactive(
      viewModelBuilder: () =>
          ChatViewModel(conversationId: conversationId, fireUser: fireUser),
      onModelReady: (model) async {
        await model.iBlockThisUserCkecker(
            FirestoreApi.liveUserUid, fireUser.id);

        await model.userBlockMeChecker(
            fireUser.id, firestoreApi.getCurrentUser()!.uid);
      },
      onDispose: (model) async {
        if (await model.hasMessage(conversationId)) {
          await chatService.addToRecentList(fireUser.id);
        }
      },
      builder: (context, model, child) {
        final url = fireUser.photoUrl ?? 'images/img2.jpg';
        return OfflineBuilder(
          child: const Text("Yah Baby !!"),
          connectivityBuilder: (context, connectivity, child) {
            bool connected = connectivity != ConnectivityResult.none;

            if (connected) model.seeMsg();
            return GestureDetector(
              onTap: () {
                MediaQuery.of(context).viewInsets.bottom == 0
                    ? model.focusNode.unfocus()
                    : const Text('');
              },
              dragStartBehavior: DragStartBehavior.start,
              onVerticalDragStart: (drag) {
                MediaQuery.of(context).viewInsets.bottom == 0
                    ? model.focusNode.unfocus()
                    : const Text('');
              },
              child: Scaffold(
                appBar: AppBar(
                    elevation: 0.0,
                    centerTitle: true,
                    toolbarHeight: 100.0,
                    leadingWidth: 130,
                    automaticallyImplyLeading: true,
                    backgroundColor: randomColor.withAlpha(60),
                    leading: SizedBox(
                      width: 56,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 8),
                          GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.arrow_back, size: 20)),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              cupertinoTransition(
                                enterTo: ProfileView(
                                    model: model,
                                    fireUser: fireUser,
                                    iBlockThisUser: model.iBlockThisUser,
                                    conversationId: conversationId),
                                exitFrom: ChatView(
                                  fireUser: fireUser,
                                  randomColor: randomColor,
                                  conversationId: conversationId,
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(url),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: statusChecker(context)),
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: ChatMessages(
                        fireuser: fireUser,
                        receiverUid: fireUser.id,
                        conversationId: conversationId,
                      ),
                    ),
                    hintTextField(
                      model: model,
                      context: context,
                      child: HintTextField(
                        fireUser: fireUser,
                        chatViewModel: model,
                        randomColor: randomColor,
                        receiverUid: fireUser.id,
                        focusNode: model.focusNode,
                        conversationId: conversationId,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget hintTextField(
      {required Widget child,
      required ChatViewModel model,
      required BuildContext context}) {
    if (model.iBlockThisUser) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'You block ${fireUser.username} If you want to send messages. \nYou have to first unblock ${fireUser.username}',
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return child;
    }
  }

  Widget statusChecker(BuildContext context) {
    final statusStyle = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(color: activeGreen, fontSize: 10);
    final lastSeenStyle = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(color: inactiveGray, fontSize: 10);
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(usersFirestoreKey)
            .doc(fireUser.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String status = snapshot.data!['status'];
            bool isOnline = snapshot.data!['status'] == 'Online';
            var timestamp = snapshot.data!['lastSeen'] as Timestamp;
            var lastSeen = time.format(timestamp.toDate(), allowFromNow: true);
            return Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  fireUser.username,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                verticalSpaceTiny,
                isOnline
                    ? Text(status, style: statusStyle)
                    : Text(lastSeen, style: lastSeenStyle)
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
