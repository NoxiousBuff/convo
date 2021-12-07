import 'dart:math';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

import 'explore_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/nav_service.dart';
import 'package:pixabay_picker/pixabay_picker.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:pixabay_picker/model/pixabay_media.dart';
import 'package:hint/ui/views/search_view/search_view.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  bool isLoading = false;
  bool initialData = true;
  List<String> imagesList = [];
  final log = getLogger('ExploreView');
  ScrollController scrollController = ScrollController();
  PixabayPicker picker = PixabayPicker(apiKey: pixaBayApiKey);
  // String defaultImage = 'https://pixabay.com/images/id-6818683/';

  List<String> categoriesList = [
    Category.animals,
    Category.backgrounds,
    Category.buildings,
    Category.business,
    Category.computer,
    Category.education,
    Category.feelings,
    Category.food,
    Category.health,
    Category.industry,
    Category.music,
    Category.places,
    Category.religion,
    Category.science,
    Category.sports,
    Category.transportation,
    Category.travel,
  ];

  Future<PixabayResponse?> getImages() async {
    String category = categoriesList[Random().nextInt(categoriesList.length)];
    log.wtf('Category:$category');
    return picker.api?.requestImages(resultsPerPage: 25, category: category);
  }

  Future<void> fetchImages() async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await getImages();
      var list = response!.hits;
      if (list != null) {
        for (var pixaBayMedia in list) {
          var url = pixaBayMedia.getThumbnailLink();
          imagesList.add(url!);
        }
      } else {
        log.wtf('Image not fetched yet');
      }
      if (initialData) {
        setState(() {
          initialData = false;
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log.e('fetchImages');
    }
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      log.wtf("reach the bottom");
      fetchImages();
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      log.wtf("reach the top");
    }
  }

  @override
  void initState() {
    fetchImages();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);

    super.initState();
  }

  Widget loadingItems() {
    return SliverStaggeredGrid.countBuilder(
      itemCount: 25,
      crossAxisCount: 3,
      itemBuilder: (_, i) => Container(color: Colors.grey.shade200),
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(index % 8 == 0 ? 2 : 1, index % 8 == 0 ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget loading() {
    return isLoading
        ? Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(bottom: 20),
            child: const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                valueColor: AlwaysStoppedAnimation(AppColors.blue),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExploreViewModel>.reactive(
      viewModelBuilder: () => ExploreViewModel(),
      builder: (context, model, child) => Scaffold(
        extendBodyBehindAppBar: true,
        body: OfflineBuilder(
          child: const Text(''),
          connectivityBuilder: (context, connection, child) {
            bool connected = connection != ConnectivityResult.none;
            return CustomScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  snap: true,
                  floating: true,
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  leadingWidth: 0,
                  title: InkWell(
                    onTap: () => navService.cupertinoPageRoute(
                        context, const SearchView()),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      width: screenWidth(context),
                      child: Text('Search for someone',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontSize: 16, color: Colors.grey.shade900)),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                initialData
                    ? loadingItems()
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 3,
                        itemCount: imagesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: ExtendedImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(imagesList[index]),
                              
                            ),
                          );
                        },
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.count(
                                index % 8 == 0 ? 2 : 1, index % 8 == 0 ? 2 : 1),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      ),
                SliverToBoxAdapter(
                  child: connected
                      ? loading()
                      : InkWell(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                FeatherIcons.plus,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
        // Column(
        //   children: [
        //     Expanded(
        //       child: GridView.builder(
        //         shrinkWrap: true,
        //         controller: scrollController,
        //         itemCount: imagesList.length,
        //         physics: const BouncingScrollPhysics(),
        //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //             crossAxisCount: 2),
        //         itemBuilder: (BuildContext context, int index) {
        //           return Container(
        //             width: 80,
        //             height: 80,
        //             color: Colors.grey.shade200,
        //             child: CachedNetworkImage(
        //               fit: BoxFit.cover,
        //               imageUrl: imagesList[index],
        //               placeholder: (_, url) => Container(
        //                 height: 80,
        //                 width: 80,
        //                 color: Colors.grey.shade200,
        //               ),
        //               errorWidget: (_, url, error) => const Icon(Icons.error),
        //             ),
        //           );
        //         },
        //       ),
        //     ),
        //     isLoading
        //         ? Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Load More',
        //                   style: Theme.of(context).textTheme.caption,
        //                 ),
        //                 const SizedBox(width: 8),
        //                 const SizedBox(
        //                   height: 20,
        //                   width: 20,
        //                   child: CircularProgressIndicator(
        //                     valueColor:
        //                         AlwaysStoppedAnimation(AppColors.blue),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           )
        //         : const SizedBox.shrink(),
        //   ],
        // )
      ),
    );
  }
}