import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'explore_viewmodel.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExploreViewModel>.reactive(
      viewModelBuilder: () => ExploreViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(elevation: 0.0,
        backgroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
              return states.contains(MaterialState.scrolledUnder) ? LightAppColors.primaryContainer : Colors.white;
            }),),
        extendBodyBehindAppBar: true,
        
        body: ListView.builder(itemBuilder: (context, index) {
          return ListTile(leading: Text(index.toString()),);
        })  
      ),
    );
  }
}
