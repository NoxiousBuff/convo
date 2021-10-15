import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';
import 'package:hint/ui/views/register/username/username_register_viewmodel.dart';

class UsernameRegisterView extends StatelessWidget {
  const UsernameRegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UsernameRegisterViewModel>.reactive(
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
            child: Form(
              key: model.usernameFormKey,
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
                        'What\'s Your Name',
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
                        'Please Use Your Full Name.',
                        style: GoogleFonts.openSans(
                            color: Colors.black54,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                    autofocus: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is mandatory to fill';
                      }
                      if (value.length < 5) {
                        return 'must be at least 5 characters';
                      } else {
                        return null;
                      }
                    },
                    controller: model.usernameTech,
                    onChanged: (value) => model.updateUsernameEmpty(),
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      fillColor: CupertinoColors.extraLightBackgroundGray,
                      filled: true,
                      isDense: true,
                      hintText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: CupertinoColors.lightBackgroundGray,
                        ),
                      ),
                    ),
                  ),
                  verticalSpaceLarge,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: model.usernameEmpty
                          ? Colors.blue.shade700.withOpacity(0.5)
                          : Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CupertinoButton(
                      child:const  Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: model.usernameEmpty
                          ? null
                          : () {
                              if (model.usernameFormKey.currentState!
                                  .validate()) {
                                getLogger('UsernameRegisterView')
                                    .i(model.usernameTech.text);
                                model.updateUserDisplayName(
                                    model.usernameTech.text, onError: () {
                                  getLogger('UsernameRegisterView')
                                      .i('Error Occurred.');
                                  // ignore: todo
                                  //TODO: Define an alert dialog for error or something.
                                }, onComplete: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              const ChatListView()));
                                });
                              }
                            },
                    ),
                  ),
                  verticalSpaceLarge,
                  verticalSpaceLarge,
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => UsernameRegisterViewModel(),
    );
  }
}