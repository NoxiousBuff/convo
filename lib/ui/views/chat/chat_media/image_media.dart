import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/ui/shared/convo_image.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

class ImageMedia extends StatelessWidget {
  final String imageURL;
  final String messageUid;
  const ImageMedia({
    Key? key,
    required this.imageURL,
    required this.messageUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
          minWidth: MediaQuery.of(context).size.width * 0.1),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.lightGrey,
          borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ConvoImage(
          mediaUrl: imageURL,
          folderPath: 'Convo/Media',
          messageUid: messageUid,
          hiveBoxName: HiveApi.imagesMediaHiveBox,
        ),
      ),
    );
  }
}
