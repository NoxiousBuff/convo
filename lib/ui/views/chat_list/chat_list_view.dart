import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';
import 'package:hint/ui/views/distant_view/distant_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';

import 'chat_list_viewmodel.dart';

class ChatListView extends StatelessWidget {
  ChatListView({Key? key}) : super(key: key);

  final log = getLogger('ChatListView');
  final ChatListViewModel model = ChatListViewModel();

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

        List<UserListItem> userResults = [];

        for (var document in model.data!.docs) {
          UserListItem userListItem =
              UserListItem(userUid: document.get('userUid'));
          userResults.add(userListItem);
        }

        return userResults.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.all(0),
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: userResults,
              )
            : const Center(
                child: Text('There nothing\' here'),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatListViewModel>.reactive(
      disposeViewModel: true,
      viewModelBuilder: () => ChatListViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                leading: const Material(
                  color: Colors.transparent,
                  child: Icon(FeatherIcons.linkedin),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(FeatherIcons.userPlus),
                        onPressed: () {
                          navService.materialPageRoute(
                              context, const DistantView());
                        },
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(FeatherIcons.send),
                        onPressed: () {
                          navService.materialPageRoute(
                              context, const DistantView());
                        },
                      ),
                    ),
                  ],
                ),
                stretch: true,
                largeTitle: const Text('Friends'),
                border: Border.all(width: 0.0, color: Colors.transparent),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    // buildUserContact(model),
                    ListView.builder(
                          padding: const EdgeInsets.all(0),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 24,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {},
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              leading: ClipOval(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.indigo.shade300.withAlpha(30),
                                        Colors.indigo.shade400.withAlpha(50),
                                      ],
                                      focal: Alignment.topLeft,
                                      radius: 0.8,
                                    ),
                                  ),
                                  height: 56.0,
                                  width: 56.0,
                                  child: const Text(
                                    '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: screenWidthPercentage(context,
                                          percentage: 0.1)),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.shade400.withAlpha(30),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(''),
                                ),
                              ),
                              subtitle: Container(
                                margin: EdgeInsets.only(
                                    right: screenWidthPercentage(context,
                                        percentage: 0.4)),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade300.withAlpha(30),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(''),
                              ),
                            );
                          
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
