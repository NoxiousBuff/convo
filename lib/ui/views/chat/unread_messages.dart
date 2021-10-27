import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UnReadMessages extends StatelessWidget {
  final String fireUserID;
  final String conversationId;
  const UnReadMessages(
      {Key? key, required this.fireUserID, required this.conversationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);
    const padding = EdgeInsets.symmetric(horizontal: 12, vertical: 2);
    final decoration = BoxDecoration(color: activeGreen, borderRadius: radius);
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection(convoFirestorekey)
          .doc(conversationId)
          .collection(chatsFirestoreKey)
          .where(DocumentField.senderUid, isEqualTo: fireUserID)
          .where(DocumentField.isRead, isEqualTo: false)
          .where(DocumentField.userBlockMe, isEqualTo: false)
          .get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('It has Error'),
          );
        }
        final data = snapshot.data;
        if (data != null) {
          final messagesLength = data.docs.length;
          return messagesLength != 0
              ? Container(
                  padding: padding,
                  decoration: decoration,
                  child: Text(
                    messagesLength.toString(),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: systemBackground),
                  ),
                )
              : const SizedBox.shrink();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
