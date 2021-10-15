import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'avatar_register_viewmodel.dart';

class AvatarRegisterView extends StatelessWidget {
  const AvatarRegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AvatarRegisterViewModel>.reactive(
      viewModelBuilder: () => AvatarRegisterViewModel(),
      builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: systemBackground,
          // ignore: todo
          //TODO: Apply for dark theme
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: systemBackground,
          body: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                const Icon(
                  CupertinoIcons.at,
                  size: 70.0,
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choose an avatar, then',
                      style: GoogleFonts.openSans(
                          color: CupertinoColors.black,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Select an avatar of your liking.',
                      style: GoogleFonts.openSans(
                          color: Colors.black54,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: true,
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Image.asset('avatars/default${index.toString()}.png'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
