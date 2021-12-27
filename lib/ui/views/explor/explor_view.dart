import 'explor_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/views/search_view/search_view.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ExplorView extends StatefulWidget {
  const ExplorView({Key? key}) : super(key: key);

  static const String id = '/ExplorVie';

  @override
  State<ExplorView> createState() => _ExplorViewState();
}

class _ExplorViewState extends State<ExplorView> {
  PageController pageController = PageController(viewportFraction: 0.6);

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      child: const Text('data'),
      connectivityBuilder: (context, connectivity, child) {
        bool connected = connectivity != ConnectivityResult.none;
        final model = ExplorViewModel();
        connected ? model.fetchImages() : null;
        return ViewModelBuilder<ExplorViewModel>.reactive(
          viewModelBuilder: () => ExplorViewModel(),
          onModelReady: (model) => connected ? model.fetchImages() : null,
          builder: (context, model, child) {
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
              body: model.fetchedImages.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          connected
                              ? SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    valueColor: AlwaysStoppedAnimation(
                                      Theme.of(context).colorScheme.darkGrey,
                                    ),
                                  ),
                                )
                              : Icon(FeatherIcons.wifiOff,
                                  size: 80,
                                  color: Theme.of(context).colorScheme.mediumBlack),
                          verticalSpaceMedium,
                          Text(
                            connected
                                ? ''
                                : 'Turn on your internet and refresh the page',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.mediumBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : PageView.builder(
                      padEnds: false,
                      controller: pageController,
                      allowImplicitScrolling: true,
                      scrollDirection: Axis.vertical,
                      itemCount: model.fetchedImages.length,
                      scrollBehavior: const CupertinoScrollBehavior(),
                      onPageChanged: (int i) async {
                        if (i == model.fetchedImages.length - 2) {
                          model.log.v('This is the second last index of list');
                          connected ? model.fetchImages() : null;
                        }

                        model.log.v(i);
                      },
                      itemBuilder: (context, index) {
                        var imageUrl = model.fetchedImages[index].webformatURL;
                        var title = model.fetchedImages[index].user;
                        var tags = model.fetchedImages[index].tags;
                        return Container(
                          color: Theme.of(context).colorScheme.scaffoldColor,
                          child: Column(
                            children: [
                              const Divider(height: 0),
                              ListTile(
                                title: Text(
                                  title,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: ExtendedImage.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  loadStateChanged: (state) {
                                    switch (state.extendedImageLoadState) {
                                      case LoadState.failed:
                                        {
                                          return GestureDetector(
                                            onTap: () {
                                              state.reLoadImage();
                                            },
                                            child: Container(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .lightGrey,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        border: Border.all(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .mediumBlack,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                          FeatherIcons
                                                              .rotateCcw),
                                                    ),
                                                    verticalSpaceRegular,
                                                    Text(
                                                      'Tap to reload',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .mediumBlack,
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .lightGrey,
                                            child: Center(
                                              child: SizedBox(
                                                height: 40,
                                                width: 40,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 01,
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .darkGrey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      case LoadState.completed:
                                        {
                                          return ExtendedRawImage(
                                            image:
                                                state.extendedImageInfo?.image,
                                            fit: BoxFit.cover,
                                          );
                                        }
                                      default:
                                        {}
                                    }
                                  },
                                ),
                              ),
                              ListTile(
                                minVerticalPadding: 0,
                                leading: const Icon(FeatherIcons.tag),
                                title: Text(
                                  tags,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .mediumBlack,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              index == model.fetchedImages.length - 1
                                  ? model.isBusy
                                      ? Column(
                                          children: [
                                            verticalSpaceRegular,
                                            SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 01,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .darkGrey,
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
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .mediumBlack,
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
                                  : shrinkBox,
                            ],
                          ),
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }
}
