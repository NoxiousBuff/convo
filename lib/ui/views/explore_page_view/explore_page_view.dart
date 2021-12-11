import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
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
          backgroundColor: AppColors.black,
          appBar: cwAuthAppBar(context,
              title: 'Explore', onPressed: () => Navigator.pop(context)),
          body: PreloadPageView.builder(
            preloadPagesCount: 4,
            controller: controller,
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          title!,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl!,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(FeatherIcons.tag, size: 30),
                          ),
                          Flexible(
                            child: Text(
                              tags!,
                              maxLines: 3,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceRegular,
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
