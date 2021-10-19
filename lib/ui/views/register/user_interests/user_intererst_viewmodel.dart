import 'package:stacked/stacked.dart';

class InterestsViewModel extends BaseViewModel {
  final List<String> _selectedInterests = [];
  List<String> selectedInterests = [];

  int length() => _selectedInterests.length;

  void addInterest(String interest) => _selectedInterests.add(interest);
}
