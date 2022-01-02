import 'package:flutter/material.dart';
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
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/appicon_xhdpi_gradient.png'),
              verticalSpaceRegular,
              Text(
                'Convo',
                style: Theme.of(context).textTheme.headline2,
              ),
              const Spacer(),
              
              CWAuthProceedButton(
                  buttonTitle: 'Create Account',
                  isLoading: false,
                  isActive: true,
                  onTap: () {
                    navService.cupertinoPageRoute(
                        context, const CredentialAuthView());
                  }),
              verticalSpaceSmall,
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  navService.cupertinoPageRoute(
                        context, const LoginAuthView());
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 0,
                  borderRadius: BorderRadius.circular(16),
                  // shadowColor: Theme.of(context).colorScheme.lightGrey.withAlpha(100),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent
                      //color: Theme.of(context).colorScheme.lightGrey,
                    ),
                    child: Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.black,
                      ),
                    ),
                  ),
                ),
              ),
              verticalSpaceLarge,
              bottomPadding(context)
            ],
          ),
        ),
      ),
    );
  }
}
