import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:path_provider/path_provider.dart';

class EmojieViewModel extends BaseViewModel {
  final hiveboxName = HiveHelper.hiveBoxEmojies;

  bool _containRecent = false;
  bool get containRecent => _containRecent;

  List<String> _recentEmojies = [];
  List<String> get recentEmojies => _recentEmojies;

  bool isContain(String path) => _recentEmojies.contains(path);

  void addToRecentEmojies(String path, String key) {
    _recentEmojies.add(path);
    Hive.box(hiveboxName).put(key, _recentEmojies);
    getLogger('EmojieViewModel').wtf("emojie is Added$path to recent");
    notifyListeners();
  }

  void getRecentEmojies(List<String> recentEmojies) {
    _recentEmojies = recentEmojies;
    notifyListeners();
  }

  void getRecentHive(bool hiveBool) {
    _containRecent = hiveBool;
    notifyListeners();
  }

  /// -------- Black Emojies ----------
  bool _containBlackEmoji = false;
  bool get containBlackEmojie => _containBlackEmoji;

  bool _isBlackEmojiDownloading = false;
  bool get isBlackEmojieDownloading => _isBlackEmojiDownloading;

  List<String> _blackEmojies = [];
  List<String> get blackEmojies => _blackEmojies;

  bool changeBlackDownloading(bool emo) {
    _isBlackEmojiDownloading = emo;
    notifyListeners();
    return emo;
  }

  void changeBlackHive(bool hive) {
    _containBlackEmoji = hive;
    notifyListeners();
  }

  void getBlackHive(List<String> paths) {
    _blackEmojies = paths;
    notifyListeners();
  }

  Future<void> downloadBlackEmojies({
    required dynamic key,
    required String emojiFolder,
    required List<String> emojiesList,
  }) async {
    Directory? directory = await getExternalStorageDirectory();
    _isBlackEmojiDownloading = true;
    notifyListeners();
    for (var emoji in emojiesList) {
      final image = DateTime.now().microsecondsSinceEpoch.toString();
      final fileName = 'BlackEmojie-$image.jpeg';
      if (directory != null) {
        File savePath =
            File(directory.path + "/emojies/$emojiFolder/$fileName");
        await Dio().download(emoji, savePath.path,
            onReceiveProgress: (receiver, total) {
          final progress = ((receiver / total) * 100).toInt();
          getLogger('EmojieViewModel|BlackEmojieProgress').wtf(progress);
        }).catchError((e) {
          getLogger('EmojieViewModel').e('downloadBlackEmojies:$e');
        }).whenComplete(
            () => getLogger('EmojiViewModel').wtf('emojie downloaded!!'));
        _blackEmojies.add(savePath.path);
      }
    }
    _isBlackEmojiDownloading = false;
    notifyListeners();
    HiveHelper().saveInHive(hiveboxName, key, _blackEmojies);
    getLogger('EmojieViewModel').wtf('All BlackEmojies Downloaded Successfully');
  }

  /// ---------- kolabanga ----------
  bool _containKolabanga = false;
  bool get containKolabanga => _containKolabanga;

  bool _isKolabangaDownloading = false;
  bool get isKolabangaDownloading => _isKolabangaDownloading;

  List<String> _kolabangaEmojies = [];
  List<String> get kolabangaEmojies => _kolabangaEmojies;

  bool changeKolabangaDownloading(bool emo) {
    _isKolabangaDownloading = emo;
    notifyListeners();
    return emo;
  }

  void changeKolabangaHive(bool hive) {
    _containKolabanga = hive;
    notifyListeners();
  }

  void getKolabangaHive(List<String> paths) {
    _kolabangaEmojies = paths;
    notifyListeners();
  }

  Future<void> downloadKolabanga({
    required dynamic key,
    required String emojiFolder,
    required List<String> emojiesList,
  }) async {
    Directory? directory = await getExternalStorageDirectory();
    _isKolabangaDownloading = true;
    notifyListeners();
    for (var emoji in emojiesList) {
      final image = DateTime.now().microsecondsSinceEpoch.toString();
      final fileName = 'Emojie-$image.jpeg';
      if (directory != null) {
        File savePath =
            File(directory.path + "/emojies/$emojiFolder/$fileName");
        await Dio().download(emoji, savePath.path,
            onReceiveProgress: (receiver, total) {
          final progress = ((receiver / total) * 100).toInt();
          getLogger('EmojieViewModel|KolabangaProgress').i(progress);
        }).catchError((e) {
          getLogger('EmojieViewModel').e('downloadKolabanga:$e');
        }).whenComplete(
            () => getLogger('EmojiViewModel').wtf('Kolabanga downloaded!!'));
        _kolabangaEmojies.add(savePath.path);
      }
    }
    _isKolabangaDownloading = false;
    notifyListeners();
    HiveHelper().saveInHive(hiveboxName, key, _kolabangaEmojies);
    getLogger('EmojieViewModel').i('All Kolabanga Download Successfully');
  }

  /// ------- White Emoji -------
  bool _containWhite = false;
  bool get containWhiteEmojies => _containWhite;

  bool _isWhiteDownloading = false;
  bool get isWhiteDownloading => _isWhiteDownloading;

  List<String> _whiteEmojies = [];
  List<String> get whiteEmojies => _whiteEmojies;

  bool changeWhiteDownloading(bool emo) {
    _isWhiteDownloading = emo;
    notifyListeners();
    return emo;
  }

