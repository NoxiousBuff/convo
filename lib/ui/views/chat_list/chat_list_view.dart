import 'dart:math';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/login/login_view.dart';

import '../distant_view.dart';
import 'chat_list_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/views/chat_list/widgets/user_item.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key}) : super(key: key);

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
                decoration: BoxDecoration(
                    // image: DecorationImage(
                    //   image: AssetImage('images/img$index.jpg'),
                    //   fit: BoxFit.cover,
                    // ),
                    color: randomColor.withAlpha(30)),
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
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: CupertinoNavigationBar(
          border: const Border(
            bottom: BorderSide(
              color: Colors.transparent,
              width: 1.0, // One physical pixel.
              style: BorderStyle.solid,
            ),
          ),
          transitionBetweenRoutes: true,
          backgroundColor: Colors.white,
          middle: Text(
            'Messages',
            style: GoogleFonts.poppins(fontSize: 18.0),
          ),
          leading: TextButton(
            onPressed: () => Navigator.push(
                context,
                cupertinoTransition(
                    enterTo: DistantView(fireUser: model.fireUser),
                    exitFrom: const ChatListView())),
            child: const Text(
              'All',
              style: TextStyle(color: CupertinoColors.activeBlue),
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
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.blue,
              size: 24.0,
            ),
          ),
        ),
        body: CupertinoScrollbar(
          radius: const Radius.circular(20.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            controller: model.scrollController,
            children: [
              // buildPinnedView(context),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       const SizedBox(width: 22),
              //       GestureDetector(
              //           onTap: () {
              //             // Navigator.push(
              //             //     context,
              //             //     MaterialPageRoute(
              //             //         builder: (context) => ContactsView()));
              //           },
              //           child: const Chip(
              //               label: Text('Contacts'),
              //               backgroundColor: Colors.transparent,
              //               side: BorderSide(color: Colors.black12))),
              //       const SizedBox(width: 4),
              //       GestureDetector(
              //           // onTap: () {
              //           //   Navigator.push(
              //           //       context,
              //           //       MaterialPageRoute(
              //           //           builder: (context) => hintImagePrototype()));
              //           // },
              //           child: const Chip(
              //               label: Text('hint Image'),
              //               backgroundColor: Colors.transparent,
              //               side: BorderSide(color: Colors.black12))),
              //       const SizedBox(width: 4),
              //       const Chip(
              //           label: Text('hint Video'),
              //           backgroundColor: Colors.transparent,
              //           side: BorderSide(color: Colors.black12)),
              //       const SizedBox(width: 4),
              //       const Chip(
              //           label: Text('Explore Feed'),
              //           backgroundColor: Colors.transparent,
              //           side: BorderSide(color: Colors.black12)),
              //       const SizedBox(width: 4),
              //       const Chip(
              //           label: Text('Settings'),
              //           backgroundColor: Colors.transparent,
              //           side: BorderSide(color: Colors.black12)),
              //       const SizedBox(width: 22),
              //     ],
              //   ),
              // ),
              // buildPinnedView(context),

              buildUserContact(model),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ChatListViewModel(),
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
