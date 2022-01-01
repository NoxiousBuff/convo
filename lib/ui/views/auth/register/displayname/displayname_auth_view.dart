import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

import 'displayname_auth_viewmodel.dart';

class DisplayNameAuthView extends StatelessWidget {
  const DisplayNameAuthView(
      {Key? key, required this.countryCode, required this.phoneNumber})
      : super(key: key);
  final String countryCode;
  final String phoneNumber;

  static const String id = '/DisplayNameAuthView';

  @override
  Widget build(BuildContext context) {
    final log = getLogger('DisplayNameAuthView');
    return ViewModelBuilder<DisplayNameAuthViewModel>.reactive(
      viewModelBuilder: () => DisplayNameAuthViewModel(countryCode, phoneNumber),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: cwAuthAppBar(context, title: 'Choose a Display Name'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: model.displayNameFormKey,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpaceRegular,
                    cwAuthHeadingTitle(context, title: 'What\'s your \nname '),
                    verticalSpaceSmall,
                    cwAuthDescription(context,
                        title:
                            'Choose a display name - That\'s what your friends will see.'),
                    verticalSpaceRegular,
                    TextFormField(
                      controller: model.displayNameTech,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return customSnackbars.errorSnackbar(context,
                              title: 'Display name cannot be empty.');
                        } else if (value.length < 3) {
                          return customSnackbars.errorSnackbar(context,
                              title: 'Display name cannot be that short.');
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {
                        log.wtf('on field submitted');
                      },
                      onChanged: (value) => model.updateDisplayNameEmpty(),
                      textCapitalization: TextCapitalization.none,
                      autofocus: true,
                      autofillHints: const [AutofillHints.name],
                      style:  TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.black),
                      showCursor: true,
                      cursorColor: Theme.of(context).colorScheme.blue,
                      cursorHeight: 32,
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700),
                        contentPadding: EdgeInsets.all(0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none, gapPadding: 0.0),
                      ),
                    ),
                    bottomPadding(context),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CWAuthProceedButton(
                      
                        buttonTitle: 'Done',
                        isLoading: model.isBusy,
                        isActive: !model.isDisplayNameEmpty,
                        onTap: () async {
                          final validate =
                              model.displayNameFormKey.currentState!.validate();
                          if (validate) {
                            model.updateDisplayName(context);
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
