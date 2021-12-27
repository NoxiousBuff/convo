import 'package:flutter/material.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cwAuthAppBar(context,
          title: 'Terms And Conditions',
          onPressed: () => Navigator.pop(context)),
      body: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 150)).then((value) {
          return rootBundle.loadString('assets/terms_and_conditions.md');
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