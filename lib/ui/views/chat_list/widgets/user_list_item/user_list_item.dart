import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/views/chat_list/widgets/user_item.dart';

class UserListItem extends StatelessWidget {
  UserListItem({Key? key, required this.userUid}) : super(key: key);
  final String userUid;
  final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
        .collection(subsFirestoreKey)
        .doc(userUid)
        .get(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return const CircularProgressIndicator.adaptive();
        }
        if(snapshot.hasError) {
          return const Center(child: Text('It has Error'),);
        }
        FireUser fireUser = FireUser.fromFirestore(snapshot.data!);
        return UserItem(fireUser: fireUser, onTap: () {
          chatService.startConversation(context, fireUser, Color(fireUser.colorHexCode));
        });
    });
  }

  // Widget buildUserListItem (BuildContext context, UserListItemModel model {
  //   return Builder(
  //     builder: (context) {
  //       if(!model.dataReady) {
  //         return const CircularProgressIndicator.adaptive();
  //       }
  //       if (model.hasError) {
  //         return const Center(
  //           child: Text('Model has Error'),
  //         );
  //       }
  //       return User
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return ViewModelBuilder<UserListItemModel>.reactive(
  //       viewModelBuilder: () => UserListItemModel(userUid: userUid),
  //       builder: (context, model, child) {
  //         return UserItem(
  //             fireUser: model.fireUser!,
  //             onTap: model.chatService.startConversation(
  //                 context, model.fireUser!, Colors.red.shade100));
  //       });
  // }
}
