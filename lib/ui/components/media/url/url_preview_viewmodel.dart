import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/url_preview_model.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

class URLPreviewViewModel extends BaseViewModel {
  final log = getLogger('URLPreviewViewModel');
  URLPreviewModel? hiveData;
  bool _isExtracted = false;
  bool get isExtracted => _isExtracted;

  bool _hiveContainKey = false;
  bool get hiveContainKey => _hiveContainKey;

  void getHiveContain(bool containKey) {
    _hiveContainKey = containKey;
    notifyListeners();
  }

  void getHiveData(
      {required String conversationId, required String messageUid}) {
    final hiveBox = Hive.box('UrlData[$conversationId]');
    final savedData = hiveBox.get(messageUid);
    Map<String, dynamic> urlData = savedData.cast<String, dynamic>();
    hiveData = URLPreviewModel.fromJson(urlData);
    notifyListeners();
  }

  Future<void> getURLData(
      {required String url,
      required bool connected,
      required String conversationId,
      required String messageUid}) async {
    final extractedData = await MetadataFetch.extract(url);
    if (connected) {
      if (extractedData != null) {
        log.d('isExtracted:$_isExtracted');
        final previewImage = extractedData.image;
        http.Response response =
            await http.get(Uri.parse(previewImage!)).catchError((e) {
          log.e(e);
        });
        final urlData = <String, dynamic>{
          'url': extractedData.url,
          'title': extractedData.title,
          'previewImage': response.bodyBytes,
          'discription': extractedData.description,
        };
        final hiveBox = Hive.box('UrlData[$conversationId]');
        await hiveBox.put(messageUid, urlData);
        log.wtf(hiveBox.get(messageUid));
        _isExtracted = true;
        notifyListeners();
        log.d('isExtracted:$_isExtracted');
      } else {
        log.e('Extracted data is null now !!');
      }
    }
  }
}
