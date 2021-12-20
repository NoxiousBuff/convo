import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/enums.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/custom_chips.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/auth/pick_interest/pick_interest_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

import 'username_auth_viewmodel.dart';

class UserNameAuthView extends StatelessWidget {
  const UserNameAuthView(
      {Key? key,
      required this.countryCode,
      required this.displayName,
      required this.phoneNumber})
      : super(key: key);

  final String countryCode;
  final String phoneNumber;
  final String displayName;

  static const String id = '/UserNameAuthView';

  @override
  Widget build(BuildContext context) {
    final log = getLogger('UserNameAuthView');
    return ViewModelBuilder<UserNameAuthViewModel>.reactive(
      viewModelBuilder: () => UserNameAuthViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: cwAuthAppBar(context, title: 'Find a username'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: model.userNameFormKey,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpaceRegular,
                    cwAuthHeadingTitle(context, title: 'Pick your \nusername '),
                    verticalSpaceSmall,
                    cwAuthDescription(context,
                        title:
                            'Find a catchy and unique username so\nyour friends can find you easily.'),
                    verticalSpaceRegular,
                    TextFormField(
                      controller: model.userNameTech,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return customSnackbars.errorSnackbar(context,
                              title: 'Username cannot be empty.');
                        } else if (value.length < 3) {
                          return customSnackbars.errorSnackbar(context,
                              title: 'Username cannot be that short.');
                        } else {
                          return null;
                        }
                      },
                      focusNode: model.focusNode,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {
                        log.wtf('on field submitted');
                      },
                      onChanged: (value) {
                        model.updateUserNameEmpty();
                        model.findUsernameExistOrNot(value);
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'[a-z0-9_\.]'),
                            allow: true, replacementString: ''),
                      ],
                      textCapitalization: TextCapitalization.none,
                      autofocus: true,
                      autofillHints: const [AutofillHints.nickname],
                      style:  TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black),
                      showCursor: true,
                      cursorColor: AppColors.white,
                      cursorHeight: 32,
                      decoration: const InputDecoration(
                        hintText: '@username',
                        hintStyle: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700),
                        contentPadding: EdgeInsets.all(0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none, gapPadding: 0.0),
                      ),
                    ),
                    verticalSpaceRegular,
                    Builder(
                      builder: (context) {
                        Widget child;
                        switch (model.doesExists) {
                          case UserNameExists.tooShort:
                            child = model.userNameTech.text.length < 4
                                ? customChips.errorChip('Username too short.')
                                : const Text('');
                            break;
                          case UserNameExists.yes:
                            child = model.userNameTech.text.length > 3
                                ? customChips.successChip('Username exists')
                                : const Text('');
                            break;
                          case UserNameExists.no:
                            child = model.userNameTech.text.length > 3
                                ? customChips
                                    .errorChip('Username does not exists')
                                : const Text('');
                            break;
                          case UserNameExists.checking:
                            child = model.userNameTech.text.length > 3
                                ? customChips.progressChip()
                                : const Text('');
                            break;
                          default:
                            {
                              child = const Text('');
                            }
                        }
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: child,
                        );
                      },
                    ),
                    bottomPadding(context),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      cwAuthProceedButton(
                        context,
                        buttonTitle: 'Got it',
                        isLoading: model.isBusy,
                        isActive: !model.isUserNameEmpty &&
                            model.doesExists == UserNameExists.yes,
                        onTap: () async {
                          final validate =
                              model.userNameFormKey.currentState!.validate();
                          if (validate) {
                            if (model.userNameTech.text.length > 3 &&
                                model.doesExists == UserNameExists.yes) {
                              model.setBusy(true);
                              model.focusNode.unfocus();
                              navService.cupertinoPageRoute(
                                context,
                                PickInterestsView(
                                  phoneNumber: phoneNumber,
                                  countryCode: countryCode,
                                  displayName: displayName,
                                  username: model.userNameTech.text,
                                ),
                              );
                              model.setBusy(false);
                            }
                          }
                        },
                      ),
                      verticalSpaceLarge,
                      bottomPadding(context),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
