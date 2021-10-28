import 'package:dart_appwrite/dart_appwrite.dart';

class GetDocumentsList {
  final int sum;
  final List<dynamic> documents;
  GetDocumentsList({required this.sum, required this.documents});

  factory GetDocumentsList.fromJson(Response<dynamic> json) {
    return GetDocumentsList(
      sum: json.data['sum'],
      documents: json.data['documents'],
    );
  }
}
