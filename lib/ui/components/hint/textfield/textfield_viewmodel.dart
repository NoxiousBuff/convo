import 'dart:io';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:image_picker/image_picker.dart';

class TextFieldViewModel extends BaseViewModel {
  /// If it is true then emojies will display,
  bool _blackEmojie = false;
  bool get blackEmojie => _blackEmojie;

  /// For toggling the visibility emojies [Black Emojies]
  void emojieChanger(bool emojie) {
    _blackEmojie = emojie;
    notifyListeners();
  }

  /// If it is true then memes will display
  bool _showMemes = false;
  bool get showMemes => _showMemes;

  /// For toggling the visibility memes
  void memeChanger(bool meme) {
    _showMemes = meme;
    notifyListeners();
  }

  /// If it is true then memojies will display
  bool _showMemojies = false;
  bool get showMemojies => _showMemojies;

  /// For toggling the visibility of memojies
  void toggleMemojies(bool memojie) {
    _showMemojies = memojie;
    notifyListeners();
  }

  /// For displaying PixaBay Images
  bool _showPixaBay = false;
  bool get showPixaBay => _showPixaBay;

  /// For toggle the visibility of PixaBay Images
  void pixaBayToggle(bool pixaBay) {
    _showPixaBay = pixaBay;
    notifyListeners();
  }

  /// For displaying Animal Memojies
  bool _showAnimalMemojies = false;
  bool get showAnimalMemohjies => _showAnimalMemojies;

  /// For toggle the visibility of Animal Memojies
  void animalToggle(bool animalMemojie) {
    _showAnimalMemojies = animalMemojie;
    notifyListeners();
  }

  /// Clicking Image from camera
  Future<File?> pickImage() async {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (selectedImage != null) {
      return File(selectedImage.path);
    } else {
      getLogger('ChatViewModel').wtf('pickImage | Image not clicked');
    }
  }

  /// Record a Video from camera
  Future<File?> pickVideo() async {
    final selectedVideo =
        await ImagePicker().pickVideo(source: ImageSource.camera);

    if (selectedVideo != null) {
      return File(selectedVideo.path);
    } else {
      getLogger('ChatViewModel').wtf('pickVideo | Video was not recorded');
    }
  }
}
