import 'package:hint/app/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item/user_list_item.dart';

import 'archives_viewmodel.dart';

class ArchiveView extends StatefulWidget {
  const ArchiveView({Key? key}) : super(key: key);

  @override
  _ArchiveViewState createState() => _ArchiveViewState();
}

class _ArchiveViewState extends State<ArchiveView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ArchiveViewModel>.reactive(
      viewModelBuilder: () => ArchiveViewModel(),
      builder: (context, model, child) {
        final data = model.data;
        if (model.hasError) {
          return const Center(
            child: Text('Archive Has Error'),
          );
        }
        if (data != null) {
          final docs = data.docs;

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  stretch: true,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: true,
                  largeTitle: const Text('Archive'),
                  border: Border.all(width: 0.0, color: Colors.transparent),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      docs.isNotEmpty
                          ? SizedBox(
                              height: screenHeight(context),
                              child: ListView.builder(
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  final doc = docs[index];
                                  String uid = doc[RecentUserField.userUid];
                                  return GestureDetector(
                                      onLongPress: () =>
                                          model.showTileOptions(uid, context),
                                      child: UserListItem(userUid: uid));
                                },
                              ),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                ),
                                const Icon(
                                  CupertinoIcons.archivebox,
                                  size: 200,
                                  color: AppColors.darkGrey,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    'There is no contacts available in archive box',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('Data is null');
        }
      },
    );
  }
}