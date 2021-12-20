import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

//Get cached document first rather than getting server document
extension FirestoreDocumentExtension
    on DocumentReference {
  Future<DocumentSnapshot> getSavy() async {
    try {
      DocumentSnapshot ds =
          await get(const GetOptions(source: Source.cache));
              
      return ds;
    } catch (e) {
      log('Extension via doc : ${e.toString()}');
      return get(const GetOptions(source: Source.server));
    }
  }
}

// Get cached query first rather than searching for server
extension FirestoreQueryExtension on Query {
  Future<QuerySnapshot> getSavy() async {
    try {
      QuerySnapshot qs = await get(const GetOptions(source: Source.cache))
          .timeout(const Duration(seconds: 3), onTimeout: () {
        return get(const GetOptions(source: Source.server));
      });
      if (qs.docs.isEmpty) return get(const GetOptions(source: Source.server));
      return qs;
    } catch (_) {
      return get(const GetOptions(source: Source.server));
    }
  }
}
