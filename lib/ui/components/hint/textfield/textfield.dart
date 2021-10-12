import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/shared/pixaBay/pixabay.dart';
import 'package:hint/ui/shared/memes/meme_view.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/ui/shared/emojies/emojie_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:hint/ui/shared/text_editor/text_editor.dart';
import 'package:hint/ui/shared/animal_memojie/animal_memojie.dart';
import 'package:hint/ui/shared/drawing_canvas/drawing_canvas.dart';
import 'package:hint/ui/components/media/reply/reply_keyboard.dart';
import 'package:hint/ui/components/media/reply/reply_back_viewmodel.dart';
import 'package:hint/ui/components/hint/textfield/textfield_viewmodel.dart';

class HintTextField extends StatefulWidget {
  final Color randomColor;
  final String receiverUid;
  final FocusNode focusNode;
  final String conversationId;
  final FireUser fireUser;
  final ChatViewModel chatViewModel;
  const HintTextField({
    Key? key,
    required this.fireUser,
    required this.focusNode,
    required this.receiverUid,
    required this.randomColor,
    required this.chatViewModel,
    required this.conversationId,
  }) : super(key: key);

  @override
  _HintTextFieldState createState() => _HintTextFieldState();
}

class _HintTextFieldState extends State<HintTextField> {
  final log = getLogger('TextFieldView');
  final TextEditingController messageTech = TextEditingController();
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

