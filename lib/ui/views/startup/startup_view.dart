import 'package:flutter/material.dart';
import 'package:hint/ui/views/auth/register/displayname/displayname_auth_view.dart';
import 'package:hint/ui/views/home/home_view.dart';
import 'package:hint/ui/views/onboarding/onboarding_view.dart';
import 'package:stacked/stacked.dart';

import 'startup_viewmodel.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  static const String id = '/StartUpView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      onModelReady: (model) => model.getCurrentUserDocument(),
      builder: (context, model, child) {
        switch (model.ifCurrentUserExists) {
          case true:
            switch (model.hasCompletedAuthentication) {
              case true:
                {
                  return const HomeView();
                }
              case false:
                {
                  if (model.shouldShowUsernameview) {
                    model.log.d('User has not completed authentication.');
                    return const DisplayNameAuthView();
                  } else {
                    return const HomeView();
                  }
                }
              default:
                {
                  model.log.d('This is from default.');
                  if (model.shouldShowUsernameview) {
                    model.log.d('User has not completed authentication from default.');
                    return const DisplayNameAuthView();
                  } else {
                    return const HomeView();
                  }
                }
            }
          case false:
            {
              return OnBoardingView();
            }
          default:
            {
              return OnBoardingView();
            }
        }
      },
    );
  }
}
