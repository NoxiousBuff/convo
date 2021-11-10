import 'dart:math';
import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/api/appwrite_api.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/models/live_chatroom.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/message_string.dart';
import 'package:extended_image/extended_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hint/constants/appwrite_constants.dart';
import 'package:string_validator/string_validator.dart';
import 'package:hint/models/appwrite_list_documents.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hint/ui/views/live_chat/live_chat_viewmodel.dart';

class LiveChat extends StatefulWidget {
  final FireUser fireUser;
  final GetDocumentsList liverUserDocs;
  final GetDocumentsList receiverUserDocs;
  const LiveChat({
    Key? key,
    required this.fireUser,
    required this.liverUserDocs,
    required this.receiverUserDocs,
  }) : super(key: key);

  @override
  State<LiveChat> createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> with TickerProviderStateMixin {
  int textLength = 0;
  double radius = 0.0;
  bool lightOn = true;
  double x = 100, y = 100;
  late LiveChatUser _liveUser;
  late LiveChatUser _receiverUser;
  final log = getLogger('LiveChat');
  late RealtimeSubscription subscription;
  late ConfettiController confettiController;
  late AnimationController spotlightController;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    getReceiverUser();
    getLiveUser();
    final receiverUser = _receiverUser;
    setState(() {
      subscription = AppWriteApi.instance
          .subscribe(['documents.${receiverUser.documentID}']);
    });
    confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    spotlightController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    spotlightController.addListener(() => setState(() {}));
    confettiController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    confettiController.dispose();
    spotlightController.removeListener(() {});
    spotlightController.dispose();
    super.dispose();
  }

  LiveChatUser getLiveUser() {
    final document = widget.liverUserDocs.documents.first;
    final doc = document.cast<String, dynamic>();
    final user = LiveChatUser.fromJson(doc);

    setState(() {
      _liveUser = user;
    });
    return _liveUser;
  }

  Future getReceiverUser() async {
    final document = widget.receiverUserDocs.documents.first;
    final doc = document.cast<String, dynamic>();
    final receiverUser = LiveChatUser.fromJson(doc);

    setState(() {
      _receiverUser = receiverUser;
    });
  }

