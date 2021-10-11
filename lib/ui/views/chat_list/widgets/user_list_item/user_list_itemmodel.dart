// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hint/constants/app_keys.dart';
// import 'package:hint/services/chat_service.dart';
// import 'package:stacked/stacked.dart';

// class UserListItemModel extends FutureViewModel {

//   final String userUid;
//   UserListItemModel({Key? key, required this.userUid});
//   final ChatService chatService = ChatService();

//   Future<void> userUidToUserDoc(String userUid) async {
//     final userDoc = await FirebaseFirestore.instance
//         .collection(subsFirestoreKey)
//         .doc(userUid)
//         .get();
//     notifyListeners();
//   }

//   @override
//   Future futureToRun() => userUidToUserDoc(userUid);
// }
