import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'meme_viewmodel.dart';
import 'package:uuid/uuid.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/message_string.dart';
import 'package:extended_image/extended_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class Memes extends StatelessWidget {
  final String receiverUid;
  final String conversationId;
  final ChatViewModel chatViewModel;
  const Memes(
      {Key? key, required this.receiverUid, required this.conversationId, required this.chatViewModel})
      : super(key: key);

  Widget adWidget(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: NativeAd(
          height: screenHeightPercentage(context, percentage: 0.4),
          unitId: MobileAds.nativeAdUnitId,
          buildLayout: mediumAdTemplateLayoutBuilder,
          loading: const Text('loading'),
          error: const Text('error'),
          icon: AdImageView(size: 40),
          headline: AdTextView(
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          body: AdTextView(style: const TextStyle(color: black), maxLines: 1),
          media: AdMediaView(
            height: 200,
            width: MATCH_PARENT,
          ),
          // attribution: AdTextView(
          //   width: WRAP_CONTENT,
          //   text: 'AD',
          //   decoration: AdDecoration(
          //     border: BorderSide(
          //         color: Colors.green, width: 2),
          //     borderRadius: AdBorderRadius.all(16.0),
          //   ),
          //   style: TextStyle(color: Colors.green),
          //   padding: EdgeInsets.symmetric(
          //       horizontal: 4.0, vertical: 1.0),
          // ),
          button: AdButtonView(
            height: 0,
            textStyle: const TextStyle(color: systemBackground),
          ),
        ),
      ),
    );
  }

  Widget connectionDialog(BuildContext context) {
    return SizedBox(
      width: screenWidthPercentage(context, percentage: 0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 20),
              child:
                  const Icon(CupertinoIcons.wifi, color: inactiveGray, size: 40)),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              'Internet Connection',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Text(
              'make sure you have an active internet connection',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }

  Widget prefix() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(CupertinoIcons.search, color: inactiveGray),
    );
  }

  @override
  Widget build(BuildContext context) {
    final log = getLogger('MemeView');
    final hiveBox = videoThumbnailsHiveBox(conversationId);
    final height = screenHeightPercentage(context, percentage: 0.05);
    const margin = EdgeInsets.symmetric(vertical: 10, horizontal: 20);
    final gifHeight = screenHeightPercentage(context, percentage: 0.4);
    TextEditingController textEditingController = TextEditingController();
    return OfflineBuilder(
      child: const Text(''),
      connectivityBuilder: (context, connectivity, child) {
        bool connected = connectivity != ConnectivityResult.none;
        return ViewModelBuilder<MemesViewModel>.reactive(
          viewModelBuilder: () => MemesViewModel(),
          onModelReady: (viewModel) async {
            if (connected) {
              await viewModel.fetchedMemes('memes');
              await viewModel.fetchNextSet('memes');
            }
          },
          disposeViewModel: true,
          builder: (_, viewModel, __) {
            return !connected
                ? connectionDialog(context)
                : viewModel.memes == null
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Container(
                            margin: margin,
                            height: height,
                            child: CupertinoTextField(
                              prefix: prefix(),
                              textAlign: TextAlign.start,
                              placeholder: 'Search Tenor',
                              controller: textEditingController,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: black),
                              onSubmitted: (val) =>
                                  viewModel.fetchedMemes(val + 'memes'),
                              decoration: BoxDecoration(
                                  border: Border.all(color: inactiveGray),
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                          Flexible(
                            child: PreloadPageView.builder(
                              preloadPagesCount: 10,
                              itemCount: viewModel.memes!.results.length,
                              itemBuilder: (context, index) {
                                final memes = viewModel.memes!.results[index];
                                final memeURL = memes.media!.gif!.url;
                                if (memeURL != null) {
                                  return GestureDetector(
                                    onTap: () async {
                                      final messageUid = const Uuid().v1();
                                      chatService.addFirestoreMessage(
                                        mediaURL: memeURL,
                                        type: MediaType.meme,
                                        messageUid: messageUid,
                                        receiverUid: receiverUid,
                                        timestamp: Timestamp.now(),
                                        userBlockMe: chatViewModel.userBlockMe
                                      );
                                      Uint8List bytes =
                                          (await NetworkAssetBundle(
                                                      Uri.parse(memeURL))
                                                  .load(memeURL))
                                              .buffer
                                              .asUint8List();
                                      log.wtf('Meme:$bytes');
                                      await hiveBox.put(messageUid, bytes);
                                      
                                    },
                                    child: Container(
                                      height: gifHeight,
                                      margin: const EdgeInsets.all(8),
                                      child: ExtendedImage(
                                        fit: BoxFit.fill,
                                        enableLoadState: true,
                                        enableMemoryCache: true,
                                        handleLoadingProgress: true,
                                        image: NetworkImage(memeURL),
                                        filterQuality: FilterQuality.low,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ],
                      );
          },
        );
      },
    );
  }
}
