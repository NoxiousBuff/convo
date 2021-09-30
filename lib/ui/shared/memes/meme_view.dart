import 'dart:ui';
import 'meme_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class Memes extends StatelessWidget {
  const Memes({
    Key? key,
  }) : super(key: key);

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
                  const Icon(CupertinoIcons.wifi, color: iconColor, size: 40)),
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
      child: Icon(CupertinoIcons.search, color: iconColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = screenHeightPercentage(context, percentage: 0.05);
    const margin = EdgeInsets.symmetric(vertical: 10, horizontal: 20);
    final gifHeight = screenHeightPercentage(context, percentage: 0.4);
    TextEditingController textEditingController = TextEditingController();
    return ViewModelBuilder<MemesViewModel>.reactive(
      viewModelBuilder: () => MemesViewModel(),
      onModelReady: (viewModel) {
        viewModel.fetchedMemes('memes');
        viewModel.adController();
      },
      disposeViewModel: true,
      builder: (_, viewModel, __) {
        return OfflineBuilder(
          connectivityBuilder: (context, connectivity, child) {
            final bool connected = connectivity != ConnectivityResult.none;
            return !connected
                ? connectionDialog(context)
                : viewModel.memes == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: viewModel.memes!.results.length,
                        itemBuilder: (context, i) {
                          final memes = viewModel.memes!.results[i];
                          final memeURL = memes.media!.gif!.url;

                          if (i == 0) {
                            return Container(
                              margin: margin,
                              height: height,
                              child: CupertinoTextField(
                                prefix: prefix(),
                                textAlign: TextAlign.start,
                                placeholder: 'Search Tenor',
                                controller: textEditingController,
                                style: Theme.of(context).textTheme.bodyText2,
                                onChanged: (val) =>
                                    viewModel.fetchedMemes(val + 'memes'),
                                onSubmitted: (val) =>
                                    viewModel.fetchedMemes(val + 'memes'),
                                decoration: BoxDecoration(
                                    border: Border.all(color: iconColor),
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            );
                          } else if (i % 5 == 0) {
                            return adWidget(context);
                          } else {
                            return Consumer(
                              builder: (context, watch, child) {
                                //final value = watch(getValueProvider);
                                return InkWell(
                                  onTap: () async {
                                    // await chatService
                                    //     .addMessage(
                                    //   type: imageType,
                                    //   context: context,
                                    //   urlsList: [memeURL],
                                    //   urlsType: ['image'],
                                    //   receiverUid: receiverUid,
                                    // )
                                    //     .whenComplete(() {
                                    //   final date = DateTime.now();
                                    //   final name = date.microsecondsSinceEpoch;
                                    //   final uid = value.messageUid;
                                    //   getLogger('MemeMessageUid').wtf(uid);
                                    //   getLogger('MemeURL').wtf(memeURL);
                                    //   model
                                    //       .downloadInDevice(
                                    //     hiveKey: uid!,
                                    //     mediaUrl: memeURL!,
                                    //     folderName: 'Convo Animated Gif',
                                    //     fileName: 'VID-$name.mp4',
                                    //     hiveBoxName: HiveHelper.hiveBoxImages,
                                    //   )
                                    //       .catchError((e) {
                                    //     getLogger('MemeView').e(e);
                                    //   });
                                    // });

                                    // value.removeMessageUid();
                                  },
                                  child: Container(
                                    height: gifHeight,
                                    margin: const EdgeInsets.all(8),
                                    child: ExtendedImage(
                                      fit: BoxFit.fill,
                                      enableLoadState: true,
                                      enableMemoryCache: true,
                                      handleLoadingProgress: true,
                                      image: NetworkImage(memeURL!),
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
          },
          child: const Text('Yay'),
        );
      },
    );
  }
}
