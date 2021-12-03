import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/phone_contacts/phone_contacts_viewmodel.dart';

class PhoneContactView extends StatelessWidget {
  const PhoneContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PhoneContactsViewModel>.reactive(
      onModelReady: (model)=> model.getContacts(),
      viewModelBuilder: () => PhoneContactsViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: cwAuthAppBar(context, title: 'Phone Contacts'),
          body: Column(
            children: [
              verticalSpaceLarge,
              const Icon(
                FeatherIcons.search,
                size: 100,
                color: AppColors.darkGrey,
              ),
              verticalSpaceLarge,
              Text(
                'Find your phone contacts on Dule',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              verticalSpaceRegular,
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  'Continously uploading your contacts helps Dule suggest connections help us for finding your good connection for you and, others and offer a better service.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: AppColors.inActiveGray),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              cwAuthProceedButton(
                context,
                buttonTitle: 'Getting Numbers',
                onTap: ()=> model.gettingNumbers(),
                isLoading: model.isBusy,
              ),
              ValueListenableBuilder<Box>(
                valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                builder: (context, box, child) {
                  bool isTrue =
                      box.get(AppSettingKeys.phoneContact, defaultValue: false);
                  return !isTrue
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: cwAuthProceedButton(
                            context,
                            buttonTitle: 'Turn On',
                            isLoading: model.isBusy,
                            onTap: () {
                              box.put(AppSettingKeys.phoneContact, true);
                            },
                          ),
                        )
                      : TextButton(
                          onPressed: () =>
                              box.put(AppSettingKeys.phoneContact, false),
                          child: Text(
                            'Turn Off',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontSize: 20),
                          ),
                        );
                },
              ),
              bottomPadding(context),
            ],
          ),
        );
      },
    );
  }
}
