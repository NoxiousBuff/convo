import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/interest.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class UserInterests extends StatelessWidget {
  const UserInterests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      userInterest.science.length,
      (int index) => MultiSelectItem<String>(
          userInterest.science[index], userInterest.science[index]),
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          MultiSelectChipField(
            items: items,
            initialValue: userInterest.science,
            title: Text('Science',style: Theme.of(context).textTheme.bodyText1),
            decoration: BoxDecoration(
              border: Border.all(color: activeBlue, width: 1.8),
            ),
            selectedChipColor: Colors.blue.withOpacity(0.5),
            selectedTextStyle: TextStyle(color: Colors.blue[800]),
            onTap: (values) {
              //_selectedAnimals4 = values;
            },
          ),
        ],
      ),
    );
  }
}
