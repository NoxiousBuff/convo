import 'package:stacked/stacked.dart';

class InterestsViewModel extends BaseViewModel {
  final List<String> _selectedInterests = [];
  List<String> get  selectedInterests => _selectedInterests;

  int length() => _selectedInterests.length;

  void addInterest(String interest) => _selectedInterests.add(interest);
}
