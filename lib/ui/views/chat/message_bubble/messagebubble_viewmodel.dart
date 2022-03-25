import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/chat_service.dart';

class MessageBubbleViewModel extends BaseViewModel {
  /// This is log for printing in console
  final log = getLogger('MessageBubleViewModel');

  /// The unique ID of current user
  String currentUserID = FirestoreApi().currentUserId;

  /// calling reply message locator
  // final _replyLocator = locator.get<GetReplyMessageValue>();

  /// delete the selected Message
  void deleteMessage(BuildContext context,
      {required String fireUserID, required String messageUid}) {
    Navigator.pop(context);
    chatService.deleteChatMsg(fireUserID, messageUid);
  }

  /// This function remove the reaction of current user from the message
  void removeReaction(Message message, String fireUserID) {
    var _map = message.reactions;

    try {
      /// This will remove the reaction reaction from the map
      _map.remove(currentUserID);
    } catch (e) {
      log.e('UpdateMap Eror:$e');
    }

    /// This function update the value of reaction in firestore
    chatService
        .updateMessage(
            fielValue: _map,
            fireUserUid: fireUserID,
            messageUid: message.messageUid,
            fieldName: DocumentField.reactions)
        .whenComplete(() => log.wtf('Rection remove succesfully'))
        .catchError((e) => log.e('Update Message Error:$e'));
  }

  /// This function will react on the message
  void reactOnTheMessage(
    BuildContext context, {
    required Message message,
    required String fireUserID,
    required String reactionValue,
  }) {
    var _map = message.reactions;
    try {
      /// This will update the map of reactions
      _map.update(
        currentUserID,
        (value) => reactionValue,
        ifAbsent: () => reactionValue,
      );
    } catch (e) {
      log.e('UpdateMap Eror:$e');
    }

    /// This function update the value of reaction in firestore
    chatService
        .updateMessage(
          fielValue: _map,
          fireUserUid: fireUserID,
          messageUid: message.messageUid,
          fieldName: DocumentField.reactions,
        )
        .catchError((e) => log.e('Update Message Error:$e'));
    Navigator.pop(context);
  }
}
