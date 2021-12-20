import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'contacts_viewmodel.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContactsViewModel>.reactive(
      onModelReady: (model) => model.getContacts(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: cwAuthAppBar(context, title: 'Contacts'),
        body: CustomScrollView(
          slivers: [
            ValueListenableBuilder<Box>(
              valueListenable: hiveApi.hiveStream(HiveApi.userContacts),
              builder: (context, box, child) {
                final numbersList = box.values.toList();
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return Row(
                      children: [
                        Text(numbersList[i]),
                        horizontalSpaceSmall,
                        Expanded(
                          child: FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection(subsFirestoreKey)
                                .where(
                                  'phone',
                                  isEqualTo: numbersList[i],
                                )
                                .get(),
                            builder: (context, snapshot) {
                              log(i.toString());
                              if (snapshot.hasError) {
                                return const Text('Error');
                              }
                              final snapshotData = snapshot.data;
                              if (snapshotData != null) {
                                if (snapshotData.docs.isEmpty &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  return const Text('Invite');
                                }
                                if (snapshotData.docs.isNotEmpty &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  return const Text('Message');
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Checking....'),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }, childCount: numbersList.length,
                  addAutomaticKeepAlives: false,
                  ),
                );
              },
            )
          ],
        )
        // body: _buildContactsView(model),
      ),
      viewModelBuilder: () => ContactsViewModel(),
    );
  }
}
