
import 'package:dio/dio.dart';
import 'package:hint/app/app_logger.dart';

final DioApi dioApi = DioApi();

class DioApi {
  static final Dio dio = Dio();
  final log = getLogger('DioApi');

  Future<void> downloadMediaFromUrl(
      {required String mediaUrl, required String savePath}) async {
    await dio
        .download(mediaUrl, savePath, deleteOnError: true,
            onReceiveProgress: (downloaded, total) {
          final progress = ((downloaded / total) * 100).toInt();
          print('Downloading Media Progress $progress');
        })
        .then((value) => getLogger('DioApi').i(
            'The file with mediaUrl : $mediaUrl has been successfully downloaded at savePath : $savePath.'))
        .catchError((err) {
          getLogger('DioApi').w(
              'There has been a problem with downloading a file. Error : $err');
          getLogger('DioApi').w('MediaUrl: $mediaUrl and savePath: $savePath');
        });
  }
}
