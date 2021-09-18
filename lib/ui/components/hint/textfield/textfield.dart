import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/components/media/message/reply_message.dart';
import 'package:hint/ui/components/media/reply/reply_keyboard_media.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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

class _HintTextFieldState extends State<HintTextField> {
  final TextEditingController messageTech = TextEditingController();
  final ChatService chatMethods = ChatService();
  bool isWriting = false;
  bool optionOpened = false;
  final logger = Logger();
  double optionHeight() {
    if (optionOpened && MediaQuery.of(context).viewInsets.bottom == 0.0) {
      return 84.0;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  bool optionActive = false;
  double optionCurrentHeight = 250;

  setWritingTo(bool val) {
    setState(
      () {
        isWriting = val;
      },
    );
  }

  Widget bottomButton(double bottomWidth) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                color: Colors.amber,
              );
            });
      },
      child: Container(
        height: 20,
        width: bottomWidth,
        child: const Text(''),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            color: widget.randomColor!.withAlpha(50),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double bottomWidth = (MediaQuery.of(context).size.width - 72.0) / 8;

    return GestureDetector(
      dragStartBehavior: DragStartBehavior.start,
      onVerticalDragUpdate: (dragDetails) {
        int sensitivity = 4;
        if (dragDetails.delta.dy > sensitivity) {
          // Down Swipe
          setState(() {
            optionOpened = false;
          });
        } else if (dragDetails.delta.dy < -sensitivity) {
          // Up Swipe
          setState(() {
            optionOpened = true;
          });
        }
      },
      child: ClipRect(
        child: Container(
          padding: const EdgeInsets.only(
              top: 0.0, bottom: 0.0, left: 4.0, right: 2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Divider(height: 0.0),
              Consumer(
                builder: (BuildContext context,
                    T Function<T>(ProviderBase<Object?, T>) watch,
                    Widget? child) {
                  final replyProvider = watch(replyPod);
                  return ReplyKeyboardMedia(
                    replyType: replyProvider.replyType,
                    replyMsg: replyProvider.replyMsg,
                    replyMsgId: replyProvider.replyMsgId,
                    isReply: replyProvider.isReply,
                    replyUid: replyProvider.replyUid,
                    replyMediaUrl: replyProvider.replyMediaUrl,
                  );
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              //   child: CupertinoTextField(
              //     focusNode: widget.focusNode,
              //     style: TextStyle(color: Colors.black),
              //     controller: messageTech,
              //     placeholder: 'Text Message New',
              //     placeholderStyle: TextStyle(color: Colors.black38),
              //     minLines: 1,
              //     maxLines: 6,
              //     onChanged: (val) {
              //       (val.length > 0 && val.trim() != "")
              //           ? setWritingTo(true)
              //           : setWritingTo(false);
              //     },
              //     textAlign: TextAlign.start,
              //     keyboardType: TextInputType.multiline,
              //     keyboardAppearance: Brightness.light,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20),
              //       border: Border(
              //         top: BorderSide(
              //           color: CupertinoDynamicColor.withBrightness(
              //             color: Color(0x33000000),
              //             darkColor: Color(0x33FFFFFF),
              //           ),
              //           style: BorderStyle.solid,
              //           width: 0.0,
              //         ),
              //         bottom: BorderSide(
              //           color: CupertinoDynamicColor.withBrightness(
              //             color: Color(0x33000000),
              //             darkColor: Color(0x33FFFFFF),
              //           ),
              //           style: BorderStyle.solid,
              //           width: 0.0,
              //         ),
              //         right: BorderSide(
              //           color: CupertinoDynamicColor.withBrightness(
              //             color: Color(0x33000000),
              //             darkColor: Color(0x33FFFFFF),
              //           ),
              //           style: BorderStyle.solid,
              //           width: 0.0,
              //         ),
              //         left: BorderSide(
              //           color: CupertinoDynamicColor.withBrightness(
              //             color: Color(0x33000000),
              //             darkColor: Color(0x33FFFFFF),
              //           ),
              //           style: BorderStyle.solid,
              //           width: 0.0,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 40,
                child: CupertinoTextField(
                  focusNode: widget.focusNode,
                  style: const TextStyle(color: Colors.black),
                  controller: messageTech,
                  placeholder: 'Text Message',
                  placeholderStyle: const TextStyle(color: Colors.black38),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 0.0),
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
                        // onPressed: !isWriting
                        //     ? null
                        //     : () async {
                        //         await chatMethods.addMessage(
                        //           receiverUid: widget.receiverUid!,
                        //           type: 'text',
                        //           messageText: messageTech.text,
                        //           isReply: context.read(replyPod).isReply,
                        //           replyMediaUrl: context.read(replyPod).replyMediaUrl,
                        //           replyMsgId: context.read(replyPod).replyMsgId,
                        //           replyMsg: context.read(replyPod).replyMsg,
                        //           replyType: context.read(replyPod).replyType,
                        //           replyUid: context.read(replyPod).replyUid,
                        //         );
                        //         messageTech.clear();
                        //       },
                      )),
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
                      height: 30,
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return bottomButton(bottomWidth);
                        },
                      ),
                      // child: ListView(
                      //   physics: BouncingScrollPhysics(),
                      //   scrollDirection: Axis.horizontal,
                      //   padding: const EdgeInsets.symmetric(horizontal: 2),
                      //   children: [
                      //     bottomButton(bottomWidth),
                      //     SizedBox(width: 4),
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 4, horizontal: 6),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(100),
                      //         color: widget.randomColor!.withAlpha(50),
                      //       ),
                      //       child: IconButton(
                      //         onPressed: () {},
                      //         icon: Icon(Icons.camera_alt),
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: 0, horizontal: 16),
                      //       ),
                      //     ),
                      //     SizedBox(width: 4),
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 4, horizontal: 6),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(100),
                      //         color: widget.randomColor!.withAlpha(50),
                      //       ),
                      //       child: IconButton(
                      //         onPressed: () {},
                      //         icon: Icon(Icons.photo_album),
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: 0, horizontal: 16),
                      //       ),
                      //     ),
                      //     SizedBox(width: 4),
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 4, horizontal: 6),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(100),
                      //         color: widget.randomColor!.withAlpha(50),
                      //       ),
                      //       child: IconButton(
                      //         onPressed: () {},
                      //         icon: Icon(Icons.attach_file),
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: 0, horizontal: 16),
                      //       ),
                      //     ),
                      //     SizedBox(width: 4),
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 4, horizontal: 6),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(100),
                      //         color: widget.randomColor!.withAlpha(50),
                      //       ),
                      //       child: IconButton(
                      //         onPressed: () {},
                      //         icon: Icon(Icons.audiotrack),
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: 0, horizontal: 16),
                      //       ),
                      //     ),
                      //     SizedBox(width: 4),
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 4, horizontal: 6),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(100),
                      //         color: widget.randomColor!.withAlpha(50),
                      //       ),
                      //       child: IconButton(
                      //         onPressed: () {},
                      //         icon: Icon(Icons.timer),
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: 0, horizontal: 16),
                      //       ),
                      //     ),
                      //     SizedBox(width: 4),
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 4, horizontal: 6),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(100),
                      //         color: widget.randomColor!.withAlpha(50),
                      //       ),
                      //       child: IconButton(
                      //         onPressed: () {},
                      //         icon: Icon(Icons.gif),
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: 0, horizontal: 16),
                      //       ),
                      //     ),
                      //     SizedBox(width: 4),
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 4, horizontal: 6),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(100),
                      //         color: widget.randomColor!.withAlpha(50),
                      //       ),
                      //       child: IconButton(
                      //         onPressed: () {},
                      //         icon: Icon(Icons.location_pin),
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: 0, horizontal: 16),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              GestureDetector(
                onVerticalDragUpdate: (dragDetails) {
                  if (dragDetails.delta.dy > 0) {
                    setState(() {
                      optionCurrentHeight = 600;
                      logger.i(optionCurrentHeight);
                    });
                  }
                  if (dragDetails.delta.dy < 0) {
                    setState(() {
                      optionCurrentHeight = 250;
                      logger.i(optionCurrentHeight);
                    });
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: optionActive ? optionCurrentHeight : 0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// AnimatedContainer(
// curve: Curves.easeOut,
// duration: Duration(milliseconds: 200),
// height: optionHeight(),
// child: ListView(
// shrinkWrap: true,
// physics: BouncingScrollPhysics(),
// scrollDirection: Axis.horizontal,
// children: [
// BottomTextFieldButton(
// context: context,
// optionOpened: optionOpened,
// iconData: Icons.gesture_rounded,
// iconName: 'Kickster',
// onTap: () {}),
// BottomTextFieldButton(
// context: context,
// optionOpened: optionOpened,
// iconData: Icons.camera_alt_outlined,
// iconName: 'Camera',
// onTap: () {}),
// BottomTextFieldButton(
// context: context,
// optionOpened: optionOpened,
// iconData: Icons.gif_outlined,
// iconName: 'Gif',
// onTap: () {}),
// BottomTextFieldButton(
// context: context,
// optionOpened: optionOpened,
// iconData: Icons.insert_drive_file_outlined,
// iconName: 'Document',
// onTap: () {}),
// BottomTextFieldButton(
// context: context,
// optionOpened: optionOpened,
// iconData: Icons.photo_library_outlined,
// iconName: 'Gallery',
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => MediaPickers()));
// }),
// BottomTextFieldButton(
// context: context,
// optionOpened: optionOpened,
// iconData: Icons.headset_outlined,
// iconName: 'Audio',
// onTap: () {}),
// BottomTextFieldButton(
// context: context,
// optionOpened: optionOpened,
// iconData: Icons.location_on_outlined,
// iconName: 'Location',
// onTap: () {}),
// ],
// ),
// ),

//TODO: this is the starting of the cupertino textfield

// CupertinoTextField(
// focusNode: widget.focusNode,
// style: TextStyle(color: Colors.black),
// controller: messageTech,
// placeholder: 'Text Message',
// placeholderStyle: TextStyle(color: Colors.black38),
// padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
// minLines: 1,
// maxLines: 6,
// onChanged: (val) {
// (val.length > 0 && val.trim() != "")
// ? setWritingTo(true)
//     : setWritingTo(false);
// },
// suffix: Padding(
// padding: const EdgeInsets.only(right: 8.0),
// child: CupertinoButton(
// padding: EdgeInsets.zero,
// child: Text(
// 'Send',
// style: TextStyle(
// color: !isWriting
// ? Colors.black38
//     : Color.fromRGBO(10, 132, 255, 1),
// ),
// ),
// onPressed: !isWriting
// ? null
// : () async {
// await chatMethods.addMessage(
// receiverUid: widget.receiverUid!,
// type: 'text',
// messageText: messageTech.text,
// isReply: replyProvider.isReply,
// replyMediaUrl: replyProvider.replyMediaUrl,
// replyMsgId: replyProvider.replyMsgId,
// replyMsg: replyProvider.replyMsg,
// replyType: replyProvider.replyType,
// replyUid: replyProvider.replyUid,
// );
// messageTech.clear();
// },
// )),
// textAlign: TextAlign.start,
// keyboardType: TextInputType.multiline,
// keyboardAppearance: Brightness.light,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(20.0),
// ),
// ),