  Widget receiverMessage() {
    return StreamBuilder<RealtimeMessage>(
      stream: subscription.stream,
      builder: (context, AsyncSnapshot<RealtimeMessage> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;

          if (data != null) {
            final liveChatUser = LiveChatUser.fromJson(data.payload);
            String? mediaType = liveChatUser.mediaType;

            if (isURL(liveChatUser.userMessage) && mediaType == imageType) {
              return ExtendedImage.network(liveChatUser.userMessage);
            } else {
              return Text(
                liveChatUser.userMessage,
                maxLines: liveChatUser.userMessage.length > 100 ? 6 : 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              );
            }
          } else {
            return const Text('Data is null now');
          }
        } else {
          return const Text('Let\'s Chat');
        }
      },
    );
  }

  StreamSubscription<RealtimeMessage> animationHandler() {
    return subscription.stream.listen(
      (data) {
        final receiverUser = LiveChatUser.fromJson(data.payload);
        switch (receiverUser.animationType) {
          case AnimationType.confetti:
            {
              log.w('confetti controller :1');
              confettiController.play();
            }

            break;
          case AnimationType.spotlight:
            {
              log.w('spotlight controller :2');
              spotlightController.forward();
            }
            break;
          default:
            {
              log.wtf('User Message is not equal to any animation value');
            }
        }
      },
      onError: (e) {
        log.e('AppwriteSubscription:$e');
      },
    );
  }

  @override
  void didUpdateWidget(covariant LiveChat oldWidget) {
    setState(() {
      lightOn = true;
      x = screenWidthPercentage(context, percentage: 0.785);
      y = screenWidthPercentage(context, percentage: 0.710);
    });
    controller.addListener(() {
      setState(() {
        textLength = (150 - controller.text.length).toInt();
      });
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    String fireUserId = widget.fireUser.id;
    String? mediaURL = _receiverUser.mediaURL;
    String liveUserId = FirestoreApi.liveUserUid;
    const valueColor = AlwaysStoppedAnimation(activeGreen);
    String collectionId = AppWriteConstants.liveChatscollectionID;
    var style = Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 30);
    animationHandler();
    return ViewModelBuilder<LiveChatViewModel>.reactive(
      viewModelBuilder: () => LiveChatViewModel(),
      onModelReady: (model) async {
        var liveChatId = chatService.getConversationId(fireUserId, liveUserId);
        await model.updateMessage(
            documentId: _liveUser.documentID,
            collectionId: _liveUser.collectionID,
            data: {
              LiveChatField.liveChatRoom: liveChatId,
            });
      },
      onDispose: (model) async {
        subscription.close;
        await model.updateMessage(
            documentId: _liveUser.documentID,
            collectionId: _liveUser.collectionID,
            data: {
              LiveChatField.userMessage: 'Hint Message',
              LiveChatField.liveChatRoom: null,
            });
      },
      builder: (context, model, child) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            automaticallyImplyLeading: true,
            title: Text(
              widget.fireUser.username,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Center(
                  child: CircleAvatar(
                    maxRadius: 20,
                    backgroundImage:
                        CachedNetworkImageProvider(widget.fireUser.photoUrl!),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Flexible(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            constraints: const BoxConstraints(minHeight: 30),
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            decoration: BoxDecoration(
                                color: CupertinoColors.extraLightBackgroundGray,
                                borderRadius: BorderRadius.circular(16)),
                            child: Center(
                              child: StreamBuilder<DocumentSnapshot>(
                                stream: model.statusStream(fireUserId),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) const Text('');
                                  if (snapshot.hasData) {
                                    String status = snapshot.data!['status'];
                                    bool isOnline =
                                        snapshot.data!['status'] == 'Online';

                                    return isOnline
                                        ? Text(status, style: style)
                                        : receiverMessage();
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20, top: 6),
                            child: CircleAvatar(
                              backgroundColor: activeGreen,
                              maxRadius: mediaURL != null ? 10 : 0,
                            ),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: screenWidth(context),
                        constraints: const BoxConstraints(minHeight: 30),
                        decoration: BoxDecoration(
                            color: activeBlue,
                            borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                        child: Center(
                          child: CupertinoTextField(
                            maxLength: 150,
                            autofocus: true,
                            showCursor: false,
                            textAlign: TextAlign.center,
                            maxLines: controller.text.length > 100 ? 6 : 2,
                            cursorColor: systemBackground,
                            style: const TextStyle(
                              fontSize: 20,
                              height: 1.5,
                              color: systemBackground,
                            ),
                            controller: controller,
                            onChanged: (val) {
                              final liveChatId = chatService.getConversationId(
                                  fireUserId, liveUserId);
                              model.updateMessage(
                                documentId: _liveUser.documentID,
                                collectionId: _liveUser.collectionID,
                                data: {
                                  LiveChatField.mediaURL: null,
                                  LiveChatField.mediaType: null,
                                  LiveChatField.userMessage: val,
                                  LiveChatField.userUid: liveUserId,
                                  LiveChatField.animationType: null,
                                  LiveChatField.liveChatRoom: liveChatId,
                                },
                              );
                            },
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    verticalSpaceTiny,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              KeyboardVisibilityBuilder(
                                  builder: (context, child, visible) {
                                return IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    CupertinoIcons.keyboard,
                                    color: visible ? activeBlue : inactiveGray,
                                  ),
                                );
                              }),
                              IconButton(
                                onPressed: () {
                                  model.cameraOptions(
                                    context: context,
                                    takePicture: () async {
                                      await model.pickImage(context);
                                    },
                                    recordVideo: () async {
                                      await model.pickVideo(context);
                                    },
                                  );
                                },
                                icon: const Icon(CupertinoIcons.camera),
                              ),
                              model.isBusy
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: model.state == TaskState.running
                                          ? CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: valueColor,
                                              backgroundColor: activeBlue,
                                              value: model.uploadingProgress,
                                            )
                                          : const CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: valueColor,
                                              backgroundColor: activeBlue,
                                            ),
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        await model.pickFromGallery(
                                            context, _liveUser.documentID);
                                      },
                                      icon: const Icon(CupertinoIcons.photo),
                                    ),
                              IconButton(
                                onPressed: () async {
                                  var animation = await model.getAnimationValue(
                                      context: context,
                                      fireUser: widget.fireUser,
                                      liverUserDocs: widget.liverUserDocs,
                                      receiverDocs: widget.receiverUserDocs);
                                  String confetti = AnimationType.confetti;
                                  String spotlight = AnimationType.spotlight;
                                  if (animation == confetti) {
                                    await model.updateMessage(
                                      documentId: _liveUser.documentID,
                                      collectionId: collectionId,
                                      data: {
                                        LiveChatField.animationType: confetti,
                                      },
                                    );
                                    confettiController.play();
                                    await model.updateMessage(
                                      documentId: _liveUser.documentID,
                                      collectionId: collectionId,
                                      data: {
                                        LiveChatField.animationType: null,
                                      },
                                    );
                                  } else if (animation == spotlight) {
                                    await model.updateMessage(
                                      documentId: _liveUser.documentID,
                                      collectionId: collectionId,
                                      data: {
                                        LiveChatField.animationType: spotlight,
                                      },
                                    );
                                    await spotlightController
                                        .forward()
                                        .whenComplete(() {
                                      model.updateMessage(
                                        documentId: _liveUser.documentID,
                                        collectionId: collectionId,
                                        data: {
                                          LiveChatField.animationType: null,
                                        },
                                      );
                                    });
                                  }
                                },
                                icon: const Icon(CupertinoIcons.wand_stars),
                              ),
                              const Spacer(),
                              Text(textLength.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          color: inactiveGray, fontSize: 18)),
                              IconButton(
                                onPressed: () {
                                  controller.clear();
                                },
                                icon: const Icon(Icons.restart_alt_rounded),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              spotlightController.status == AnimationStatus.forward
                  ? ClipPath(
                      clipper: LightClipper(x, y, radius: radius),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: model
                                .spotLightRadius(spotlightController)
                                .value,
                            center: const Alignment(0, -0.4),
                            colors: [
                              transparent,
                              black.withOpacity(0.9),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              Positioned(
                top: -200,
                left: 200,
                child: ConfettiWidget(
                  gravity: 1.0,
                  shouldLoop: false,
                  minBlastForce: 10,
                  maxBlastForce: 20,
                  particleDrag: 0.05,
                  displayTarget: true,
                  numberOfParticles: 1,
                  blastDirection: pi / 2,
                  emissionFrequency: 0.6,
                  minimumSize: const Size(20, 20),
                  maximumSize: const Size(30, 30),
                  confettiController: confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget? child;
  final Widget Function(
    BuildContext context,
    Widget? child,
    bool isKeyboardVisible,
  ) builder;

  const KeyboardVisibilityBuilder({
    Key? key,
    this.child,
    required this.builder,
  }) : super(key: key);

  @override
  _KeyboardVisibilityBuilderState createState() =>
      _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible =
      WidgetsBinding.instance!.window.viewInsets.bottom > 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        widget.child,
        _isKeyboardVisible,
      );
}

class LightClipper extends CustomClipper<Path> {
  final double x, y;
  final double radius;
  LightClipper(this.x, this.y, {this.radius = 50.0});

  @override
  Path getClip(Size size) {
    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));
    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    return Path.combine(PathOperation.reverseDifference, circlePath, fullPath);
  }

  @override
  bool shouldReclip(LightClipper oldClipper) =>
      x != oldClipper.x || y != oldClipper.y;
}
