import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

final memojiProvider = ChangeNotifierProvider((ref) => MemojiViewModel());

class MemojiViewModel extends BaseViewModel {
  final hiveboxName = HiveApi.hiveBoxEmojies;

  bool _unlockMemoji = false;
  bool get unlockMemoji => _unlockMemoji;

  List<String> _recentList = [];
  List<String> get recents => _recentList;

  bool _containRecent = false;
  bool get containRecent => _containRecent;

  bool isRecentContain(String path) => _recentList.contains(path);

  RewardedAd? _rewardedAd;

  static const int maxFailedLoadAttempts = 3;

  void memojiBool(bool memoji) {
    _unlockMemoji = memoji;
    notifyListeners();
  }

  void changeRecentHive(bool hive) {
    _containRecent = hive;
    notifyListeners();
  }

  void addToRecent(String memojiePath, String key) {
    _recentList.add(memojiePath);
    Hive.box(hiveboxName).put(key, _recentList);
    getLogger('EmojieViewModel').wtf("Added$memojiePath to recent");
    notifyListeners();
  }

  void getRecentMemojies(List<String> recentMemojies) {
    _recentList = recentMemojies;
    notifyListeners();
  }

  void createRewardedAd() {}

  void showRewardedAd() {
    if (_rewardedAd == null) {
      getLogger('AnimalMemojieViewModel').w('Warning: attempt to show rewarded before loaded.');
      return;
    }
  }

  // --------- Panda ---------
  bool _containPanda = false;
  bool get containPanda => _containPanda;

  bool _isPandaDownloading = false;
  bool get isPandaDownloading => _isPandaDownloading;

  List<String> _pandaList = [];
  List<String> get pandaList => _pandaList;

  bool changePandaDownloading(bool emo) {
    _isPandaDownloading = emo;
    notifyListeners();
    return emo;
  }

  void changePandaHive(bool hive) {
    _containPanda = hive;
    notifyListeners();
  }

  void getPandaHive(List<String> paths) {
    _pandaList = paths;
    notifyListeners();
  }

  Future<void> downloadPanda({
    required dynamic key,
    required String emojiFolder,
    required List<String> emojiesList,
  }) async {
    Directory? directory = await getExternalStorageDirectory();
    _isPandaDownloading = true;
    notifyListeners();
    for (var emoji in emojiesList) {
      final image = DateTime.now().microsecondsSinceEpoch.toString();
      final fileName = 'Panda-$image.jpeg';
      if (directory != null) {
        File savePath =
            File(directory.path + "/emojies/$emojiFolder/$fileName");
        await Dio().download(emoji, savePath.path,
            onReceiveProgress: (receiver, total) {
          final progress = ((receiver / total) * 100).toInt();
          getLogger('MemojieViewModel|PandaProgress').i(progress);
        }).catchError((e) {
          getLogger('MemojieViewModel').e('downloadPanda:$e');
        }).whenComplete(
            () => getLogger('MemojieViewModel').wtf('panda downloaded!!'));
        _pandaList.add(savePath.path);
      }
    }
    _isPandaDownloading = false;
    notifyListeners();
    HiveApi().saveInHive(hiveboxName, key, _pandaList);
    getLogger('MemojieViewModel').i('All Pandas Downloaded Successfully');
  }

  // ----------- Monkey ------------------
  bool _containMonkey = false;
  bool get containMonkey => _containMonkey;

  bool _isMonkeyDownloading = false;
  bool get isMonkeyDownloading => _isMonkeyDownloading;

  List<String> _monkeyList = [];
  List<String> get monkeyList => _monkeyList;

  bool changeMonkeyDownloading(bool emo) {
    _isMonkeyDownloading = emo;
    notifyListeners();
    return emo;
  }

  void changeMonkeyHive(bool hive) {
    _containMonkey = hive;
    notifyListeners();
  }

  void getMonkeyHive(List<String> paths) {
    _monkeyList = paths;
    notifyListeners();
  }

