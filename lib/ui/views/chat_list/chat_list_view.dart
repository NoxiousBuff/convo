import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/services/database_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';
import 'package:hint/ui/views/distant_view/distant_view.dart';
import 'package:hint/ui/views/dule/dule_view.dart';
import 'package:hint/ui/views/search_view/search_view.dart';
import 'chat_list_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';

class ChatListView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ChatListView({Key? key}) : super(key: key);

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
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

  Widget status(FireUser fireUser) {
    return StreamBuilder<Event?>(
      stream: FirebaseDatabase.instance
          .reference()
          .child(dulesRealtimeDBKey)
          .child(fireUser.id)
          .onValue,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return const Center(
            child: Text('Connecting...'),
          );
        } else {
          final snapshot = data.snapshot;
          final json = snapshot.value.cast<String, dynamic>();
          final duleModel = DuleModel.fromJson(json);
          bool isOnline = duleModel.online;
          return Text(
            isOnline ? 'Online' : 'Offline',
            style: Theme.of(context).textTheme.caption!.copyWith(
                color: isOnline ? AppColors.green : AppColors.darkGrey),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatListViewModel>.reactive(
      onModelReady: (model) async {
        model.scrollController = ScrollController();
      },
      disposeViewModel: true,
      viewModelBuilder: () => ChatListViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                backgroundColor: Colors.white,
                trailing: Material(
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      navService.materialPageRoute(
                          context, const DistantView());
                    },
                  ),
                ),
                stretch: true,
                largeTitle: const Text('Messages'),
                border: Border.all(width: 0.0, color: Colors.transparent),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Hero(
                        tag: 'search',
                        child: CupertinoTextField.borderless(
                          padding: const EdgeInsets.all(8.0),
                          readOnly: true,
                          onTap: () => navService.materialPageRoute(
                              context, const SearchView()),
                          placeholder: 'Search for someone',
                          placeholderStyle:
                              TextStyle(color: Colors.indigo.shade900),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            border: Border.all(
                                color: CupertinoColors.lightBackgroundGray),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    Builder(
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

                        final data = model.data!.docs;

                        return ListView.builder(
                          padding: const EdgeInsets.all(0),
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final fireUser =
                                FireUser.fromFirestore(data[index]);
                            return ListTile(
                              onTap: () {
                                String liveUserUid = AuthService.liveUser!.uid;
                                var convoUid = chatService.getConversationId(
                                    fireUser.id, liveUserUid);
                                databaseService.updateUserDataWithKey(
                                    DatabaseMessageField.roomUid, convoUid);
                                navService.cupertinoPageRoute(
                                  context,
                                  DuleView(
                                    fireUser:
                                        FireUser.fromFirestore(data[index]),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                maxRadius: 30,
                                backgroundImage: CachedNetworkImageProvider(
                                    fireUser.photoUrl),
                              ),
                              title: Text(
                                fireUser.username,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              subtitle: status(fireUser),
                            );
                          },
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
