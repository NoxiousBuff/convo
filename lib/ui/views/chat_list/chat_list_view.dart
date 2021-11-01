import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';
import 'package:hint/ui/views/distant_view/distant_view.dart';
import 'package:hint/ui/views/search_view/search_view.dart';
import 'chat_list_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';

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
                physics: const BouncingScrollPhysics(),
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
              trailing: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  navService.materialPageRoute(context, const DistantView());
                },),
              stretch: true,
              backgroundColor: Colors.white,
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
                  buildUserContact(model),
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