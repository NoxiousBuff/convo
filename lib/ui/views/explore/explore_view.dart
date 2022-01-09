import 'explore_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/models/pixabay_image_model.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/views/search_view/search_view.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/explore/widgets/explore_web_view.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({Key? key}) : super(key: key);

  static const String id = '/ExplorVie';

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView>
    with AutomaticKeepAliveClientMixin {
  PageController pageController = PageController(viewportFraction: 0.6);

  Widget emptyUI() {
    return PageView.builder(
      itemCount: 2,
      padEnds: false,
      controller: pageController,
      allowImplicitScrolling: true,
      scrollDirection: Axis.vertical,
      scrollBehavior: const CupertinoScrollBehavior(),
      itemBuilder: (context, index) {
        return Container(
          color: Theme.of(context).colorScheme.scaffoldColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 0),
              verticalSpaceSmall,
              Container(
                height: 20,
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: !Theme.of(context).colorScheme.isDarkTheme
                        ? Theme.of(context).colorScheme.lightGrey
                        : Theme.of(context).colorScheme.lightGrey.withAlpha(80),
                    borderRadius: BorderRadius.circular(16)),
              ),
              verticalSpaceSmall,
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.lightGrey,
                ),
              ),
              verticalSpaceSmall,
              Container(
                height: 20,
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: !Theme.of(context).colorScheme.isDarkTheme
                        ? Theme.of(context).colorScheme.lightGrey
                        : Theme.of(context).colorScheme.lightGrey.withAlpha(80),
                    borderRadius: BorderRadius.circular(16)),
              ),
              verticalSpaceSmall,
            ],
          ),
        );
      },
    );
  }

  Widget offlineWidget(bool connected) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FeatherIcons.wifiOff,
              size: 80, color: Theme.of(context).colorScheme.mediumBlack),
          verticalSpaceMedium,
          Text(
            'You are offline !!\nTurn on your internet and refresh the page',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).colorScheme.mediumBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget builderImage(BuildContext context, String imageUrl) {
    return Expanded(
      child: ExtendedImage.network(
        imageUrl,
        fit: BoxFit.cover,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.failed:
              {
                return GestureDetector(
                  onTap: () => state.reLoadImage(),
                  child: Container(
                    color: Theme.of(context).colorScheme.lightGrey,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.mediumBlack,
                              ),
                            ),
                            child: const Icon(FeatherIcons.rotateCcw),
                          ),
                          verticalSpaceRegular,
                          Text(
                            'Tap to reload',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.mediumBlack,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            case LoadState.loading:
              {
                return Container(
                  color: Theme.of(context).colorScheme.lightGrey,
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 01,
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.darkGrey,
                        ),
                      ),
                    ),
                  ),
                );
              }
            case LoadState.completed:
              {
                return ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  fit: BoxFit.cover,
                );
              }
            default:
              {}
          }
        },
      ),
    );
  }

  Widget loadingWidget(ExploreViewModel model, int index) {
    return index == model.fetchedImages.length - 1
        ? model.isBusy
            ? Column(
                children: [
                  verticalSpaceRegular,
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.darkGrey,
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                ],
              )
            : InkWell(
                onTap: () => model.fetchImages(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    verticalSpaceRegular,
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.mediumBlack,
                        ),
                      ),
                      child: const Icon(
                        FeatherIcons.plus,
                        size: 28,
                      ),
                    ),
                    verticalSpaceMedium,
                  ],
                ),
              )
        : shrinkBox;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var color = Theme.of(context).colorScheme;
    return OfflineBuilder(
      child: const Text('data'),
      connectivityBuilder: (context, connectivity, child) {
        bool connected = connectivity != ConnectivityResult.none;

        return ViewModelBuilder<ExploreViewModel>.reactive(
          viewModelBuilder: () => ExploreViewModel(),
          onModelReady: (model) => connected ? model.fetchImages() : null,
          builder: (context, model, child) {
            final fetchedList =
                ValueNotifier<List<PixabayImageModel>>(model.fetchedImages);
            fetchedList.value.isEmpty && connected
                ? model.initialFetch()
                : null;
            return Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
                leadingWidth: 0,
                title: InkWell(
                  onTap: () =>
                      navService.materialPageRoute(context, const SearchView()),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    width: screenWidth(context),
                    child: Text(
                      'Search for someone',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.mediumBlack,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.lightGrey,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.grey,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    color: Theme.of(context).colorScheme.black,
                    onPressed: () => model.fetchImages(),
                    icon: const Icon(FeatherIcons.refreshCcw),
                  )
                ],
              ),
              body: ValueListenableBuilder(
                valueListenable: fetchedList,
                builder: (context, value, child) {
                  bool isEmpty = fetchedList.value.isEmpty;
                  switch (isEmpty) {
                    case true:
                      {
                        return connected ? emptyUI() : offlineWidget(connected);
                      }

                    case false:
                      {
                        return PageView.builder(
                          padEnds: false,
                          controller: pageController,
                          allowImplicitScrolling: true,
                          scrollDirection: Axis.vertical,
                          itemCount: model.fetchedImages.length,
                          scrollBehavior: const CupertinoScrollBehavior(),
                          onPageChanged: (int i) async {
                            if (i == model.fetchedImages.length - 2) {
                              const v = 'This is the second last index of list';
                              model.log.v(v);
                              if (connected) {
                                final list = await model.fetchImages();
                                if (list.isEmpty) {
                                  final list1 = await model.fetchImages();
                                  if (list1.isEmpty) {
                                    final list2 = await model.fetchImages();
                                    if (list2.isEmpty) model.fetchImages();
                                  }
                                }
                              }
                            }

                            model.log.v(i);
                          },
                          itemBuilder: (context, index) {
                            var url = model.fetchedImages[index].webformatURL;
                            var title = model.fetchedImages[index].user;
                            var tags = model.fetchedImages[index].tags;
                            return Container(
                              color: color.scaffoldColor,
                              child: Column(
                                children: [
                                  if (index == 0)
                                    GestureDetector(
                                      onTap: () => navService.materialPageRoute(
                                          context,
                                          const ExploreWebView(
                                              pixabayPhotoUrl:
                                                  'https://pixabay.com')),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          children: [
                                            Text(
                                              'From Pixabay ♥',
                                              
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .mediumBlack,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (index == 0) verticalSpaceSmall,
                                  const Divider(height: 0),
                                  ListTile(
                                    
                                    title: Text(
                                      title,
                                      style: TextStyle(
                                          color: color.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  builderImage(context, url),
                                  ListTile(
                                    minVerticalPadding: 0,
                                    leading: const Icon(FeatherIcons.tag),
                                    title: Text(
                                      tags,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: color.mediumBlack,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  loadingWidget(model, index)
                                ],
                              ),
                            );
                          },
                        );
                      }
                    default:
                      {
                        return shrinkBox;
                      }
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
