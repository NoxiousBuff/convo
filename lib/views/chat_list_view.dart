import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/animations/balloon_animation.dart';
import 'package:hint/models/fire_user_model.dart';
import 'package:hint/prototypes/chat_ui_prototype.dart';
import 'package:hint/prototypes/image_colors_prototype.dart';
import 'package:hint/prototypes/sample_prototype.dart';
import 'package:hint/prototypes/sensors_proptotype.dart';
import 'package:hint/services/auth_methods.dart';
import 'package:hint/services/chat_methods.dart';
import 'package:hint/utilities/user_item.dart';
import 'package:hint/views/distant_view.dart';

class ChatListView extends StatefulWidget {
  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  bool scrollIsOnTop = true;
  ScrollController? scrollController;
  AuthMethods authMethods = AuthMethods();
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  Future<QuerySnapshot>? usersContactFuture;
  final ChatMethods chatMethods = ChatMethods();

  Widget buildPinnedView() {
    final deviceOrientation = MediaQuery.of(context).orientation;
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (deviceOrientation == Orientation.portrait) ? 3 : 5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BalloonsAnimation()));
                },
                child: Container(
                  height: 108.0,
                  width: 108.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/img$index.jpg'),
                      fit: BoxFit.cover,
                    ),
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
      child: Container(
        height: 128.0,
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Container(
                  height: 108.0,
                  width: 108.0,
                  child: Icon(CupertinoIcons.add),
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
                physics: BouncingScrollPhysics(),
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
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            title: Text(
              'Something Bad Happened',
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Please try again later.',
              textAlign: TextAlign.center,
            ),
            actions: [
              CupertinoButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }

        List<UserItem> userResults = [];
        snapshot.data!.docs.forEach(
          (document) {
            FireUser fireUser = FireUser.fromFirestore(document);
            UserItem userResult = UserItem(fireUser: fireUser);
            userResults.add(userResult);
          },
        );

        return userResults.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.only(left: 5),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: userResults,
              )
            : Center(
                child: Container(
                  child: Text('Nothing Is Here'),
                ),
              );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: CupertinoNavigationBar(
          border: Border(
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
                  CupertinoPageRoute(builder: (context) => DistantView()));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
              authMethods.signOut(context);
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
              size: 24.0,
            ),
          ),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: CupertinoColors.systemGroupedBackground,
          ),
          child: CupertinoScrollbar(
            radius: Radius.circular(20.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 15),
                      OutlinedButton(
                        child: Text('Hint Video'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SamplePrototype()));
                        },
                      ),
                      SizedBox(width: 15),
                      OutlinedButton(
                        child: Text('Sensors'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SensorPrototype()));
                        },
                      ),
                      SizedBox(width: 15),
                      OutlinedButton(
                        child: Text('Palette'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ImageColors(
                                  image: AssetImage('images/img18.jpg'))));
                        },
                      ),
                      SizedBox(width: 15),
                      OutlinedButton(
                        child: Text('Chat Ui'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatUiPrototype()));
                        },
                      ),
                    ],
                  ),
                ),
                buildPinnedView(),
                SizedBox(height: 10),
                buildUserContact(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
