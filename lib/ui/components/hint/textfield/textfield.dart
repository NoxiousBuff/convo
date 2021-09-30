import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/services/chat_service.dart';
import 'bottom_button.dart';

class HintTextField extends StatefulWidget {
  final FocusNode focusNode;
  final String? receiverUid;
  final Color? randomColor;
  const HintTextField({
    Key? key,
    required this.focusNode,
    required this.receiverUid,
    required this.randomColor,
  }) : super(key: key);

  @override
  _HintTextFieldState createState() => _HintTextFieldState();
}

class _HintTextFieldState extends State<HintTextField>
    with SingleTickerProviderStateMixin {
  final TextEditingController messageTech = TextEditingController();
  final ChatService chatMethods = ChatService();
  bool isWriting = false;
  final log = getLogger('HintTextField');

  @override
  void initState() {
    super.initState();
  }

  setWritingTo(bool val) {
    setState(
      () {
        isWriting = val;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Divider(height: 0.5),
          // Consumer(
          //   builder: (BuildContext context,
          //       T Function<T>(ProviderBase<Object?, T>) watch,
          //       Widget? child) {
          //     final replyProvider = watch(replyPod);
          //     return ReplyKeyboardMedia(
          //       replyType: replyProvider.replyType,
          //       replyMsg: replyProvider.replyMsg,
          //       replyMsgId: replyProvider.replyMsgId,
          //       isReply: replyProvider.isReply,
          //       replyUid: replyProvider.replyUid,
          //       replyMediaUrl: replyProvider.replyMediaUrl,
          //     );
          //   },
          // ),
          SizedBox(
            height: 40,
            child: CupertinoTextField(
              focusNode: widget.focusNode,
              style: const TextStyle(color: Colors.black),
              controller: messageTech,
              placeholder: 'Text Message',
              placeholderStyle: const TextStyle(color: Colors.black38),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              minLines: 1,
              maxLines: 6,
              onChanged: (val) {
                (val.isNotEmpty && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              suffix: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: !isWriting
                          ? Colors.black38
                          : const Color.fromRGBO(10, 132, 255, 1),
                    ),
                  ),
                  onPressed: !isWriting
                      ? null
                      : () async {
                          await chatMethods.addNewMessage(
                            receiverUid: widget.receiverUid!,
                            type: 'text',
                            messageText: messageTech.text,
                          );
                          messageTech.clear();
                        },
                ),
              ),
              textAlign: TextAlign.start,
              keyboardType: TextInputType.multiline,
              keyboardAppearance: Brightness.light,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          Container(
            color: widget.randomColor!.withAlpha(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Container(
                  height: 40,
                  alignment: Alignment.topCenter,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      BottomButton(
                        context: context,
                        widget: widget,
                        onTap: () {},
                        imageProvider: const AssetImage('imagicons/scribble.png'),
                      ),
                      BottomButton(
                        context: context,
                        widget: widget,
                        onTap: () {},
                        imageProvider:
                            const AssetImage('imagicons/blackEmoji.webp'),
                      ),
                      BottomButton(
                        context: context,
                        widget: widget,
                        onTap: () {},
                        imageProvider: const AssetImage('imagicons/camera.png'),
                      ),
                      BottomButton(
                        context: context,
                        widget: widget,
                        onTap: () {},
                        imageProvider: const AssetImage('imagicons/editor.png'),
                      ),
                      BottomButton(
                        context: context,
                        widget: widget,
                        onTap: () {},
                        imageProvider:
                            const AssetImage('imagicons/documents.png'),
                      ),
                      BottomButton(
                        context: context,
                        widget: widget,
                        onTap: () {},
                        imageProvider: const AssetImage('imagicons/photo.png'),
                      ),
                      BottomButton(
                        context: context,
                        widget: widget,
                        onTap: () {},
                        imageProvider: const AssetImage('imagicons/meme.png'),
                      ),
                      BottomButton(
                        context: context,
                        widget: widget,
                        onTap: () {},
                        imageProvider: const AssetImage('imagicons/memoji.webp'),
                      ),
                      BottomButton(
                        context: context,
                        widget: widget,
                        onTap: () {},
                        imageProvider: const AssetImage('imagicons/pixabay.png'),
                      ),
                      BottomButton(
                        context: context,
                        widget: widget,
                        onTap: () {},
                        imageProvider: const AssetImage('imagicons/panda.webp'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}

