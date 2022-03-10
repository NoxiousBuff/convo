import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/convo_image/convo_image.dart';

class ImageMedia extends StatelessWidget {
  final Message message;
  const ImageMedia({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
          maxWidth: MediaQuery.of(context).size.width * 0.6,
          minWidth: MediaQuery.of(context).size.width * 0.1),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.lightGrey,
          borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ConvoImage(
          message: message,
          folderPath: 'Media/Convo Images',
          hiveBoxName: HiveApi.mediaHiveBox,
        ),
      ),
    );
  }
}
