import 'package:stacked/stacked.dart';

class PrivacyViewModel extends BaseViewModel {
  String profileSubtitle = 'Everyone';

  String lastSeenSubtitle = 'Everyone';

  String aboutSubtitle = 'Everyone';

  int? lastSeenValue = 0;

  int? profileValue = 0;

  int? aboutValue = 0;

  bool readReceipts = false;

  void currentIndex(int? i) {
    lastSeenValue = i;
    switch (i) {
      case 0:
        {
          lastSeenSubtitle = 'Everyone';
        }

        break;
      case 1:
        {
          lastSeenSubtitle = 'My contacts';
        }
        break;
      case 2:
        {
          lastSeenSubtitle = 'Only me';
        }
        break;
      default:
        {
          lastSeenSubtitle = '';
        }
    }
    notifyListeners();
  }

  void photoValueIndex(int? i) {
    profileValue = i;
    switch (i) {
      case 0:
        {
          profileSubtitle = 'Everyone';
        }

        break;
      case 1:
        {
          profileSubtitle = 'My contacts';
        }
        break;
      case 2:
        {
          profileSubtitle = 'Only me';
        }
        break;
      default:
        {
          profileSubtitle = '';
        }
    }
    notifyListeners();
  }

  void aboutValueIndex(int? i) {
    aboutValue = i;
    switch (i) {
      case 0:
        {
          aboutSubtitle = 'Everyone';
        }

        break;
      case 1:
        {
          aboutSubtitle = 'My contacts';
        }
        break;
      case 2:
        {
          aboutSubtitle = 'Only me';
        }
        break;
      default:
        {
          aboutSubtitle = '';
        }
    }
    notifyListeners();
  }

  void readReceiptsBool(bool read) {
    readReceipts = read;
    notifyListeners();
  }

  List<String> dialogptions = [
    'Everyone',
    'My contacts',
    'only me',
  ];
}
