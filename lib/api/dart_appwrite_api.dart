
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:hint/constants/appwrite_constants.dart';

class DartAppWritApi {
   late Database database;
  final Client client = Client();

   DartAppWritApi._internal() {
    client
        .setEndpoint(AppWriteConstants.apiEndPoint)
        .setProject(AppWriteConstants.projectID);
    database = Database(client);
  }
}