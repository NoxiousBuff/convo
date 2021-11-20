import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/phone_number.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserContacts extends StatefulWidget {
  const UserContacts({Key? key}) : super(key: key);

  @override
  State<UserContacts> createState() => _UserContactsState();
}

class _UserContactsState extends State<UserContacts> {
  final hivebox = Hive.box(HiveHelper.phoneNumberHiveBox);

  List<PhoneNumber> list() {
    final hiveBox = hivebox.values.toList();
    final hiveList = hiveBox.map((value) {
      final json = value.cast<String, dynamic>();
      return PhoneNumber.fromJson(json);
    }).toList();
    hiveList.sort((a, b) => a.contactName.compareTo(b.contactName));

    return hiveList;
  }

  Widget checker(String phoneNumber) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection(usersFirestoreKey)
          .where(UserField.phone, isEqualTo: phoneNumber)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        final snapshotData = snapshot.data;
        if (snapshotData != null) {
          if (snapshotData.docs.isEmpty &&
              snapshot.connectionState == ConnectionState.done) {
            return Container(
                color: activeGreen,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: const Text('Invite'));
          }
          if (snapshotData.docs.isNotEmpty &&
              snapshot.connectionState == ConnectionState.done) {
            // final doc = snapshot.data!.docs.first;
            // final data = doc.get('phone') as String;
            return const SizedBox(
                width: 80, child: Center(child: Text('Message')));
          }
        }
        return const Text('Checking....');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            automaticallyImplyLeading: true,
            actions: [
              IconButton(
                icon: const Icon(CupertinoIcons.info),
                onPressed: () {
                  showModalBottomSheet(
                    elevation: 4,
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height:
                            screenWidthPercentage(context, percentage: 0.28),
                        child: Column(
                          children: const [
                            ListTile(title: Text('Refresh')),
                            ListTile(title: Text('Help'))
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
            title: Text(
              'Contacts',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final contact = list()[index];
                const defaultImage = FirestoreApi.kDefaultPhotoUrl;
                const image = CachedNetworkImageProvider(defaultImage);
                return ListTile(
                  leading: const CircleAvatar(
                    maxRadius: 20,
                    backgroundImage: image,
                  ),
                  title: Text(
                    contact.contactName,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: checker(contact.number),
                  subtitle: SizedBox(
                    width: screenWidthPercentage(context, percentage: 0.8),
                    child: Text(
                      '${contact.countryCode} ${contact.number}',
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                );
              },
              childCount: list().length,
              addAutomaticKeepAlives: false,
            ),
          ),
        ],
      ),
    );
  }
}
