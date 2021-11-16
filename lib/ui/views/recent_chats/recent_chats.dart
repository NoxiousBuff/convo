import 'package:firebase_database/firebase_database.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app.dart';
import 'package:hint/ui/views/live_chat/live_chat.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/search_view/search_view.dart';
import 'package:hint/ui/views/distant_view/distant_view.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';
import 'package:hint/ui/views/recent_chats/recentchats_viewmodel.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({Key? key}) : super(key: key);

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> with WidgetsBindingObserver {
  final log = getLogger('RecentChats');
  final database = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    super.initState();
    //clearHive();
    WidgetsBinding.instance!.addObserver(this);
    setStatus(status: 'Online');
  }

  Future<void> clearHive() async {
    await Hive.box(HiveHelper.userContactHiveBox).clear();
    await Hive.box(HiveHelper.userContactInviteHiveBox).clear();
  }

  Future<void> setStatus({required String status}) async {
    await firestoreApi
        .updateUser(
            updateProperty: status,
            property: UserField.status,
            uid: FirestoreApi.liveUserUid)
        .catchError((e) {
      log.e('setStatus:$e');
    });
  }

  // Future getAppWriteCurrentUser() async {
  //   final currentUser = await AppWriteApi.instance.account.get();
  //   log.wtf('Appwrite email: ${currentUser.email}');
  //   log.wtf('Appwrite ID:${currentUser.$id}');
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus(status: "Online");
      log.wtf('status: Online');
    } else {
      setStatus(status: "Offline");
      log.wtf('status: Offline');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buttonWidget({
    IconData? icon,
    required String text,
    void Function()? onPressed,
    required BuildContext context,
  }) {
    return CupertinoButton(
      color: activeBlue,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: systemBackground),
      ),
    );
  }

  Widget buildUserContact(RecentChatsViewModel model) {
    return Builder(
      builder: (context) {
        if (!model.dataReady) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (model.hasError) {
          return const Center(
            child: Text('Model has Error'),
          );
        }

        final data = model.data;

        if (data != null) {
          return data.docs.isEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.docs.length,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 5),
                  itemBuilder: (context, index) {
                    final user = data.docs[index];
                    final userUid = user.get('userUid');
                    return UserListItem(userUid: userUid);
                  },
                )
              : Column(
                  children: [
                    Center(
                      child: buttonWidget(
                        context: context,
                        onPressed: () => model.gettingPhoneNumbers(),
                        text: model.isBusy
                            ? 'Loading...'
                            : 'Find you close friends',
                      ),
                    ),
                  ],
                );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final liveChatUsersRef = database.child('/LiveChatUsers');

    return ViewModelBuilder<RecentChatsViewModel>.reactive(
      viewModelBuilder: () => RecentChatsViewModel(),
      onModelReady: (model) async {
        await AuthService.liveUser!.reload();
        await firestoreApi.updateUser(
          uid: FirestoreApi.liveUserUid,
          property: UserField.status,
          updateProperty: 'Online',
        );
        await model.getCurrentFireUser(ChatService.liveUserUid);
      },
      builder: (context, model, child) {
        if (!model.dataReady) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (model.hasError) {
          return const Center(
            child: Text('Model has Error'),
          );
        }

        return Scaffold(
          appBar: CupertinoNavigationBar(
            border: const Border(
              bottom: BorderSide(
                width: 1.0, // One physical pixel.
                color: Colors.transparent,
                style: BorderStyle.solid,
              ),
            ),
            transitionBetweenRoutes: true,
            backgroundColor: isDarkTheme ? black54 : systemBackground,
            middle: Text(
              'Messages',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            leading: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  cupertinoTransition(
                    enterTo: DistantView(fireUser: model.currentFireUser),
                    exitFrom: const RecentChats(),
                  ),
                );
              },
              child: Text(
                'All',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  cupertinoTransition(
                    enterTo: const SearchView(),
                    exitFrom: const RecentChats(),
                  ),
                );
              },
              icon: const Icon(
                Icons.search,
                size: 24.0,
              ),
            ),
          ),
          body: Column(
            children: [
              TextButton(
                child: const Text('Realtime Database'),
                onPressed: () async {
                  Map<String, dynamic> map = {
                    'userMessage': 'HintMessage',
                    'animation': null,
                    'medias': null,
                    'status': 'Offline',
                    'chatRoomId': null,
                  };
                  await liveChatUsersRef
                      .child('0HZIVOJxr6baRUhjWxrNsJcFvkJ3')
                      .set(map)
                      .whenComplete(() => log.wtf('Added in Realtime Database'))
                      .catchError((e) {
                    log.e('RealtimeDatabase Error:$e');
                  });
                  // await database
                  //     .child('liveChat/medias')
                  //     .push()
                  //     .set({
                  //       'URL': 'videoURL',
                  //       'type': 'imageURL',
                  //     })
                  //     .whenComplete(
                  //         () => 'Document is added in realtimeDatabse')
                  //     .catchError((e) {
                  //       log.e('Error:$e');
                  //     });
                },
              ),
              TextButton(
                child: const Text('Enter'),
                onPressed: () async{
                 final user = await model.getFireUser('8920551108');
                 log.wtf('User:$user');
                },
              ),
              TextButton(
                child: const Text('Enter In Live'),
                onPressed: () {
                  log.wtf(Hive.box(HiveHelper.userContactHiveBox).values.toList());
                },
              ),
              buildUserContact(model),
              TextButton(
                child: const Text('Enter In Live Chat'),
                onPressed: () => Navigator.push(
                  context,
                  cupertinoTransition(
                    enterTo: const LiveChat(),
                    exitFrom: const RecentChats(),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