  void changeWhiteHive(bool hive) {
    _containWhite = hive;
    notifyListeners();
  }

  void getWhiteHive(List<String> paths) {
    _whiteEmojies = paths;
    notifyListeners();
  }

  Future<void> downloadWhiteEmojies({
    required dynamic key,
    required String emojiFolder,
    required List<String> emojiesList,
  }) async {
    Directory? directory = await getExternalStorageDirectory();
    _isWhiteDownloading = true;
    notifyListeners();
    for (var emoji in emojiesList) {
      final image = DateTime.now().microsecondsSinceEpoch.toString();
      final fileName = 'Emojie-$image.jpeg';
      if (directory != null) {
        File savePath =
            File(directory.path + "/emojies/$emojiFolder/$fileName");
        await Dio().download(emoji, savePath.path,
            onReceiveProgress: (receiver, total) {
          final progress = ((receiver / total) * 100).toInt();
          getLogger('EmojieViewModel|WhiteEmojieProgress').i(progress);
        }).catchError((e) {
          getLogger('EmojieViewModel').e('downloadWhiteEmojies:$e');
        }).whenComplete(
            () => getLogger('EmojiViewModel').wtf('WhiteEmoji downloaded!!'));
        _whiteEmojies.add(savePath.path);
      }
    }
    _isWhiteDownloading = false;
    notifyListeners();
    HiveHelper().saveInHive(hiveboxName, key, _whiteEmojies);
    getLogger('EmojieViewModel').i('All WhiteEmojies Download Successfully');
  }

  // ------------------ Emoji3D --------------
  bool _contain3DEmoji = false;
  bool get contain3DEmoji => _contain3DEmoji;

  bool _is3DEmojieDownloading = false;
  bool get is3DEmojieDownloading => _is3DEmojieDownloading;

  List<String> _emojies3D = [];
  List<String> get emojies3D => _emojies3D;

  bool change3DEmojieDownloading(bool emo) {
    _is3DEmojieDownloading = emo;
    notifyListeners();
    return emo;
  }

  void change3DEmojieHive(bool hive) {
    _contain3DEmoji = hive;
    notifyListeners();
  }

  void get3DHive(List<String> paths) {
    _emojies3D = paths;
    notifyListeners();
  }

  Future<void> download3DEmojies({
    required dynamic key,
    required String emojiFolder,
    required List<String> emojiesList,
  }) async {
    Directory? directory = await getExternalStorageDirectory();
    _is3DEmojieDownloading = true;
    notifyListeners();
    for (var emoji in emojiesList) {
      final image = DateTime.now().microsecondsSinceEpoch.toString();
      final fileName = 'Emojie-$image.jpeg';
      if (directory != null) {
        File savePath =
            File(directory.path + "/emojies/$emojiFolder/$fileName");
        await Dio().download(emoji, savePath.path,
            onReceiveProgress: (receiver, total) {
          final progress = ((receiver / total) * 100).toInt();
          getLogger('EmojieViewModel|3DEmojieProgress').i(progress);
        }).catchError((e) {
          getLogger('EmojieViewModel').e('download3DEmojies:$e');
        }).whenComplete(
            () => getLogger('EmojiViewModel').wtf('3DEmoji downloaded!!'));
        _emojies3D.add(savePath.path);
      }
    }
    _is3DEmojieDownloading = true;
    notifyListeners();
    HiveHelper().saveInHive(hiveboxName, key, _emojies3D);
    getLogger('EmojieViewModel').i('All 3DEmojies Download Successfully');
  }

  // --------- Smiley ----------------
  bool _containSmiley = false;
  bool get containSmiley => _containSmiley;

  bool _isSmileyDownloading = false;
  bool get isSmileyDownloading => _isSmileyDownloading;

  List<String> _smilies = [];
  List<String> get smilies => _smilies;

  bool changeSmileyDownloading(bool emo) {
    _isSmileyDownloading = emo;
    notifyListeners();
    return emo;
  }

  void changeSmileyHive(bool hive) {
    _containSmiley = hive;
    notifyListeners();
  }

  void getSmileyHive(List<String> paths) {
    _smilies = paths;
    notifyListeners();
  }

  Future<void> downloadSmilies({
    required dynamic key,
    required String emojiFolder,
    required List<String> emojiesList,
  }) async {
    Directory? directory = await getExternalStorageDirectory();
    _isSmileyDownloading = true;
    notifyListeners();
    for (var emoji in emojiesList) {
      final image = DateTime.now().microsecondsSinceEpoch.toString();
      final fileName = 'Emojie-$image.jpeg';
      if (directory != null) {
        File savePath =
            File(directory.path + "/emojies/$emojiFolder/$fileName");
        await Dio().download(emoji, savePath.path,
            onReceiveProgress: (receiver, total) {
          final progress = ((receiver / total) * 100).toInt();
          getLogger('EmojieViewModel|SmileyProgress').i(progress);
        }).catchError((e) {
          getLogger('EmojieViewModel').e('downloadSmilies:$e');
        }).whenComplete(
            () => getLogger('EmojiViewModel').wtf('Smiley downloaded!!'));
        _smilies.add(savePath.path);
      }
    }
    _isSmileyDownloading = true;
    notifyListeners();
    HiveHelper().saveInHive(hiveboxName, key, _smilies);
    getLogger('EmojieViewModel').i('All Smilies Download Successfully');
  }
}
