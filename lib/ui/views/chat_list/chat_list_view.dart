import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/views/distant/distant_view.dart';
import 'package:hint/ui/views/chat_list/widgets/user_item.dart';

class ChatListView extends StatelessWidget {
  final ScrollController? scrollController = ScrollController();
  final AuthService authMethods = AuthService();
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  late final Future<QuerySnapshot>? usersContactFuture;
  final ChatService chatMethods = ChatService();

  ChatListView({Key? key}) : super(key: key);

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

          final Color randomColor = Color.fromARGB(Random().nextInt(256),
      Random().nextInt(256), Random().nextInt(256), Random().nextInt(256));

      final List letters = ['Q','W','E','R','T','Y','U','I','O','P','A','S','D','F','F','G','H','J','K','L','Z','X','C','V','B','N','M',];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  height: 108.0,
                  width: 108.0,
                  child: Text(letters[Random().nextInt(26)], style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),),
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    //   image: AssetImage('images/img$index.jpg'),
                    //   fit: BoxFit.cover,
                    // ),
                    color: randomColor.withAlpha(30)
                  ),
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

  Widget buildUserContact() {
    return FutureBuilder<QuerySnapshot>(
      future: usersCollection.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            title: const Text(
              'Something Bad Happened',
              textAlign: TextAlign.center,
            ),
            content: const Text(
              'Please try again later.',
              textAlign: TextAlign.center,
            ),
            actions: [
              CupertinoButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }

        List<UserItem> userResults = [];
        for (var document in snapshot.data!.docs) {
            FireUser fireUser = FireUser.fromFirestore(document);
            UserItem userResult = UserItem(fireUser: fireUser);
            userResults.add(userResult);
          }

        return userResults.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.only(left: 5),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: userResults,
              )
            : const Center(
                child: Text('Nothing Is Here'),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            onTap: () {
              Navigator.of(context, rootNavigator: false).push(
                  CupertinoPageRoute(builder: (context) => const DistantView()));
            },
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
              authMethods.signOut(context, onSignOut: () {} );
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
              size: 24.0,
            ),
          ),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            systemNavigationBarColor: CupertinoColors.systemGroupedBackground,
          ),
          child: CupertinoScrollbar(
            radius: const Radius.circular(20.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       SizedBox(width: 15),
                //       OutlinedButton(
                //         child: Text('Hint Video'),
                //         onPressed: () {
                //           Navigator.of(context).push(MaterialPageRoute(
                //               builder: (context) => SamplePrototype()));
                //         },
                //       ),
                //       SizedBox(width: 15),
                //       OutlinedButton(
                //         child: Text('Sensors'),
                //         onPressed: () {
                //           Navigator.of(context).push(MaterialPageRoute(
                //               builder: (context) => SensorPrototype()));
                //         },
                //       ),
                //       SizedBox(width: 15),
                //       OutlinedButton(
                //         child: Text('Palette'),
                //         onPressed: () {
                //           Navigator.of(context).push(MaterialPageRoute(
                //               builder: (context) => ImageColors(
                //                   image: AssetImage('images/img18.jpg'))));
                //         },
                //       ),
                //       SizedBox(width: 15),
                //       OutlinedButton(
                //         child: Text('Chat Ui'),
                //         onPressed: () {
                //           Navigator.of(context).push(MaterialPageRoute(
                //               builder: (context) => ChatUiPrototype()));
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                buildPinnedView(context),
                const SizedBox(height: 10),
                buildUserContact(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
