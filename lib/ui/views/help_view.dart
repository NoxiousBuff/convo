
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  Widget heading({required BuildContext context, required String title}) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: extraLightBackgroundGray,
      body: SizedBox(
        width: screenWidth(context),
        height: screenHeight(context),
        child: Column(
          children: [
            SizedBox(
              height: screenHeightPercentage(context, percentage: 0.2),
              child: CustomScrollView(
                slivers: [
                  CupertinoSliverNavigationBar(
                    border: Border.all(color: Colors.transparent),
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        CupertinoIcons.back,
                        color: activeBlue,
                      ),
                    ),
                    largeTitle: Text(
                      'Help',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: systemBackground,
              child: Column(
                children: [
                  heading(context: context, title: 'App Information'),
                  const Divider(height: 0),
                  widget(
                    context: context,
                    text: 'Updates',
                    onTap: () {},
                  ),
                  widget(
                    context: context,
                    text: 'Privacy & Policy',
                    onTap: () {},
                  ),
                  widget(
                    context: context,
                    text: 'Upcoming Features',
                    onTap: () {},
                  ),
                  widget(
                    context: context,
                    text: 'Terms and conditions',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widget({
    required BuildContext context,
    required String text,
    required Function onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap as void Function()?,
          child: ListTile(
            title: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black26,
              size: 14.0,
            ),
          ),
        ),
        const Divider(height: 0.0),
      ],
    );
  }
}
