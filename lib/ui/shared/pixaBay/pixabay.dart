import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'pixabay_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class PixaBay extends StatelessWidget {
  const PixaBay({Key? key}) : super(key: key);

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
          // buildLayout: fullBuilder,
          loading: const Text('loading'),
          error: const Text('error'),
          icon: AdImageView(size: 40),
          headline: AdTextView(
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 1,
          ),
          body: AdTextView(
              style: const TextStyle(color: Colors.black), maxLines: 1),
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
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget imageDetails(int? downloads, BuildContext context, int? likes) {
    return Column(
      children: [
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: (const Icon(
                CupertinoIcons.down_arrow,
                color: systemBackground,
                size: 20,
              )),
            ),
            Text(
              downloads.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: systemBackground),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.heart_fill,
                color: systemRed,
                size: 20,
              ),
            ),
            Text(
              likes.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: systemBackground),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const margin = EdgeInsets.fromLTRB(8, 0, 8, 8);
    final height = screenHeightPercentage(context, percentage: 0.4);
    TextEditingController textEditingcontroller = TextEditingController();

    return ViewModelBuilder<PixaBayViewModel>.reactive(
      viewModelBuilder: () => PixaBayViewModel(),
      onModelReady: (viewModel) {},
      disposeViewModel: true,
      builder: (_, viewModel, __) {
        return OfflineBuilder(
          child: const Text("Yah !!"),
          connectivityBuilder: (context, connectivity, child) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (connected) {
              viewModel.imagesCategory();
              // viewModel.adController();
            }
            return !connected
                ? connectionDialog(context)
                : viewModel.images == null
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: screenWidth(context),
                        height: screenHeight(context),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemCount: viewModel.images!.hits!.length,
                          itemBuilder: (context, i) {
                            final hits = viewModel.images!.hits![i];
                            // String? downloadUrl = hits.getDownloadLink();
                            String? imageURL = hits.getThumbnailLink();
                            int? downloads = hits.downloads;
                            int? likes = hits.likes;
                            if (i == 0) {
                              return Container(
                                height: 40,
                                margin: margin,
                                child: CupertinoTextField(
                                  controller: textEditingcontroller,
                                  textAlign: TextAlign.start,
                                  placeholder: 'Search Images',
                                  style: Theme.of(context).textTheme.bodyText2,
                                  prefix: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(CupertinoIcons.search,
                                        color: iconColor),
                                  ),
                                  onChanged: (val) => viewModel.getImages(val),
                                  onSubmitted: (val) =>
                                      viewModel.getImages(val),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: iconColor),
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              );
                              // } else if (i % 5 == 0) {
                              //   return adWidget(context);
                            } else {
                              return imageURL == null
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Consumer(
                                      builder: (context, watch, child) {
                                        // final value = watch(getValueProvider);
                                        //const hiveBaxName = HiveHelper.hiveBoxImages;
                                        return InkWell(
                                          onTap: () async {
                                            // await chatService
                                            //     .addMessage(
                                            //   type: imageType,
                                            //   context: context,
                                            //   urlsType: ['image'],
                                            //   urlsList: [downloadUrl],
                                            //   receiverUid: receiverUid,
                                            // )
                                            //     .whenComplete(() {
                                            //   final date = DateTime.now();
                                            //   final name =
                                            //       date.microsecondsSinceEpoch;
                                            //   final uid = value.messageUid;
                                            //   getLogger('PixaBayMessageUid')
                                            //       .wtf(uid);
                                            //   getLogger('PixaBayURL')
                                            //       .wtf(downloadUrl);
                                            //   model
                                            //       .downloadInDevice(
                                            //     hiveKey: uid!,
                                            //     mediaUrl: downloadUrl!,
                                            //     hiveBoxName: hiveBaxName,
                                            //     folderName: 'Convo Images',
                                            //     fileName: 'IMG-$name.jpeg',
                                            //   )
                                            //       .catchError((e) {
                                            //     getLogger('PixaBayView').e(e);
                                            //   });
                                            // });
                                            // value.removeMessageUid();
                                          },
                                          child: Container(
                                            height: height,
                                            margin: margin,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image:
                                                    CachedNetworkImageProvider(
                                                        imageURL),
                                              ),
                                            ),
                                            child: imageDetails(
                                              downloads,
                                              context,
                                              likes,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                            }
                          },
                        ),
                      );
          },
        );
      },
    );
  }
}

AdLayoutBuilder get fullBuilder => (ratingBar, media, icon, headline,
        advertiser, body, price, store, attribuition, button) {
      return AdLinearLayout(
        padding: const EdgeInsets.all(10),
        // The first linear layout width needs to be extended to the
        // parents height, otherwise the children won't fit good
        width: MATCH_PARENT,
        // decoration: AdDecoration(
        //   gradient: AdLinearGradient(
        //     colors: [Colors.indigo[300]!, Colors.indigo[700]!],
        //     orientation: AdGradientOrientation.tl_br,
        //   ),
        // ),
        children: [
          media,
          AdLinearLayout(
            children: [
              icon,
              AdLinearLayout(children: [
                headline,
                AdLinearLayout(
                  children: [attribuition, advertiser, ratingBar],
                  orientation: HORIZONTAL,
                  width: MATCH_PARENT,
                ),
              ], margin: const EdgeInsets.only(left: 4)),
            ],
            gravity: LayoutGravity.center_horizontal,
            width: WRAP_CONTENT,
            orientation: HORIZONTAL,
            margin: const EdgeInsets.only(top: 6),
          ),
          AdLinearLayout(
            children: [button],
            orientation: HORIZONTAL,
          ),
        ],
      );
    };

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
