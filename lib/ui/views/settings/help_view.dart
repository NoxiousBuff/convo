import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';

class HelpView extends StatelessWidget {
  const HelpView({Key? key}) : super(key: key);

  Widget optionTile(BuildContext context, String title, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
      ),
      leading: Icon(icon, color: AppColors.darkGrey),
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
              'Help',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          optionTile(context, 'Help Center', CupertinoIcons.question_circle),
          optionTile(context, 'Terms and Conditions', CupertinoIcons.doc),
          optionTile(context, 'Privacy Policy', CupertinoIcons.doc_on_doc),
          optionTile(context, 'App Updated', CupertinoIcons.arrow_up_circle),
          optionTile(context, 'About', CupertinoIcons.info_circle),
        ],
      ),
    );
  }
}