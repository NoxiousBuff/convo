import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/search_view/search_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'explor_viewmodel.dart';

class ExplorView extends StatelessWidget {
  const ExplorView({Key? key}) : super(key: key);

  static const String id = '/ExplorVie';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExplorViewModel>.reactive(
      onModelReady: (model) {
        model.fetchImages();
      },
      viewModelBuilder: () => ExplorViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.scaffoldColor,
          leadingWidth: 0,
          title: InkWell(
            onTap: () =>
                navService.materialPageRoute(context, const SearchView()),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              width: screenWidth(context),
              child: const Text(
                'Search for someone',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.mediumBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                border: Border.all(
                  color: AppColors.grey,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                model.fetchImages();
              },
              icon: const Icon(FeatherIcons.activity),
              color: AppColors.black,
            )
          ],
        ),
        body: CustomScrollView(
          scrollBehavior: const CupertinoScrollBehavior(),
          slivers: [
            SliverStaggeredGrid.countBuilder(
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              crossAxisCount: 3,
              addAutomaticKeepAlives: false,
              staggeredTileBuilder: (int index) => StaggeredTile.count(
                  index % 8 == 0 ? 2 : 1, index % 8 == 0 ? 2 : 1),
              itemBuilder: (BuildContext context, int i) {
                final images = model.images[i];
                return SizedBox(
                  child: CachedNetworkImage(
                      imageUrl: images.webformatURL,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, progress) {
                        return Column(
                          children: [
                            Text(progress.progress.toString()),
                            Text(progress.downloaded.toString()),
                          ],
                        );
                      },
                      errorWidget: (context, url, error) {
                        return shrinkBox;
                      }),
                );
              },
              itemCount: model.images.length,
            ),
          ],
        ),
      ),
    );
  }
}
