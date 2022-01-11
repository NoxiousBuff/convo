import 'package:flutter/material.dart';
import 'package:hint/ui/views/auth/register/credential/credential_auth_view.dart';
import 'package:hint/ui/views/welcome/welcome_view.dart';

Map<String, Widget Function(BuildContext)> appRoutes = <String, WidgetBuilder>{
  CredentialAuthView.id : (context) => const CredentialAuthView(),
  WelcomeView.id: (context) => const WelcomeView(),
};