import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/prototypes/contact/contact_view.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item/user_list_item.dart';
import 'package:hint/ui/views/distant/distant_view.dart';
import 'package:hint/ui/views/search/search_view.dart';
import 'package:stacked/stacked.dart';
import 'chat_list_viewmodel.dart';

class ChatListView extends StatelessWidget {
  ChatListView({Key? key}) : super(key: key);
  final log = getLogger('ChatListView');

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
        });
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

  Widget buildEmptyListUi(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Flexible(
                  child: Text(
                "You don't have \n any friends,,, yet.",
                style: TextStyle(fontSize: 44, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ))
            ],
          ),
          verticalSpaceMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade800,
                      borderRadius: BorderRadius.circular(100)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: const Text(
                    'Add some friends.',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ],
          ),
          verticalSpaceLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1621349375404-01f48593be7a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
                  height: 64,
                  width: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1621318165483-1cfd49a88ef5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=751&q=80',
                  height: 64,
                  width: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1620598852012-5ebc7712a3b8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80',
                  height: 64,
                  width: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1596698749858-7a2ce0a09220?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=376&q=80',
                  height: 64,
                  width: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1621377674852-0b332949ef25?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80',
                  height: 64,
                  width: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
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

        // final Color randomColor = Color.fromARGB(
        //   Random().nextInt(256),
        //   Random().nextInt(256),
        //   Random().nextInt(256),
        //   Random().nextInt(256),
        // );

        List<UserListItem> userResults = [];

        for (var document in model.data!.docs) {
          // log.i(document);
          // FireUser fireUser = FireUser.fromFirestore(document);
          // log.w(fireUser);
          // UserItem userResult = UserItem(
          //   fireUser: fireUser,
          //   onTap: () {
          //     model.chatService
          //         .startConversation(context, fireUser, randomColor);
          //   },
          // );
          // userResults.add(userResult);
          // log.wtf(userResults);
          UserListItem userListItem = UserListItem(userUid: document.get('userUid'));
          userResults.add(userListItem);
        }
        // log.w('Future loop started');
        // Future.forEach<QueryDocumentSnapshot>(model.data!.docs,
        //     (element) async {
        //   try {
        //     log.wtf('The $element started here');
        //     final userDoc = await FirebaseFirestore.instance
        //         .collection(subsFirestoreKey)
        //         .doc(element.get('userUid'))
        //         .get();
        //     log.w('userDoc : ${userDoc.get('email')}');
        //     FireUser fireUser = FireUser.fromFirestore(userDoc);
        //     log.wtf(fireUser.id);
        //     UserItem userResult = UserItem(
        //         fireUser: fireUser,
        //         onTap: () {
        //           model.chatService
        //               .startConversation(context, fireUser, randomColor);
        //         });
        //     log.i('UserResult has not been added');
        //     userResults.add(userResult);
        //     log.d(userResults);
        //     log.i('UserResult has been added');
        //     log.wtf('The $userDoc ended here');
        //   } catch (e) {
        //     log.e(e);
        //   }
        // });

        // log.w('Future loop ended');
        // String hjkhjkhjk = userResults.length.toString();
        // log.d(hjkhjkhjk);

        return userResults.isNotEmpty
            ? ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: userResults,
              )
            : const Center(
                child: Text('fbdjskfbjfdsbjxdbnvfbhsdjvkb'),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatListViewModel>.reactive(
      onModelReady: (model) {
        model.scrollController = ScrollController();
      },
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
          leading: InkWell(
            onTap: () =>
                navService.cupertinoPageRoute(context, const DistantView()),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue),
                Text(
                  'All',
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
              ],
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              model.signOut(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.blue,
              size: 24.0,
            ),
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          controller: model.scrollController,
          children: [
            // buildUpperScrollView(context),
            // buildPinnedView(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Hero(
                tag: 'search',
                child: CupertinoTextField.borderless(
                  padding: const EdgeInsets.all(8.0),
                  readOnly: true,
                  onTap: () =>
                      navService.materialPageRoute(context, const SearchView()),
                  placeholder: 'Search for someone',
                  placeholderStyle: TextStyle(color: Colors.indigo.shade900),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    border:
                        Border.all(color: CupertinoColors.lightBackgroundGray),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            buildUserContact(model),
          ],
        ),
        // body: buildEmptyListUi(context),
      ),
      viewModelBuilder: () => ChatListViewModel(),
    );
  }

  SingleChildScrollView buildUpperScrollView(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 22),
          GestureDetector(
              onTap: () {
                navService.materialPageRoute(context, const ContactsView());
              },
              child: const Chip(
                  label: Text('Contacts'),
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Colors.black12))),
          const SizedBox(width: 4),
          GestureDetector(
              child: const Chip(
                  label: Text('hint Image'),
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Colors.black12))),
          const SizedBox(width: 4),
          const Chip(
              label: Text('hint Video'),
              backgroundColor: Colors.transparent,
              side: BorderSide(color: Colors.black12)),
          const SizedBox(width: 4),
          const Chip(
              label: Text('Explore Feed'),
              backgroundColor: Colors.transparent,
              side: BorderSide(color: Colors.black12)),
          const SizedBox(width: 4),
          const Chip(
              label: Text('Settings'),
              backgroundColor: Colors.transparent,
              side: BorderSide(color: Colors.black12)),
          const SizedBox(width: 22),
        ],
      ),
    );
  }
}
