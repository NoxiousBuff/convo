import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/app/app_logger.dart';

import 'chat_list_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/views/login/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/distant_view/distant_view.dart';
import 'package:hint/ui/views/chat_list/widgets/user_item.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView>
    with WidgetsBindingObserver {
  final log = getLogger('ChatListView');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    setStatus(status: 'Online');
    WidgetsBinding.instance!.addObserver(this);
  }

  Future<void> setStatus({required String status}) async {
    await _firestore
        .collection(usersFirestoreKey)
        .doc(_auth.currentUser!.uid)
        .update({
      "status": status,
      "lastSeen": Timestamp.now(),
    }).catchError((e) => log.e(e));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus(status: "Online");
    } else {
      setStatus(status: "Offline");
    }
  }

  Widget buildPinnedView(BuildContext context) {
    final deviceOrientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      shrinkWrap: true,
      itemCount: 9,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (deviceOrientation == Orientation.portrait) ? 3 : 5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) {
        final Color randomColor = Color.fromARGB(
            Random().nextInt(256),
            Random().nextInt(256),
            Random().nextInt(256),
            Random().nextInt(256));

        final List letters = [
          'R',
          'T',
          'P',
          'A',
          'S',
          'D',
          'F',
          'G',
          'H',
          'L',
          'V',
          'B',
          'N',
          'M',
        ];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                height: 108.0,
                width: 108.0,
                child: Text(
                  letters[Random().nextInt(letters.length)],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                decoration: BoxDecoration(color: randomColor.withAlpha(30)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildStoriesView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        height: 128.0,
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Container(
                  height: 108.0,
                  width: 108.0,
                  child: const Icon(CupertinoIcons.add),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 20,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: Container(
                        height: 108.0,
                        width: 108.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/img$i.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget buildUserContact(ChatListViewModel model) {
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

        List<UserItem> userResults = [];
        for (var document in model.data!.docs) {
          FireUser fireUser = FireUser.fromFirestore(document);
          UserItem userResult = UserItem(
            fireUser: fireUser,
            model: model,
          );
          userResults.add(userResult);
        }

        return userResults.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: userResults.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 5),
                itemBuilder: (context, i) => userResults[i])
            : const Center(
                child: Text('Nothing Is Here'),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatListViewModel>.reactive(
      onModelReady: (model) async {
        model.scrollController = ScrollController();
        await model.currentUserDoc();
      },
      disposeViewModel: true,
      viewModelBuilder: () => ChatListViewModel(),
      builder: (context, model, child) {
        return ValueListenableBuilder<Box>(
          valueListenable: appSettings.listenable(),
          builder: (context, box, child) {
            var darkMode = box.get(darkModeKey, defaultValue: false);
            return Scaffold(
              appBar: CupertinoNavigationBar(
                border: const Border(
                  bottom: BorderSide(
                    color: Colors.transparent,
                    width: 1.0, // One physical pixel.
                    style: BorderStyle.solid,
                  ),
                ),
                transitionBetweenRoutes: true,
                backgroundColor: darkMode ? black54 : systemBackground,
                middle: Text(
                  'Messages',
                  style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      color: darkMode ? systemBackground : black54),
                ),
                leading: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      cupertinoTransition(
                        enterTo: DistantView(fireUser: model.fireUser),
                        exitFrom: const ChatListView(),
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
                    model.signOut(context);
                    Navigator.push(
                      context,
                      cupertinoTransition(
                        enterTo: const LoginView(),
                        exitFrom: const ChatListView(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.logout_rounded,
                    color: darkMode ? systemBackground : activeBlue,
                    size: 24.0,
                  ),
                ),
              ),
              body: CupertinoScrollbar(
                radius: const Radius.circular(20.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // TextButton(
                    //   onPressed: () {
                    //     FirebaseFirestore.instance
                    //         .collection(usersFirestoreKey)
                    //         .get()
                    //         .then((querysnapshot) {
                    //       for (var document in querysnapshot.docs) {
                    //         document.reference.set({'blockedUsers': <String>[]},
                    //             SetOptions(merge: true));
                    //       }
                    //     });
                    //   },
                    //   child: const Text('BlockedUsers'),
                    // ),
                    buildUserContact(model),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class FireUserResult extends StatelessWidget {
  const FireUserResult({Key? key, required this.fireUser, required this.onTap})
      : super(key: key);

  final FireUser fireUser;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(fireUser.email));
  }
}
