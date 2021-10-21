import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/services/auth_service.dart';
//import 'package:hint/ui/views/contacts/contacts.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/search_view/search_view.dart';
import 'package:hint/ui/views/distant_view/distant_view.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';
import 'package:hint/ui/views/recent_chats/recentchats_viewmodel.dart';

class RecentChats extends StatelessWidget {
  const RecentChats({Key? key}) : super(key: key);

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

        List<UserListItem> userResults = [];

        for (var document in model.data!.docs) {
          UserListItem userListItem =
              UserListItem(userUid: document.get('userUid'));
          userResults.add(userListItem);
        }

        return userResults.isNotEmpty
            ? ListView(
                shrinkWrap: true,
                children: userResults,
                padding: const EdgeInsets.only(left: 5),
                physics: const BouncingScrollPhysics(),
              )
            : Center(
                child: buttonWidget(
                  context: context,
                  text: 'Find you close friends',
                  onPressed: () async {},
                ),
              );

        // return userResults.isNotEmpty
        //     ? ImplicitlyAnimatedReorderableList<UserListItem>(
        //         items: userResults,
        //         itemBuilder: (context, animationIndex, animation, index) {},
        //         areItemsTheSame: (a, b) => a.userUid == b.userUid,
        //         onReorderFinished: (a, x, y, userResultsList) {
        //           return ;
        //         },
        //       )
        //     : const Center(
        //         child: Text('fbdjskfbjfdsbjxdbnvfbhsdjvkb'),
        //       );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: appSettings.listenable(),
      builder: (context, box, child) {
        bool darkMode = box.get(darkModeKey, defaultValue: false);
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
                        enterTo:
                            DistantView(liveUserUid: AuthService.liveUser!.uid),
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
                  icon: Icon(
                    Icons.search,
                    color: darkMode ? systemBackground : activeBlue,
                    size: 24.0,
                  ),
                ),
              ),
              body: buildUserContact(model),
            );
          },
        );
      },
    );
  }
}
