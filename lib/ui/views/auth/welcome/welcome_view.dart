import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/auth/login/login_auth_view.dart';
import 'package:hint/ui/views/auth/register/credential/credential_auth_view.dart';
import 'package:stacked/stacked.dart';

import 'welcome_viewmodel.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  static const String id = '/WelcomeView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WelcomeViewModel>.reactive(
      viewModelBuilder: () => WelcomeViewModel(),
      builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          body: Column(
            children: [
              const Spacer(),
              CWAuthProceedButton(
                  buttonTitle: 'Get Started',
                  isLoading: false,
                  isActive: true, onTap: () {
                navService.cupertinoPageRoute(
                    context, const CredentialAuthView());
              }),
              verticalSpaceSmall,
              CWAuthProceedButton(
                  buttonTitle: 'Log In',
                  isLoading: false,
                  isActive: true, onTap: () {
                navService.cupertinoPageRoute(context, const LoginAuthView());
              }),
              verticalSpaceLarge,
              // CWAuthProceedButton(context,
              //     buttonTitle: 'Skip',
              //     isLoading: false,
              //     isActive: true, onTap: () {
              //   navService.cupertinoPageRoute(context, const HomeView());
              // }),
              // verticalSpaceLarge,
              bottomPadding(context,)
            ],
          ),
        ),
      ),
    );
  }
}
