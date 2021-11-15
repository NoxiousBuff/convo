import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:hint/models/user_contact.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserContacts extends StatelessWidget {
  UserContacts({Key? key}) : super(key: key);

  final hivebox = Hive.box(HiveHelper.userContactHiveBox);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            automaticallyImplyLeading: true,
            title: Text(
              'Contacts',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final hiveContact = hivebox.getAt(index);
                final contact = UserContact.fromJson(hiveContact);
                final image = CachedNetworkImageProvider(contact.photoUrl!);
                return ListTile(
                  leading: CircleAvatar(
                    maxRadius: 20,
                    backgroundImage: image,
                  ),
                  title: Text(
                    contact.contactName,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  subtitle: SizedBox(
                    width: screenWidthPercentage(context,percentage: 0.8),
                    child: Text(
                      contact.bio!,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                );
              },
              childCount: hivebox.length,
            ),
          ),
        ],
      ),
    );
  }
}
