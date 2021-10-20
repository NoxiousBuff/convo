import 'package:hint/constants/message_string.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchViewModel extends BaseViewModel {
  final ChatService _chatService = ChatService();

  Future<QuerySnapshot>? _searchResultFuture;
  Future<QuerySnapshot>? get searchResultFuture => _searchResultFuture;

  static final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(usersFirestoreKey);

  void handleSearch(String query) {
    Future<QuerySnapshot>? searchResults = subsCollection
        .where(UserField.username, isGreaterThanOrEqualTo: query)
        .get();
    _searchResultFuture = searchResults;
    notifyListeners();
  }

  void onUserItemTap(BuildContext context, FireUser fireUser) {
    _chatService.startConversation(context, fireUser, Colors.blue.shade50);
  }
}
