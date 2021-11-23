import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/user_model.dart';
import 'package:hive/hive.dart';
import 'package:hint/app/app.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:firebase_database/firebase_database.dart';
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
  late FireUser currentFireUser;
  final log = getLogger('RecentChats');
  final database = FirebaseDatabase.instance.reference();

  Future<FireUser> getCurrentFireUser(String liveUserUid) async {
    final firestoreUser = await FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(liveUserUid)
        .get();
    final _fireUser = FireUser.fromFirestore(firestoreUser);
    setState(() {
      currentFireUser = _fireUser;
    });
    return _fireUser;
  }

  @override
  void initState() {
    super.initState();
    getCurrentFireUser(FirestoreApi.liveUserUid);
    WidgetsBinding.instance!.addObserver(this);
    setStatus(status: 'Online');
  }

  Future<void> clearHive() async {
    await Hive.box(HiveHelper.userContactHiveBox).clear();
    await Hive.box(HiveHelper.phoneNumberHiveBox).clear();
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

  @override
  void didChangeDependencies() async {
    // await clearHive().catchError((e) {
    //   log.e('clearHive Error:$e');
    // }).whenComplete(() => log.wtf('Hive Box Clear'));
    super.didChangeDependencies();
  }

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
                        onPressed: () =>
                            model.gettingPhoneNumbers(currentFireUser),
                        text: 'Find your close friends',
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
    return ViewModelBuilder<RecentChatsViewModel>.reactive(
      viewModelBuilder: () => RecentChatsViewModel(),
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
                    enterTo: DistantView(fireUser: currentFireUser),
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
              const SizedBox(height: 8),
              buildUserContact(model),
              Container(
                margin: const EdgeInsets.all(8),
                child: CupertinoButton(
                  color: systemTeal,
                  child: model.isBusy
                      ? const Text('Checking......')
                      : const Text('Get Users By Interests'),
                  onPressed: () {
                    // FirebaseFirestore.instance
                    //     .collection('phoneNumbers')
                    //     .doc('7290874209')
                    //     .set({
                    //   'number': '7290874209',
                    // });
                    model.saveContactsinHive();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
