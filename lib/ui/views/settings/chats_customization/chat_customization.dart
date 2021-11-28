import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final log = getLogger('Chats');
  final senderBubbleColors = [
    MaterialColorsCode.blue300,
    MaterialColorsCode.green500,
    MaterialColorsCode.orange700,
    MaterialColorsCode.purple500,
    MaterialColorsCode.yellow600,
    MaterialColorsCode.indigo500,
    MaterialColorsCode.teal500,
    MaterialColorsCode.red800,
    MaterialColorsCode.cyan500,
  ];

  final receiverBubbleColors = [
    MaterialColorsCode.lightBlue200,
    MaterialColorsCode.green300,
    MaterialColorsCode.orange400,
    MaterialColorsCode.purple400,
    MaterialColorsCode.yellowA200,
    MaterialColorsCode.indigo400,
    MaterialColorsCode.teal300,
    MaterialColorsCode.red600,
    MaterialColorsCode.cyan200,
  ];

  Future<void> bubbleColor(BuildContext context) {
    const boxName = HiveApi.appSettingsBoxName;
    const sKey = AppSettingKeys.senderBubbleColor;
    const rKey = AppSettingKeys.receiverBubbleColor;
    final borderRadius = BorderRadius.circular(16);
    return showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: screenHeightPercentage(context, percentage: 0.9),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(30),
                height: MediaQuery.of(context).size.height * 0.4,
                child: ValueListenableBuilder<Box>(
                  valueListenable: hiveApi.hiveStream(boxName),
                  builder: (context, box, child) {
                    var senderBubbleColorCode =
                        box.get(sKey, defaultValue: MaterialColorsCode.blue300);
                    var receiverBubbleColorCode = box.get(rKey,
                        defaultValue: MaterialColorsCode.lightBlue200);
                    return Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(receiverBubbleColorCode),
                              borderRadius: borderRadius,
                            ),
                            child: Center(
                              child: Text(
                                'Receiver Bubble',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(senderBubbleColorCode),
                              borderRadius: borderRadius,
                            ),
                            child: Center(
                              child: Text(
                                'Sender Bubble',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                width: screenWidth(context),
                height: MediaQuery.of(context).size.height * 0.4,
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Wrap(
                    children: List.generate(
                      9,
                      (i) => GestureDetector(
                        onTap: () async {
                          const box = HiveApi.appSettingsBoxName;
                          final senderValue = senderBubbleColors[i];
                          final receiverValue = receiverBubbleColors[i];
                          await Hive.box(box)
                              .put(sKey, senderValue)
                              .whenComplete(() => log.wtf('Sender Save'))
                              .catchError((e) {
                            log.e('sender Error:$e');
                          });
                          await Hive.box(box)
                              .put(rKey, receiverValue)
                              .whenComplete(() => log.wtf('Receiver Save'))
                              .catchError((e) {
                            log.e('Receiver Error:$e');
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(senderBubbleColors[i]),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(receiverBubbleColors[i]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Chats',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            margin: const EdgeInsets.fromLTRB(20, 20, 0, 20),
            child: Text(
              'Display',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontSize: 15, color: AppColors.darkGrey),
            ),
          ),
          ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
            builder: (context, box, child) {
              const key = AppSettingKeys.darkTheme;
              const boxName = HiveApi.appSettingsBoxName;
              bool darkTheme = Hive.box(boxName).get(key, defaultValue: false);
              return ListTile(
                title: Text('Theme',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black54)),
                leading: Icon(darkTheme ? FeatherIcons.sun : FeatherIcons.moon),
                subtitle: Text(
                  darkTheme ? 'Light' : 'Dark',
                  style: Theme.of(context).textTheme.caption,
                ),
                trailing: CupertinoSwitch(
                  value: darkTheme,
                  onChanged: (val) {
                    box.put(key, !darkTheme);
                  },
                ),
              );
            },
          ),
          Container(
            alignment: Alignment.bottomLeft,
            margin: const EdgeInsets.fromLTRB(20, 20, 0, 20),
            child: Text(
              'Magic Words',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontSize: 15, color: AppColors.darkGrey),
            ),
          ),
          ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
            builder: (context, box, child) {
              const key = AppSettingKeys.confettiAnimation;
              const boxName = HiveApi.appSettingsBoxName;
              var value =
                  Hive.box(boxName).get(key, defaultValue: 'Celelbrate');
              return ListTile(
                title: Text('Confetti',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black54)),
                leading: const SizedBox(width: 20),
                subtitle: Text(
                  value,
                  style: Theme.of(context).textTheme.caption,
                ),
                trailing: const Icon(FeatherIcons.chevronRight),
              );
            },
          ),
          ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
            builder: (context, box, child) {
              const key = AppSettingKeys.balloonsAnimation;
              const boxName = HiveApi.appSettingsBoxName;
              var value =
                  Hive.box(boxName).get(key, defaultValue: 'Happy Birthday');
              return ListTile(
                title: Text('Balloons',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black54)),
                leading: const SizedBox(width: 20),
                subtitle: Text(
                  value,
                  style: Theme.of(context).textTheme.caption,
                ),
                trailing: const Icon(FeatherIcons.chevronRight),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Magic words are those words which have a power to express your emotion on screen. When you type one of these words on your keyboard then a particular effects will display.',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(FeatherIcons.settings),
            title: Text('Chat Customization',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.black54)),
            subtitle: Text(
              'set your settings for live chat',
              style: Theme.of(context).textTheme.caption,
            ),
            onTap: () => bubbleColor(context),
          ),
        ],
      ),
    );
  }
}