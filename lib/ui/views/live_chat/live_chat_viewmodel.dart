import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:hint/constants/appwrite_constants.dart';

class LiveChatViewModel extends BaseViewModel {
  late Database database;
  final Client client = Client();
  final log = getLogger('LiveChatViewModel');

  initialisedVariables() {
    database = Database(client);
    client
        .setEndpoint(AppWriteConstants.apiEndPoint) // Your API Endpoint
        .setProject(AppWriteConstants.projectID); // Your project ID
  }

  addMessage({
    required Map<String, dynamic> data,
  }) async {
    try {
      await database.createDocument(
        collectionId: AppWriteConstants.liveChatscollectionID,
        data: data,
        read: ["*"],
        write: ['*'],
      );
    } on AppwriteException catch (e) {
      log.e(e.message);
    }
  }
}
