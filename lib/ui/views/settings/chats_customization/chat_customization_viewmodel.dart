import 'package:hint/app/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChatsCustomizationViewModel extends BaseViewModel {
  final log = getLogger('ChatsCustomizationViewModel');

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

}