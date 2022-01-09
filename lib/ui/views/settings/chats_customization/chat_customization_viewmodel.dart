import 'package:hint/app/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChatsCustomizationViewModel extends BaseViewModel {
  final log = getLogger('ChatsCustomizationViewModel');

  final senderBubbleColors = [
    MaterialColorsCode.royalBlueSender,
    MaterialColorsCode.hotPinkSender,
    MaterialColorsCode.forestGreenSender,
    MaterialColorsCode.classicBlueSender,

    MaterialColorsCode.redSender,
    MaterialColorsCode.orangeSender,
    MaterialColorsCode.cyanSender,
    MaterialColorsCode.pinkSender,
    MaterialColorsCode.greenSender,
    MaterialColorsCode.systemblueSender,
    MaterialColorsCode.indigoSender,
    MaterialColorsCode.tealSender,
  ];

  final receiverBubbleColors = [
    MaterialColorsCode.paleYellowReceiver,
    MaterialColorsCode.hotCyanReceiver,
    MaterialColorsCode.butterReceiver,
    MaterialColorsCode.classicPinkReceiver,

    MaterialColorsCode.redReceiver,
    MaterialColorsCode.orangeReceiver,
    MaterialColorsCode.cyanReceiver,
    MaterialColorsCode.pinkReceiver,
    MaterialColorsCode.greenReceiver,
    MaterialColorsCode.systemBlueReceiver,
    MaterialColorsCode.indigoReceiver,
    MaterialColorsCode.tealReceiver,
  ];

}