  Future<void> downloadMonkeys({
    required dynamic key,
    required String emojiFolder,
    required List<String> emojiesList,
  }) async {
    Directory? directory = await getExternalStorageDirectory();
    _isMonkeyDownloading = true;
    notifyListeners();
    for (var emoji in emojiesList) {
      final image = DateTime.now().microsecondsSinceEpoch.toString();
      final fileName = 'Monkey-$image.jpeg';
      if (directory != null) {
        File savePath =
            File(directory.path + "/emojies/$emojiFolder/$fileName");
        await Dio().download(emoji, savePath.path,
            onReceiveProgress: (receiver, total) {
          final progress = ((receiver / total) * 100).toInt();
          getLogger('MemojieViewModel|MonkeyProgress').i(progress);
        }).catchError((e) {
          getLogger('MemojieViewModel').e('downloadMonkey:$e');
        }).whenComplete(
            () => getLogger('MemojieViewModel').wtf('Monkey downloaded!!'));
        _monkeyList.add(savePath.path);
      }
    }
    _isMonkeyDownloading = false;
    notifyListeners();
    HiveApi().saveInHive(hiveboxName, key, _monkeyList);
    getLogger('MemojieViewModel').i('All Monkeys Downloaded Successfully');
  }

  //  ---------- WildBoar ------------
  bool _containBoar = false;
  bool get containBoar => _containBoar;

  bool _isBoarDownloading = false;
  bool get isBoarDownloading => _isBoarDownloading;

  List<String> _boarList = [];
  List<String> get boarList => _boarList;

  bool changeBoarDownloading(bool emo) {
    _isBoarDownloading = emo;
    notifyListeners();
    return emo;
  }

  void changeBoarHive(bool hive) {
    _containBoar = hive;
    notifyListeners();
  }

  void getBoarHive(List<String> paths) {
    _boarList = paths;
    notifyListeners();
  }

  Future<void> downloadBoar({
    required dynamic key,
    required String emojiFolder,
    required List<String> emojiesList,
  }) async {
    Directory? directory = await getExternalStorageDirectory();
    _isBoarDownloading = true;
    notifyListeners();
    for (var emoji in emojiesList) {
      final image = DateTime.now().microsecondsSinceEpoch.toString();
      final fileName = 'Boar-$image.jpeg';
      if (directory != null) {
        File savePath =
            File(directory.path + "/emojies/$emojiFolder/$fileName");
        await Dio().download(emoji, savePath.path,
            onReceiveProgress: (receiver, total) {
          final progress = ((receiver / total) * 100).toInt();
          getLogger('MemojieViewModel|BoarProgress').i(progress);
        }).catchError((e) {
          getLogger('MemojieViewModel').e('downloadBoar:$e');
        }).whenComplete(
            () => getLogger('MemojieViewModel').wtf('Boar downloaded!!'));
        _boarList.add(savePath.path);
      }
    }
    _isBoarDownloading = false;
    notifyListeners();
    HiveApi().saveInHive(hiveboxName, key, _boarList);
    getLogger('MemojieViewModel').i('All Boar Downloaded Successfully');
  }

  // ---------- Unicorn  -------------
  bool _containUnicorn = false;
  bool get containUnicorn => _containUnicorn;

  bool _isUnicornDownloading = false;
  bool get isUnicornDownloading => _isUnicornDownloading;

  List<String> _unicornList = [];
  List<String> get unicornList => _unicornList;

  bool changeUnicornDownloading(bool emo) {
    _isUnicornDownloading = emo;
    notifyListeners();
    return emo;
  }

  void changeUnicornHive(bool hive) {
    _containUnicorn = hive;
    notifyListeners();
  }

  void getUnicornHive(List<String> paths) {
    _unicornList = paths;
    notifyListeners();
  }

  Future<void> downloadUnicorn({
    required dynamic key,
    required String emojiFolder,
    required List<String> emojiesList,
  }) async {
    Directory? directory = await getExternalStorageDirectory();
    _isUnicornDownloading = true;
    notifyListeners();
    for (var emoji in emojiesList) {
      final image = DateTime.now().microsecondsSinceEpoch.toString();
      final fileName = 'Unicorn-$image.jpeg';
      if (directory != null) {
        File savePath =
            File(directory.path + "/emojies/$emojiFolder/$fileName");
        await Dio().download(emoji, savePath.path,
            onReceiveProgress: (receiver, total) {
          final progress = ((receiver / total) * 100).toInt();
          getLogger('MemojieViewModel|UnicornProgress').i(progress);
        }).catchError((e) {
          getLogger('MemojieViewModel').e('downloadUnicorn:$e');
        }).whenComplete(
            () => getLogger('MemojieViewModel').wtf('Unicorn downloaded!!'));
        _unicornList.add(savePath.path);
      }
    }
    _isUnicornDownloading = false;
    notifyListeners();
    HiveApi().saveInHive(hiveboxName, key, _unicornList);
    getLogger('MemojieViewModel').i('All Unicorn Downloaded Successfully');
  }
}
