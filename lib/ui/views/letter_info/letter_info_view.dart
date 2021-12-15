import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';

class LetterInfoView extends StatelessWidget {
  const LetterInfoView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'writingLetterHeroTag',
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: cwAuthAppBar(context, title: '', onPressed: ()=> Navigator.pop(context)),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            cwEAHeading('Why letters !!')
          ],
        ),
      ),
    );
  }
}