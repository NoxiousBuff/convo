import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: cwAuthAppBar(context, title: 'Archives', onPressed: () {
              Navigator.of(context).pop();
            }),
            // body: CustomScrollView(
            //   slivers: [
            //     Builder(builder: (context) {
            //       final data = model.data;
            //       if (model.hasError) {
            //         return const SliverToBoxAdapter(
            //           child: Center(
            //             child: Text('Archive Has Error'),
            //           ),
            //         );
            //       }
            //       if (!model.dataReady) {
            //         return SliverToBoxAdapter(
            //           child: loadingUserListItem(context),
            //         );
            //       }
            //       if (data != null) {
            //         final docs = data.docs;
            //         return docs.isNotEmpty
            //             ? SliverList(
            //                 delegate:
            //                     SliverChildBuilderDelegate((context, index) {
            //                 final doc = docs[index];
            //                 String uid = doc[RecentUserField.userUid];
            //                 return GestureDetector( onLongPress: () {
            //                   model.showTileOptions(uid, context);
            //                 }, child: UserListItem(userUid: uid));
            //               }, childCount: docs.length))
            //             : SliverToBoxAdapter(
            //               child: Column(
            //                   children: [
            //                     SizedBox(
            //                       height: MediaQuery.of(context).size.height * 0.2,
            //                     ),
            //                     const Icon(
            //                       CupertinoIcons.archivebox,
            //                       size: 200,
            //                       color: AppColors.darkGrey,
            //                     ),
            //                     Container(
            //                       margin:
            //                           const EdgeInsets.symmetric(horizontal: 20),
            //                       child: Text(
            //                         'There is no contacts available in archive box',
            //                         textAlign: TextAlign.center,
            //                         style: Theme.of(context)
            //                             .textTheme
            //                             .bodyText2!
            //                             .copyWith(fontSize: 20),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //             );
            //       } else {
            //         return const SliverToBoxAdapter(child: Text('Data is null.'));
            //       }
            //     }),
            //   ],
            // ),
            body: ValueListenableBuilder<Box>(
              valueListenable: hiveApi.hiveStream(HiveApi.archivedUsersHiveBox),
              builder: (context, archivedUsersBox, child) {
                final archivedUsersList = archivedUsersBox.values.toList();

                return archivedUsersList.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, i) {
                          final userUid = archivedUsersList[i];
                          return GestureDetector(
                            onLongPress: () {
                              model.showTileOptions(userUid, context);
                            },
                            child: UserListItem(userUid: userUid),
                          );
                        },
                        itemCount: archivedUsersList.length,
                      )
                    : Container(
                      alignment: Alignment.center,
                      child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            const Icon(
                              CupertinoIcons.archivebox,
                              size: 200,
                              color: AppColors.darkGrey,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    );
              },
            ));
      },
    );
  }
}
