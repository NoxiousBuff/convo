import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

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
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        middle: Row(
          children: [
            Text(
              'Verify Security Code',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          verticalSpaceLarge,
          Container(
            height: screenHeightPercentage(context,percentage: 0.4),
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
