import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/privacy_dialog.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: "By creating an account, you are agreeing to our\n",
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.mediumBlack,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: "Terms & Conditions ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showModal(
                      context: context,
                      configuration: const FadeScaleTransitionConfiguration(),
                      builder: (context) {
                        return PolicyDialog(
                          mdFileName: 'terms_and_conditions.md',
                        );
                      },
                    );
                  },
              ),
              const TextSpan(text: "and "),
              TextSpan(
                text: "Privacy Policy! ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return PolicyDialog(
                          mdFileName: 'privacy_policy.md',
                        );
                      },
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
