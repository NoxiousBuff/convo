import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:pixabay_picker/pixabay_picker.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:pixabay_picker/model/pixabay_media.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'explore_page_viewmodel.dart';

class ExplorePageview extends StatefulWidget {
  final PixabayMedia pixaBayMedia;
  const ExplorePageview({Key? key, required this.pixaBayMedia})
      : super(key: key);

  @override
  _ExplorePageviewState createState() => _ExplorePageviewState();
}

class _ExplorePageviewState extends State<ExplorePageview>
    with AutomaticKeepAliveClientMixin {
  BoxFit imageFit = BoxFit.fitHeight;
  final log = getLogger('ExplorePageView');
  PreloadPageController controller = PreloadPageController();
  PageController pageController = PageController(viewportFraction: 0.6);
  PixabayPicker picker = PixabayPicker(apiKey: pixaBayApiKey);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<ExplorePageViewViewModel>.reactive(
      viewModelBuilder: () => ExplorePageViewViewModel(),
      onModelReady: (model) {
        model.addToList(widget.pixaBayMedia);
        model.fetchImages();
      },
      builder: (context, model, child) {
        return Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: AppColors.scaffoldColor,
          appBar: cwAuthAppBar(context,
              title: 'Explore', onPressed: () => Navigator.pop(context)),
          body: PageView.builder(
            scrollBehavior: const CupertinoScrollBehavior(),
            padEnds: false,
            allowImplicitScrolling: true,
            controller: pageController,
            scrollDirection: Axis.vertical,
            itemCount: model.imagesList.length,
            onPageChanged: (int i) {
              if (i == model.imagesList.length) model.fetchImages();
            },
            itemBuilder: (context, index) {
              var imageUrl = model.imagesList[index].getThumbnailLink();
              var title = model.imagesList[index].user;
              var tags = model.imagesList[index].tags;
              return Container(
                color: AppColors.white,
                child: Column(
                  children: [
                    const Divider(height: 0),
                    ListTile(
                      title: Text(
                        title!,
                        style:  TextStyle(
                            color:AppColors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(FeatherIcons.tag),
                      title: Text(
                        tags!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color:AppColors.mediumBlack, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
