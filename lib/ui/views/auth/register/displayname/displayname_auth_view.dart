import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'displayname_auth_viewmodel.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';

class DisplayNameAuthView extends StatelessWidget {
  const DisplayNameAuthView({
    Key? key,
  }) : super(key: key);

  static const String id = '/DisplayNameAuthView';

  @override
  Widget build(BuildContext context) {
    final log = getLogger('DisplayNameAuthView');
    return ViewModelBuilder<DisplayNameAuthViewModel>.reactive(
      viewModelBuilder: () => DisplayNameAuthViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: cwAuthAppBar(context, title: 'Choose a Display Name', showLeadingIcon: false),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: model.displayNameFormKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
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
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.black),
                  showCursor: true,
                  cursorColor: Theme.of(context).colorScheme.blue,
                  cursorHeight: 28,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700),
                    contentPadding: EdgeInsets.all(0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none, gapPadding: 0.0),
                  ),
                ),
                verticalSpaceLarge,
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
          ),
        ),
      ),
    );
  }
}
