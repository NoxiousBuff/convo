import 'package:dio/dio.dart';
import 'package:hint/app/app_logger.dart';

class DioHelper {
  static final Dio dioHelper = Dio();

  Future<void> downloadMediaFromUrl(
      {required String mediaUrl, required String savePath}) async {
    await dioHelper
        .download(mediaUrl, savePath, deleteOnError: true)
        .then((value) => getLogger('DioApi').i(
            'The file with mediaUrl : $mediaUrl has been successfully downloaded at savePathh : $savePath.'))
        .catchError((err) {
      getLogger('DioApi')
          .w('There has been a problem with downloading a file. Error : $err');
      getLogger('DioApi').w('MediaUrl: $mediaUrl and savePath: $savePath');
    });
  }
}
