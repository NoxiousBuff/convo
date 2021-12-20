import 'package:extended_image/extended_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/dule/dule_viewmodel.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:hint/ui/views/dule/widget/display_receiver_media.dart';
import 'package:hint/ui/views/dule/widget/video_display_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

Widget receiverMediaWidget(
  BuildContext context,
  DuleModel duleModel,
  DuleViewModel model,
  FireUser fireUser,
) {
  switch (duleModel.urlType) {
    case MediaType.image:
      {
        const hash = 'L2I}t;RP00_N?vbHR5ni00xu^k8_';
        var width = (MediaQuery.of(context).size.width * 0.9).toInt();
        var height = (MediaQuery.of(context).size.height * 0.3).toInt();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Dismissible(
            onDismissed: (dissmissDirection) async {
              final fireUserId = fireUser.id;
              const urlKey = DatabaseMessageField.url;
              const typeKey = DatabaseMessageField.urlType;
              await model.updateFireUserDataWithKey(fireUserId, urlKey, '');
              await model.updateFireUserDataWithKey(fireUserId, typeKey, '');
            },
            key: UniqueKey(),
            child: InkWell(
              onTap: () => navService.materialPageRoute(
                  context,
                  DisplayFullMedia(
                      mediaType: duleModel.urlType, mediaUrl: duleModel.url!)),
              child: ExtendedImage.network(
                duleModel.url!,
                fit: BoxFit.cover,
                enableSlideOutPage: true,
                heroBuilderForSlidingPage: (widget) => Text('hero builder'),
                loadStateChanged: (state) {
                  state;
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image(
                            image: BlurHashImage(hash,
                                decodingHeight: height, decodingWidth: width),
                          ),
                        );
                      }
                    case LoadState.completed:
                      {
                        return ExtendedRawImage(
                          image: state.extendedImageInfo?.image,
                        );
                      }

                    default:
                      {
                        return const Text('Error');
                      }
                  }
                },
              ),
            ),
          ),
        );
      }
    case MediaType.video:
      {
        return Dismissible(
          onDismissed: (dissmissDirection) async {
            final fireUserId = fireUser.id;
            const urlKey = DatabaseMessageField.url;
            const typeKey = DatabaseMessageField.urlType;
            await model.updateFireUserDataWithKey(fireUserId, urlKey, '');
            await model.updateFireUserDataWithKey(fireUserId, typeKey, '');
          },
          key: UniqueKey(),
          child: InkWell(
            onTap: () => navService.materialPageRoute(
                context,
                DisplayFullMedia(
                    mediaType: duleModel.urlType, mediaUrl: duleModel.url!)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: VideoDisplayWidget(
                videoUrl: duleModel.url!,
                isPlayable: false,
              ),
            ),
          ),
        );
      }
    default:
      {
        return const Text('Incoming Media...');
      }
  }
}

Widget receiverMessageBubble(
  BuildContext context, {
  required DatabaseEvent? data,
  required FireUser fireUser,
  required DuleViewModel model,
}) {
  const int blue300 = MaterialColorsCode.blue300;
  const String hiveBox = HiveApi.appSettingsBoxName;
  const String rKey = AppSettingKeys.receiverBubbleColor;
  int rColorCode = Hive.box(hiveBox).get(rKey, defaultValue: blue300);
  return StreamBuilder<DatabaseEvent>(
    stream: model.stream,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        model.log.wtf(snapshot.error);
        return const Text('There is an error');
      }
      if (!snapshot.hasData) {
        return Expanded(
          child: AnimatedContainer(
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width * 80,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: BoxDecoration(
                color: Color(rColorCode),
                borderRadius: BorderRadius.circular(32)),
            child: const AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Text(''),
            ),
          ),
        );
      } else {
        final data = snapshot.data;

        if (data != null) {
          final json = data.snapshot.value;
          final DuleModel duleModel = DuleModel.fromJson(json);
          bool isInChatRoom = model.conversationId == duleModel.roomUid;
          var mediaUrl = duleModel.url;
          bool isMediaUrlNotNull = mediaUrl != null && mediaUrl.isNotEmpty;
          Widget switcherChild;
          switch (isInChatRoom) {
            case true:
              model.updateOtherField(duleModel.msgTxt);
              switcherChild = AnimatedSwitcher(
                duration: const Duration(milliseconds: 10),
                child: isMediaUrlNotNull
                    ? receiverMediaWidget(context, duleModel, model, fireUser)
                    : TextFormField(
                        key: UniqueKey(),
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        readOnly: true,
                        maxLength: 160,
                        cursorHeight: 28,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        buildCounter: (_,
                            {required currentLength,
                            maxLength,
                            required isFocused}) {
                          return const SizedBox.shrink();
                        },
                        controller: model.otherTech,
                        cursorColor: AppColors.blue,
                        textAlign: TextAlign.center,
                        cursorRadius: const Radius.circular(100),
                        onChanged: (value) {
                          model.updatTextFieldWidth();
                          model.updateOtherField(duleModel.msgTxt);
                        },
                        style: TextStyle(color: AppColors.black, fontSize: 24),
                        decoration: const InputDecoration(
                          hintText: 'Message Received',
                          hintStyle: TextStyle(
                              color: AppColors.mediumBlack, fontSize: 24),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                // : Text(duleModel.msgTxt),
              );
              break;
            case false:
              {
                switcherChild = const Text(
                  'User Not In The ChatRoom',
                  style: TextStyle(color: AppColors.mediumBlack, fontSize: 24),
                );
              }
              break;
            default:
              {
                switcherChild = const Text('This is default');
              }
          }
          return Expanded(
            flex: model.otherFlexFactor,
            child: AnimatedContainer(
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 200),
              width: MediaQuery.of(context).size.width * 80,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                  color: Color(rColorCode),
                  borderRadius: BorderRadius.circular(32)),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: switcherChild,
              ),
            ),
          );
        } else {
          return const Text('Data is null now');
        }
      }
    },
  );
}