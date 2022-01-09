import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class ExploreWebView extends StatefulWidget {
  const ExploreWebView({
    Key? key,
    required this.pixabayPhotoUrl,
  }) : super(key: key);

  final String pixabayPhotoUrl;

  @override
  State<ExploreWebView> createState() => _ExploreWebViewState();
}

class _ExploreWebViewState extends State<ExploreWebView> {
  late WebViewController controller;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      appBar: CupertinoNavigationBar(
        leading: InkWell(onTap: () => Navigator.pop(context) ,child: const Icon(FeatherIcons.x, size: 20)),
        border: const Border(
                bottom: BorderSide(
              width: 0,
              color: CupertinoColors.inactiveGray,
            )),
        backgroundColor: Theme.of(context).colorScheme.lightGrey,
        middle: Text(widget.pixabayPhotoUrl, style: TextStyle(color: Theme.of(context).colorScheme.mediumBlack, fontWeight: FontWeight.w400,),),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            color: Theme.of(context).colorScheme.blue,
            backgroundColor: Theme.of(context).colorScheme.darkGrey,
          ),
          Expanded(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.pixabayPhotoUrl,
              onWebViewCreated: (controller) {
                this.controller = controller;
              }, 
              onProgress: (progress) {
                setState(() {
                  this.progress = progress/100;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
