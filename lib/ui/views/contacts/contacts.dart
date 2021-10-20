import 'dart:math';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              body: _buildContactsView(model),
            ),
        viewModelBuilder: () => ContactsViewModel());
  }

  Widget _buildContactsView(ContactsViewModel model) {
    return model.contacts != null
        ? ListView.builder(
            itemBuilder: (context, i) {
              Color randomColor = Color.fromARGB(
                  Random().nextInt(256),
                  Random().nextInt(256),
                  Random().nextInt(256),
                  Random().nextInt(256));
              Contact contact = model.contacts!.elementAt(i);
              return _contactsListItem(contact, randomColor);
            },
            itemCount: model.contacts!.length,
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _contactsListItem(Contact contact, Color randomColor) {
    final displayName = contact.displayName;
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
                  Color.alphaBlend(randomColor.withAlpha(30), Colors.white),
                  Color.alphaBlend(randomColor.withAlpha(50), Colors.white),
                ],
                focal: Alignment.topLeft,
                radius: 0.8,
              ),
            ),
            height: 56.0,
            width: 56.0,
            child: contact.avatar!.isNotEmpty
                ? Image.memory(contact.avatar!)
                : Text(
                    displayName ?? 'DisplayName',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          displayName ?? 'Contacts',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      subtitle: SizedBox(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: contact.phones!.length,
          itemBuilder: (context, i) {
            Item item = contact.phones!.elementAt(i);
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
