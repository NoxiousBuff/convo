import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:hint/ui/views/contacts/contacts_viewmodel.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContactsViewModel>.reactive(
        onModelReady: (model) {
          model.getContacts();
        },
        builder: (context, model, child) => Scaffold(
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                slivers: [
                  const CupertinoSliverNavigationBar(
                    largeTitle: Text('Contacts'),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            children: const [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Contact name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Phone Number',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'User Status',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildContactsView(model),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        viewModelBuilder: () => ContactsViewModel());
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
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(contact.displayName ?? 'No Name')),
                      Expanded(
                          flex: 1,
                          child: Text(contact.phones!.first.value
                              .toString()
                              .replaceAll(RegExp(r"\s+"), ""))),
                      Flexible(
                        flex: 1,
                        child: FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection(usersFirestoreKey)
                              .where(UserField.phone,
                                  isEqualTo: phones.first.value
                                      .toString()
                                      .replaceAll(RegExp(r"\s+"), ""))
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

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1, child: Text(contact.displayName ?? 'No Name')),
                    const Expanded(
                        flex: 1,
                        child: Text(
                            'You don\'t have a \nnumber for this \ncontact.')),
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
        : const Center(child: CircularProgressIndicator());
  }
}

class ContactListItem extends StatefulWidget {
  const ContactListItem({
    Key? key,
    required this.contact,
    required this.randomColor,
  }) : super(key: key);

  final Contact contact;
  final Color randomColor;

  @override
  State<ContactListItem> createState() => _ContactListItemState();
}

class _ContactListItemState extends State<ContactListItem> {
  @override
  Widget build(BuildContext context) {
    final phoneList = widget.contact.phones;
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection(usersFirestoreKey)
          .where(UserField.phone,
              isEqualTo:
                  phoneList != null ? phoneList.first.value : '1234567890')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return listItemUi('Error');
        }
        if (!snapshot.hasError &&
            snapshot.connectionState == ConnectionState.done) {
          return listItemUi('Done');
        }
        return listItemUi('Checking..');
      },
    );
  }

  ListTile listItemUi(String text) {
    return ListTile(
      onTap: () {},
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      leading: GestureDetector(
        onTap: () {},
        child: ClipOval(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.alphaBlend(
                      widget.randomColor.withAlpha(30), Colors.white),
                  Color.alphaBlend(
                      widget.randomColor.withAlpha(50), Colors.white),
                ],
                focal: Alignment.topLeft,
                radius: 0.8,
              ),
            ),
            height: 56.0,
            width: 56.0,
            child: widget.contact.avatar!.isNotEmpty
                ? Image.memory(widget.contact.avatar!)
                : Text(
                    widget.contact.displayName![0],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          widget.contact.displayName ?? 'Contacts',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      trailing: Text(text),
      subtitle: SizedBox(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.contact.phones!.length,
          itemBuilder: (context, i) {
            Item item = widget.contact.phones!.elementAt(i);
            return Text(
              item.value ?? 'Empty',
              style:
                  const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
            );
          },
        ),
      ),
    );
  }
}
