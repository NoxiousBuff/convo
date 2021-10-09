import 'package:flutter/cupertino.dart';
import 'package:hint/ui/components/media/chat_bubble/chat_bubble.dart';
import 'package:hint/ui/components/media/chat_bubble/chat_bubble_type.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/models/url_preview_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hint/ui/components/media/url/url_preview_viewmodel.dart';

class URLPreview extends StatelessWidget {
  final bool isMe;
  final String url;
  final bool isRead;
  final String messageUid;
  final String conversationId;
  const URLPreview(
      {Key? key,
      required this.url,
      required this.isMe,
      required this.isRead,
      required this.conversationId,
      required this.messageUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final log = getLogger('URLPreview');
    final maxWidth = screenWidthPercentage(context, percentage: 0.7);
    final maxHeight = screenHeightPercentage(context, percentage: 0.6);

    final discriptionStyle = GoogleFonts.roboto(
      fontSize: 12.0,
      color: black54,
    );

    final titleStyle = GoogleFonts.roboto(
      fontSize: 14.0,
      color: black,
    );

    return OfflineBuilder(
      child: const Text(''),
      connectivityBuilder: (context, connectivity, child) {
        final hiveBox = Hive.box('UrlData[$conversationId]');
        bool connected = connectivity != ConnectivityResult.none;
        return ViewModelBuilder<URLPreviewViewModel>.reactive(
          viewModelBuilder: () => URLPreviewViewModel(),
          onModelReady: (model) async {
            if (!hiveBox.containsKey(messageUid)) {
              log.w('hive not contain this key');
              await model.getURLData(
                url: url,
                connected: connected,
                messageUid: messageUid,
                conversationId: conversationId,
              );
              log.wtf('Data extracted');
            }
          },
          builder: (context, model, child) {
            return ValueListenableBuilder<Box>(
              valueListenable: hiveBox.listenable(),
              builder: (BuildContext context, box, Widget? child) {
                bool containKey = box.containsKey(messageUid);
                if (containKey) {
                  final data = box.get(messageUid).cast<String, dynamic>();
                  final hiveData = URLPreviewModel.fromJson(data);
                  return Container(
                    color: dirtyWhite,
                    constraints: BoxConstraints(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExtendedImage(
                          enableLoadState: true,
                          filterQuality: FilterQuality.high,
                          image: MemoryImage(hiveData.previewImage),
                        ),
                        Container(
                          color: dirtyWhite,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                hiveData.title,
                                maxLines: 3,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: titleStyle,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                hiveData.discription,
                                maxLines: 5,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: discriptionStyle,
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Flexible(
                          child: Container(
                              margin: const EdgeInsets.only(bottom: 8, left: 8),
                              child: Text(hiveData.url,
                                  maxLines: 3,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: activeBlue))),
                        )
                      ],
                    ),
                  );
                } else {
                  return ChatBubble(
                    radius: url.length > 3 ? 18 : 19,
                    bubbleType: isMe
                        ? BubbleType.sendBubble
                        : BubbleType.receiverBubble,
                    bubbleColor: isMe
                        ? isRead
                            ? activeBlue
                            : unreadMsg
                        : CupertinoColors.systemGrey6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                          minWidth: MediaQuery.of(context).size.width * 0.1),
                      child: Text(
                        url,
                        style: GoogleFonts.roboto(
                          fontSize: 14.0,
                          color: isMe ? lightBlue : Colors.black,
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
