import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:stacked/stacked.dart';
import 'contacts_viewmodel.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({Key? key}) : super(key: key);

  final countryCodePattern =
      r'\+(?:998|996|995|994|993|992|977|976|975|974|973|972|971|970|968|967|966|965|964|963|962|961|960|886|880|856|855|853|852|850|692|691|690|689|688|687|686|685|683|682|681|680|679|678|677|676|675|674|673|672|670|599|598|597|595|593|592|591|590|509|508|507|506|505|504|503|502|501|500|423|421|420|389|387|386|385|383|382|381|380|379|378|377|376|375|374|373|372|371|370|359|358|357|356|355|354|353|352|351|350|299|298|297|291|290|269|268|267|266|265|264|263|262|261|260|258|257|256|255|254|253|252|251|250|249|248|246|245|244|243|242|241|240|239|238|237|236|235|234|233|232|231|230|229|228|227|226|225|224|223|222|221|220|218|216|213|212|211|98|95|94|93|92|91|90|86|84|82|81|66|65|64|63|62|61|60|58|57|56|55|54|53|52|51|49|48|47|46|45|44\D?1624|44\D?1534|44\D?1481|44|43|41|40|39|36|34|33|32|31|30|27|20|7|1\D?939|1\D?876|1\D?869|1\D?868|1\D?849|1\D?829|1\D?809|1\D?787|1\D?784|1\D?767|1\D?758|1\D?721|1\D?684|1\D?671|1\D?670|1\D?664|1\D?649|1\D?473|1\D?441|1\D?345|1\D?340|1\D?284|1\D?268|1\D?264|1\D?246|1\D?242|1)\D?';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContactsViewModel>.reactive(
      onModelReady: (model) => model.getContacts(),
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
              // final phone = model.numberFormatter(phones.first.value.toString());
              for (Item phone in phones) {
                final phoneNumber = model.numberFormatter(phone.value.toString()); 
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