  /// Chat features bottom button widget
  Widget bottomButton(String image,
      {required void Function() onTap, Color? color}) {
    double bottomWidth = (MediaQuery.of(context).size.width - 72.0) / 8;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20,
        width: bottomWidth,
        child: Image.asset(image),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: color ?? widget.randomColor.withAlpha(50),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  /// Return the options for camera
  /// like record a video or taking a picture
  Future<void> cameraOptions(
      {required BuildContext context,
      required void Function() takePicture,
      required void Function() recordVideo}) async {
    Widget option(
        {required void Function() onTap, required String optionText}) {
      return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(optionText, style: Theme.of(context).textTheme.bodyText2),
        ),
      );
    }

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: systemBackground,
              constraints: BoxConstraints(
                maxHeight: screenHeightPercentage(context, percentage: 0.26),
                maxWidth: screenHeightPercentage(context, percentage: 0.3),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 25),
                    child: Text(
                      'I want to',
                      style: Theme.of(context).textTheme.bodyText1!,
                    ),
                  ),
                  const Divider(height: 0),
                  Column(
                    children: [
                      option(
                        optionText: 'Take a picture',
                        onTap: takePicture,
                      ),
                      const Divider(height: 0),
                      option(
                        optionText: 'Record a video',
                        onTap: recordVideo,
                      ),
                      const Divider(height: 0),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: activeBlue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bottomContainer(TextFieldViewModel model) {
    if (model.blackEmojie) {
      return const SizedBox.shrink();
    } else if (model.showAnimalMemohjies) {
      return const SizedBox.shrink();
    } else if (model.showMemes) {
      return const SizedBox.shrink();
    } else if (model.showMemojies) {
      return const SizedBox.shrink();
    } else if (model.showPixaBay) {
      return const SizedBox.shrink();
    } else {
      return AnimatedContainer(
          height: 50,
          color: widget.randomColor.withAlpha(60),
          duration: const Duration(milliseconds: 100));
    }
  }

  Widget textField(TextFieldViewModel model) {
    return SizedBox(
      height: 40,
      child: OfflineBuilder(
          child: const Text(''),
          connectivityBuilder: (context, connectivity, child) {
            bool connected = connectivity != ConnectivityResult.none;
            return CupertinoTextField(
              minLines: 1,
              maxLines: 6,
              controller: messageTech,
              placeholder: 'Text Message',
              focusNode: widget.focusNode,
              style: const TextStyle(color: Colors.black),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              placeholderStyle: const TextStyle(color: Colors.black38),
              onChanged: (val) async {
                (val.isNotEmpty && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              suffix: CupertinoButton(
                padding: const EdgeInsets.only(right: 8.0),
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
                    : model.textFieldMessage(
                        context: context,
                        connected: connected,
                        controller: messageTech,
                        receiverUid: widget.receiverUid,
                        conversationId: widget.conversationId),
              ),
              textAlign: TextAlign.start,
              keyboardType: TextInputType.multiline,
              keyboardAppearance: Brightness.light,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = screenHeightPercentage(context, percentage: 0.5);
    return ViewModelBuilder<TextFieldViewModel>.reactive(
      viewModelBuilder: () => TextFieldViewModel(),
      builder: (context, model, child) {
        return OfflineBuilder(
            child: const Text('Yah Baby!!'),
            connectivityBuilder: (context, connectivity, child) {
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
                    padding: const EdgeInsets.fromLTRB(4, 0, 2, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Divider(height: 0.0),
                        Consumer(
                          builder: (_, watch, __) {
                            final replyPod = watch(replyBackProvider);
                            return replyPod.showReply
                                ? ReplyKeyboard(
                                    isMe: replyPod.isMe,
                                    fireUser: widget.fireUser,
                                    conversationId: widget.conversationId,
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                        textField(model),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 4),
                            Container(
                              height: 30,
                              alignment: Alignment.topCenter,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                children: [
                                  bottomButton(
                                    'assets/scribble.png',
                                    color: black,
                                    onTap: () {
                                      model.memeChanger(false);
                                      model.animalToggle(false);
                                      model.pixaBayToggle(false);
                                      model.emojieChanger(false);
                                      model.toggleMemojies(false);
                                      showCupertinoModalBottomSheet(
                                        elevation: 0,
                                        context: context,
                                        enableDrag: false,
                                        isDismissible: false,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => DrawingCanvas(
                                          receiverUid: widget.receiverUid,
                                          conversationId: widget.conversationId,
                                        ),
                                      );
                                    },
                                  ),
                                  bottomButton(
                                    'assets/blackEmoji.png',
                                    color: extraLightBackgroundGray,
                                    onTap: () {
                                      model.memeChanger(false);
                                      model.animalToggle(false);
                                      model.pixaBayToggle(false);
                                      model.toggleMemojies(false);
                                      switch (model.blackEmojie) {
                                        case true:
                                          {
                                            model.emojieChanger(false);
                                          }
                                          break;
                                        case false:
                                          {
                                            model.emojieChanger(true);
                                          }
                                          break;
                                        default:
                                      }
                                    },
                                  ),
                                  bottomButton(
                                    'assets/camera.png',
                                    color: extraLightBackgroundGray,
                                    onTap: () {
                                      model.memeChanger(false);
                                      model.animalToggle(false);
                                      model.pixaBayToggle(false);
                                      model.emojieChanger(false);
                                      model.toggleMemojies(false);
                                      cameraOptions(
                                        context: context,
                                        takePicture: () async {
                                          Navigator.pop(context);

                                          final file = await model.pickImage();
                                          final timestamp = Timestamp.now();
                                          final messageUid = const Uuid().v1();
                                          if (file != null) {
                                            final fileType =
                                                lookupMimeType(file.path)!
                                                    .split("/")
                                                    .first;
                                            final type = fileType == 'image'
                                                ? imageType
                                                : videoType;
                                            log.wtf(
                                                'cameraOption|MessageType$type');

                                            await chatService
                                                .addFirestoreMessage(
                                              type: fileType,
                                              mediaURL: file.path,
                                              timestamp: timestamp,
                                              messageUid: messageUid,
                                              receiverUid: widget.receiverUid,
                                            );
                                          }
                                        },
                                        recordVideo: () {
                                          model.pickVideo();
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                  bottomButton(
                                    'assets/editor.png',
                                    color: extraLightBackgroundGray,
                                    onTap: () {
                                      model.memeChanger(false);
                                      model.animalToggle(false);
                                      model.pixaBayToggle(false);
                                      model.emojieChanger(false);
                                      model.toggleMemojies(false);
                                      showCupertinoModalBottomSheet(
                                        elevation: 0,
                                        expand: true,
                                        context: context,
                                        enableDrag: false,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 8, sigmaY: 8),
                                              child: const TextEditor());
                                        },
                                      );
                                    },
                                  ),
                                  bottomButton(
                                    'assets/documents.png',
                                    color: black,
                                    onTap: () {
                                      model.memeChanger(false);
                                      model.animalToggle(false);
                                      model.pixaBayToggle(false);
                                      model.emojieChanger(false);
                                      model.toggleMemojies(false);
                                    },
                                  ),
                                  bottomButton(
                                    'assets/photo.png',
                                    color: dirtyWhite,
                                    onTap: () async {
                                      model.memeChanger(false);
                                      model.animalToggle(false);
                                      model.pixaBayToggle(false);
                                      model.emojieChanger(false);
                                      model.toggleMemojies(false);
                                      model.pickMedias(
                                          context: context,
                                          boxId: widget.conversationId,
                                          receiverUid: widget.receiverUid);
                                    },
                                  ),
                                  bottomButton(
                                    'assets/meme.png',
                                    color: dirtyWhite,
                                    onTap: () {
                                      model.emojieChanger(false);
                                      model.animalToggle(false);
                                      model.pixaBayToggle(false);
                                      model.toggleMemojies(false);
                                      switch (model.showMemes) {
                                        case true:
                                          {
                                            model.memeChanger(false);
                                          }

                                          break;
                                        case false:
                                          {
                                            model.memeChanger(true);
                                          }
                                          break;
                                        default:
                                      }
                                    },
                                  ),
                                  bottomButton(
                                    'assets/memoji.webp',
                                    color: black,
                                    onTap: () {
                                      model.memeChanger(false);
                                      model.animalToggle(false);
                                      model.pixaBayToggle(false);
                                      model.emojieChanger(false);
                                      switch (model.showMemojies) {
                                        case true:
                                          {
                                            model.toggleMemojies(false);
                                          }

                                          break;
                                        case false:
                                          {
                                            model.toggleMemojies(true);
                                          }
                                          break;
                                        default:
                                      }
                                    },
                                  ),
                                  bottomButton(
                                    'assets/pixabay.png',
                                    color: dirtyWhite,
                                    onTap: () {
                                      model.memeChanger(false);
                                      model.animalToggle(false);
                                      model.emojieChanger(false);
                                      model.toggleMemojies(false);
                                      switch (model.showPixaBay) {
                                        case true:
                                          {
                                            model.pixaBayToggle(false);
                                          }

                                          break;
                                        case false:
                                          {
                                            model.pixaBayToggle(true);
                                          }
                                          break;
                                        default:
                                      }
                                    },
                                  ),
                                  bottomButton(
                                    'assets/panda.webp',
                                    color: black,
                                    onTap: () {
                                      model.memeChanger(false);
                                      model.pixaBayToggle(false);
                                      model.emojieChanger(false);
                                      model.toggleMemojies(false);
                                      switch (model.showAnimalMemohjies) {
                                        case true:
                                          {
                                            model.animalToggle(false);
                                          }

                                          break;
                                        case false:
                                          {
                                            model.animalToggle(true);
                                          }
                                          break;
                                        default:
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            AnimatedContainer(
                              child: EmojiesView(),
                              width: double.infinity,
                              height: model.blackEmojie ? height : 0.0,
                              duration: const Duration(milliseconds: 100),
                            ),
                            AnimatedContainer(
                              child: Memes(
                                receiverUid: widget.receiverUid,
                                conversationId: widget.conversationId,
                              ),
                              height: model.showMemes ? height : 0.0,
                              duration: const Duration(milliseconds: 100),
                            ),
                            AnimatedContainer(
                              height: model.showPixaBay ? height : 0.0,
                              duration: const Duration(milliseconds: 100),
                              child: PixaBay(
                                  receiverUid: widget.receiverUid,
                                  conversationId: widget.conversationId),
                            ),
                            AnimatedContainer(
                              height: model.showAnimalMemohjies ? height : 0.0,
                              child: AnimalMemoji(),
                              duration: const Duration(milliseconds: 100),
                            ),
                            //  bottomContainer(model),
                          ],
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
            });
      },
    );
  }
}
