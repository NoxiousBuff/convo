import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cwAuthAppBar(context,
          title: 'Policies', onPressed: () => Navigator.pop(context)),
      body: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 150)).then((value) {
          return rootBundle.loadString('assets/privacy_policy.md');
        }),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Markdown(
              data: snapshot.data!,
              physics: const BouncingScrollPhysics(),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}