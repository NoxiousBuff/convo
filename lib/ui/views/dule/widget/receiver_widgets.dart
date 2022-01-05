import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/shared/circular_progress.dart';
import 'package:hint/ui/views/dule/dule_viewmodel.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/dule/widget/display_receiver_media.dart';


class AppBarMediaVisibility extends StatelessWidget {
  const AppBarMediaVisibility(this.fireUser, this.stream, {Key? key})
      : super(key: key);

  final FireUser fireUser;
  final Stream<DatabaseEvent> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: stream,
      builder: (context, snapshot) {
        final data = snapshot.data;

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        } else {
          final duleModel = DuleModel.fromJson(data!.snapshot.value);
          String? url = duleModel.url;
          String type = duleModel.urlType;
          switch (duleModel.urlType) {
            case MediaType.image:
              {
                return InkWell(
                  onTap: () => navService.materialPageRoute(context,
                      DisplayFullMedia(mediaType: type, mediaUrl: url!)),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: ExtendedImage.network(
                      url!,
                      enableSlideOutPage: true,
                      loadStateChanged: (state) {
                        state;
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                            {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgress(height: 30, width: 30),
                              );
                            }
                          case LoadState.completed:
                            {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ExtendedRawImage(
                                  image: state.extendedImageInfo!.image,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                          case LoadState.failed:
                            {
                              return Container(
                                height: 30,
                                width: 30,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .mediumBlack,
                                  ),
                                ),
                                child: const Icon(FeatherIcons.info),
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
                );
              }
            case MediaType.video:
              {
                return url != null
                    ? InkWell(
                        onTap: () {
                          navService.materialPageRoute(
                              context,
                              DisplayFullMedia(
                                  mediaType: MediaType.video, mediaUrl: url));
                        },
                        child: SizedBox(
                          width: 40,
                          child: Icon(
                            FeatherIcons.play,
                            color: Theme.of(context).colorScheme.black,
                          ),
                        ))
                    : shrinkBox;
              }
            default:
              {
                return shrinkBox;
              }
          }
        }
      },
    );
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
          Widget switcherChild;
          switch (isInChatRoom) {
            case true:
              model.updateOtherField(duleModel.msgTxt);
              switcherChild = AnimatedSwitcher(
                duration: const Duration(milliseconds: 10),
                child: TextFormField(
                  key: UniqueKey(),
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  readOnly: true,
                  maxLength: 160,
                  cursorHeight: 28,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  buildCounter: (_,
                      {required currentLength, maxLength, required isFocused}) {
                    return const SizedBox.shrink();
                  },
                  controller: model.otherTech,
                  cursorColor: Theme.of(context).colorScheme.blue,
                  textAlign: TextAlign.center,
                  cursorRadius: const Radius.circular(100),
                  onChanged: (value) {
                    model.updatTextFieldWidth();
                    model.updateOtherField(duleModel.msgTxt);
                  },
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.black, fontSize: 24),
                  decoration: InputDecoration(
                    hintText: 'Message Received',
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.mediumBlack,
                        fontSize: 24),
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              );
              break;
            case false:
              {
                switcherChild = Text(
                  'User Not In The ChatRoom',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.mediumBlack,
                      fontSize: 24),
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
