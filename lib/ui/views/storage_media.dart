import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

class StorageMedia extends StatefulWidget {
  const StorageMedia({Key? key}) : super(key: key);

  @override
  _StorageMediaState createState() => _StorageMediaState();
}

class _StorageMediaState extends State<StorageMedia> {
  bool firstValue = false;
  bool secondValue = false;
  bool thirdValue = false;
  Widget heading({required BuildContext context, required String title}) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Future<void> optionDailog(
      {required BuildContext context, required String headingText}) {
    final width = screenWidthPercentage(context, percentage: 0.45);
    final height = screenHeightPercentage(context, percentage: 0.31);
    final style = Theme.of(context).textTheme.bodyText1;
    const margin = EdgeInsets.symmetric(vertical: 20, horizontal: 10);
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: shape,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: systemBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                    margin: margin, child: Text(headingText, style: style)),
                const Divider(height: 0),
                RadioListTile(
                  value: 1,
                  toggleable: true,
                  title: Text('Photos',
                      style: Theme.of(context).textTheme.bodyText2),
                  groupValue: firstValue,
                  onChanged: (value) {
                    setState(() {
                      value = firstValue;
                    });
                  },
                ),
                const Divider(height: 0),
                RadioListTile(
                  value: 2,
                  toggleable: true,
                  title: Text('Videos',
                      style: Theme.of(context).textTheme.bodyText2),
                  groupValue: secondValue,
                  onChanged: (value) {
                    setState(() {
                      value = secondValue;
                    });
                  },
                ),
                const Divider(height: 0),
                RadioListTile(
                  value: 3,
                  toggleable: true,
                  title: Text('Documents',
                      style: Theme.of(context).textTheme.bodyText2),
                  groupValue: thirdValue,
                  onChanged: (value) {
                    setState(() {
                      value = thirdValue;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
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
                      'Media',
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
                  heading(context: context, title: 'Media auto-download'),
                  const Divider(height: 0),
                  optionWidget(
                    context: context,
                    text: 'When using mobile data',
                    onTap: () => optionDailog(
                        context: context,
                        headingText: 'When using mobile data'),
                  ),
                  optionWidget(
                    context: context,
                    text: 'When connected on Wi-Fi',
                    onTap: () => optionDailog(
                        context: context,
                        headingText: 'When connected on Wi-Fi'),
                  ),
                  optionWidget(
                    context: context,
                    text: 'When roaming',
                    onTap: () => optionDailog(
                        context: context, headingText: 'When roaming'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget optionWidget({
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
