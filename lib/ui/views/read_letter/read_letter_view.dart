import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/letter_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';

import 'read_letter_viewmodel.dart';

class ReadLetterView extends StatelessWidget {
  const ReadLetterView({Key? key, required this.letter}) : super(key: key);

  final LetterModel letter;

  static const String id = '/ReadLetterView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReadLetterViewModel>.reactive(
      viewModelBuilder: () => ReadLetterViewModel(letter),
      builder: (context, model, child) => Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: cwAuthAppBar(
          context,
          title: '',
          onPressed: () => Navigator.pop(context),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Row(
              children: [
                Text(model.isSentByMe ? 'From : ' : 'Sent To : ',
                    style:  TextStyle(
                        color:AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                horizontalSpaceRegular,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                      border: Border.all(color:AppColors.lightBlack),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: letter.photoUrl,
                          height: 28,
                          width: 28,
                          fit: BoxFit.cover,
                        ),
                      ),
                      horizontalSpaceRegular,
                      Text(letter.username,
                          style:  TextStyle(
                              color:AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                ),
              ],
            ),
            verticalSpaceRegular,
            const Divider(height: 0),
            verticalSpaceRegular,
            Container(
              decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    letter.letterText,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                  verticalSpaceMedium,
                  Text(model.formaattedDate),
                ],
              ),
            ),
            verticalSpaceLarge,
          ],
        ),
      ),
    );
  }
}
