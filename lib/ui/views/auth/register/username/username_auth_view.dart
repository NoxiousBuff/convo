import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/constants/enums.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/custom_chips.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

import 'username_auth_viewmodel.dart';

class UserNameAuthView extends StatelessWidget {
  const UserNameAuthView(
      {Key? key,
      })
      : super(key: key);
      
  static const String id = '/UserNameAuthView';

  @override
  Widget build(BuildContext context) {
    final log = getLogger('UserNameAuthView');
    return ViewModelBuilder<UserNameAuthViewModel>.reactive(
      viewModelBuilder: () => UserNameAuthViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: cwAuthAppBar(context, title: 'Find a username',onPressed: ()=> Navigator.pop(context)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: model.userNameFormKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
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
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.black),
                  showCursor: true,
                  cursorColor: Theme.of(context).colorScheme.white,
                  cursorHeight: 28,
                  decoration: const InputDecoration(
                    hintText: '@username',
                    hintStyle: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700),
                    contentPadding: EdgeInsets.all(0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none, gapPadding: 0.0),
                  ),
                ),
                verticalSpaceRegular,
                Row(
                  children: [
                    Builder(
                      builder: (context) {
                        Widget child;
                        switch (model.doesExists) {
                          case UserNameExists.tooShort:
                            child = model.userNameTech.text.length < 4
                                ? customChips.errorChip(context, 'Username too short.')
                                : const Text('');
                            break;
                          case UserNameExists.yes:
                            child = model.userNameTech.text.length > 3
                                ? customChips.successChip(context, 'Username available')
                                : const Text('');
                            break;
                          case UserNameExists.no:
                            child = model.userNameTech.text.length > 3
                                ? customChips
                                    .errorChip(context, 'Username already in use')
                                : const Text('');
                            break;
                          case UserNameExists.checking:
                            child = model.userNameTech.text.length > 3
                                ? customChips.progressChip(context)
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
                  ],
                ),
                verticalSpaceLarge,
                CWAuthProceedButton(
             
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
                          model.updateUserDisplayName(context);
                          model.setBusy(false);
                        }
                      }
                    },
                  ),
                  verticalSpaceLarge,
                  bottomPadding(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
