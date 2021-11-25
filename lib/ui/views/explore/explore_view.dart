import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/search_view/search_view.dart';
import 'package:stacked/stacked.dart';

import 'explore_viewmodel.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExploreViewModel>.reactive(
      viewModelBuilder: () => ExploreViewModel(),
      builder: (context, model, child) => Scaffold(
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              elevation: 0.0,
              backgroundColor: Colors.white,
              leadingWidth: 0,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Hero(
                  tag: 'search',
                  child: CupertinoTextField.borderless(
                    padding: const EdgeInsets.all(8.0),
                    readOnly: true,
                    onTap: () => navService.materialPageRoute(
                        context, const SearchView()),
                    placeholder: 'Search for someone',
                    placeholderStyle: TextStyle(color: Colors.grey.shade900),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              titleSpacing: 0,
            ),
            SliverStaggeredGrid.countBuilder(
              crossAxisCount: 3,
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) => Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text('$index'),
                  ),
                ),
              ),
              staggeredTileBuilder: (int index) => StaggeredTile.count(
                  index % 8 == 0 ? 2 : 1, index % 8 == 0 ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
          ],
        ),
      ),
    );
  }
}
