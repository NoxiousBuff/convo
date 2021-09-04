import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;

class PreviewLink extends StatefulWidget {
  const PreviewLink({Key? key}) : super(key: key);

  @override
  _PreviewLinkState createState() => _PreviewLinkState();
}

class _PreviewLinkState extends State<PreviewLink> {
  Map<String, PreviewData> urlData = {};

  List<String> get urls => const [
        'https://flyer.chat',
        'github.com/flyerhq',
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.dark,
        title: const Text('Example'),
      ),
      body: ListView.builder(
        itemCount: urls.length,
        itemBuilder: (context, index) => Container(
          key: ValueKey(urls[index]),
          margin: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: Color(0xfff7f7f8),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            child: LinkPreview(
              enableAnimation: true,
              onPreviewDataFetched: (data) {
                setState(() {
                  urlData = {
                    ...urlData,
                    urls[index]: data,
                  };
                });
              },
              previewData: urlData[urls[index]],
              text: urls[index],
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }
}
