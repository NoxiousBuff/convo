import 'package:tenor/tenor.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

final memeProvider = ChangeNotifierProvider((ref) => MemesViewModel());

class MemesViewModel extends ChangeNotifier {
  final NativeAdController _controller = NativeAdController();

  String? _connection;
  String? get connection => _connection;

  final Connectivity _connectivity = Connectivity();
  Connectivity get connectivity => _connectivity;

  final List<String?> _selectedMemes = [];
  List<String?> get selectedMemes => _selectedMemes;

  // search Memes
  TenorResponse? _memes;
  TenorResponse? get memes => _memes;

  // search Memes
  TenorResponse? _nextMemes;
  TenorResponse? get nextMemes => _nextMemes;

  // API Key
  final Tenor _tenor = Tenor(apiKey: 'GA1DKUNW049A');
  Tenor get tenor => _tenor;

  void adController() {
    _controller.load(keywords: ['valorant', 'games', 'fortnite']);
    _controller.onEvent.listen((event) {
      if (event.keys.first == NativeAdEvent.loaded) {
        notifyListeners();
      }
    });
  }

  void addMemes(String? meme) {
    _selectedMemes.add(meme);

    notifyListeners();
  }

  void removeMemes(String? meme) {
    _selectedMemes.remove(meme);
    notifyListeners();
  }

  bool contain(String? meme) {
    final containing = _selectedMemes.contains(meme);
    notifyListeners();
    return containing;
  }

  // First set of memes
  Future<TenorResponse?> fetchedMemes(String search) async {
    TenorResponse? res =
        await _tenor.searchGIF(search, limit: 1000, size: GifSize.standard);
    _memes = res;
    notifyListeners();
  }

  // Next set of memes
  Future<TenorResponse?> fetchNextSet(String search) async {
    TenorResponse? firstSetResponse = await tenor.searchGIF(search);

    TenorResponse? nextResult = await firstSetResponse?.fetchNext(limit: 1000);

    _nextMemes = nextResult;
    notifyListeners();
  }
}
