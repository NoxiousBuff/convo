import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'interest_viewmodel.dart';

class InterestView extends StatelessWidget {
  const InterestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InterestViewModel>.reactive(
      viewModelBuilder: () => InterestViewModel(),
      builder: (context, model, child) => const Scaffold(
        body: Center(
          child: Text('Interest'),
        ),
      ),
    );
  }
}
