import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
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
          Widget child;
          if (snapshot.hasError) {
            return const Center(
              child: Text('It has Error'),
            );
          }
          if (!snapshot.hasData) {
            child = loadingUserListItem(context);
          } else {
            FireUser fireUser = FireUser.fromFirestore(snapshot.data!);
            child = UserItem(
                fireUser: fireUser,
                onTap: () {
                  chatService.startConversation(
                      context, fireUser, Color(fireUser.colorHexCode));
                });
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: child,
          );
        });
  }

  Widget loadingUserListItem(BuildContext context) {
    return ListTile(
      onTap: () {},
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      leading: ClipOval(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.indigo.shade300.withAlpha(30),
                Colors.indigo.shade400.withAlpha(50),
              ],
              focal: Alignment.topLeft,
              radius: 0.8,
            ),
          ),
          height: 56.0,
          width: 56.0,
          child: const Text(
            '',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Container(
          margin: EdgeInsets.only(
              right: screenWidthPercentage(context, percentage: 0.1)),
          decoration: BoxDecoration(
            color: Colors.indigo.shade400.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(''),
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(
            right: screenWidthPercentage(context, percentage: 0.4)),
        decoration: BoxDecoration(
          color: Colors.indigo.shade300.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(''),
      ),
    );
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
