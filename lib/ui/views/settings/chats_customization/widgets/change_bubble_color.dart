import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/settings/chats_customization/chat_customization_viewmodel.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChangebubbleColor extends StatelessWidget {
  const ChangebubbleColor({Key? key, required this.model}) : super(key: key);

  final ChatsCustomizationViewModel model;

  static const boxName = HiveApi.appSettingsBoxName;
  static const sKey = AppSettingKeys.senderBubbleColor;
  static const rKey = AppSettingKeys.receiverBubbleColor;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(32);
    return SizedBox(
      height: screenHeightPercentage(context, percentage: 0.9),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            margin: const EdgeInsets.all(30),
            height: MediaQuery.of(context).size.height * 0.4,
            child: ValueListenableBuilder<Box>(
              valueListenable: hiveApi.hiveStream(boxName),
              builder: (context, box, child) {
                var senderBubbleColorCode =
                    box.get(sKey, defaultValue: MaterialColorsCode.systemblueSender);
                var receiverBubbleColorCode = box.get(rKey,
                    defaultValue: MaterialColorsCode.systemBlueReceiver);
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(receiverBubbleColorCode),
                          borderRadius: borderRadius,
                        ),
                        child: const Center(
                          child: Text(
                            'Friend\'s Bubble',
                            style: TextStyle(
                      color: Colors.black, fontSize: 24),
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
                        child: const Center(
                          child: Text(
                            'Your Bubble',
                            style: TextStyle(
                      color: Colors.white, fontSize: 24,),
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
                  model.senderBubbleColors.length,
                  (i) => GestureDetector(
                    onTap: () async {
                      const box = HiveApi.appSettingsBoxName;
                      final senderValue = model.senderBubbleColors[i];
                      final receiverValue = model.receiverBubbleColors[i];
                      await Hive.box(box)
                          .put(sKey, senderValue)
                          .whenComplete(() => model.log.wtf('Sender Save'))
                          .catchError((e) {
                        model.log.e('sender Error:$e');
                      });
                      await Hive.box(box)
                          .put(rKey, receiverValue)
                          .whenComplete(() => model.log.wtf('Receiver Save'))
                          .catchError((e) {
                        model.log.e('Receiver Error:$e');
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
                              color: Color(model.senderBubbleColors[i]),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(model.receiverBubbleColors[i]),
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
          verticalSpaceMedium,
        ],
      ),
    );
  }
}
