import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EncryptionView extends StatefulWidget {
  const EncryptionView({Key? key}) : super(key: key);

  @override
  _EncryptionViewState createState() => _EncryptionViewState();
}

class _EncryptionViewState extends State<EncryptionView> {
  final log = getLogger('EncryptionView');
  List<int> intergersList =
      List.generate(16, (index) => Random().nextInt(900000) + 100000);

  @override
  void initState() {
    log.wtf(intergersList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cwAuthAppBar(context, title: 'Verify', actions: [
        IconButton(
          onPressed: () {
            showCupertinoModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    color: Colors.green,
                    height: 400,
                  );
                });
          },
          icon: const Icon(FeatherIcons.airplay),
        ),
      ]),
      body: Column(
        children: [
          verticalSpaceLarge,
          Container(
            height: screenHeightPercentage(context, percentage: 0.4),
            width: screenWidth(context),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              children: List.generate(
                intergersList.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    intergersList[index].toString(),
                  ),
                ),
              ),
            ),
            // Wrap(
            //   c
            //   children: List.generate(
            //     intergersList.length,
            //     (index) => Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8),
            //       child: Text(
            //         intergersList[index].toString(),
            //       ),
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
