import 'package:dio/dio.dart';

class DioHelper {
  static final Dio dioHelper = Dio();

  Future<void> downloadMediaFromUrl(
      {required String mediaUrl, required String savePath}) async {
    await dioHelper.download(mediaUrl, savePath, deleteOnError: true);
  }
}
