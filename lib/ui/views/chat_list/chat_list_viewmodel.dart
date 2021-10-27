// import 'package:stacked/stacked.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:hint/app/app_logger.dart';
// import 'package:hint/constants/app_keys.dart';
// import 'package:hint/models/user_model.dart';
// import 'package:hint/services/auth_service.dart';
// import 'package:hint/services/chat_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatListViewModel extends FutureViewModel<QuerySnapshot> {
//   late FireUser fireUser;
//   final bool _scrollIsOnTop = true;
//   ScrollController? scrollController;
//   bool get scrollIsOnTop => _scrollIsOnTop;
//   AuthService authService = AuthService();
//   ChatService chatService = ChatService();
//   final log = getLogger('ChatListViewModel');
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   final CollectionReference usersCollection =
//       FirebaseFirestore.instance.collection(usersFirestoreKey);

//   Future<void> currentUserDoc() async {
//     final currentUser = _auth.currentUser;
//     if (currentUser != null) {
//       final user = await _firestore
//           .collection(usersFirestoreKey)
//           .doc(currentUser.uid)
//           .get();
//       fireUser = FireUser.fromFirestore(user);
//       notifyListeners();
//     } else {
//       log.wtf("user is currently logged out");
//     }
//   }


//   @override
//   Future<QuerySnapshot> futureToRun() => usersCollection.get();
// }
