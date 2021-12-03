import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
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

  Widget _buildContactsView(ContactsViewModel model) {
    return model.contacts != null
        ? ListView.separated(
            separatorBuilder: (context, i) {
              return const Divider();
            },
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              final contact = model.contacts!.elementAt(i);
              final phones = contact.phones;
              if (contact.phones!.isNotEmpty && phones != null) {
                for (Item phone in phones) {
                  final phoneNumber =
                      model.numberFormatter(phone.value.toString());
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(contact.displayName ?? 'No Name'),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(phoneNumber),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            contact.phones!.length.toString(),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection(subsFirestoreKey)
                                .where(
                                  'phone',
                                  isEqualTo: phoneNumber,
                                )
                                .get(),
                            builder: (context, snapshot) {
                              
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
                                  // final doc = snapshot.data!.docs.first;
                                  // final data = doc.get('phone') as String;
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
                        )
                      ],
                    ),
                  );
                }
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(contact.displayName ?? 'No Name'),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                          'You don\'t have a \nnumber for this \ncontact.'),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Unavailable',
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: model.contacts!.length,
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
