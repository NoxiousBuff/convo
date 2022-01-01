import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
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
      onModelReady: (model) => model.getContacts(),
      viewModelBuilder: () => PhoneContactsViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          appBar: cwAuthAppBar(context,
              title: 'Phone Contacts', onPressed: () => Navigator.pop(context)),
          body: Stack(
            children: [
              ValueListenableBuilder<Box>(
                  valueListenable:
                      hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                  builder: (context, box, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Icon(
                          FeatherIcons.search,
                          size: 100,
                          color: Theme.of(context).colorScheme.darkGrey,
                        ),
                        verticalSpaceLarge,
                        CWEAHeading(
                          'Find your contacts\non Dule',
                          mainAxisSize: MainAxisSize.min,
                          textAlign: TextAlign.center,
                          color: Theme.of(context).colorScheme.mediumBlack,
                        ),
                        // Text(
                        //   'Find your phone contacts on Dule',
                        //   textAlign: TextAlign.center,
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .headline4!
                        //       .copyWith(fontWeight: FontWeight.w700),
                        // ),
                        verticalSpaceRegular,
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child:  Text(
                            'Continously uploading your contacts helps Dule suggest connections help us for finding your good connection for you and, others and offer a better service.',
                            style: TextStyle(
                              color:Theme.of(context).colorScheme.mediumBlack,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }),
              Align(
                alignment: Alignment.bottomCenter,
                child: ValueListenableBuilder<Box>(
                  valueListenable:
                      hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                  builder: (context, box, child) {
                    const key = AppSettingKeys.phoneContact;
                    bool isTrue = box.get(key, defaultValue: false);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        !isTrue
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: CWAuthProceedButton(
                               
                                  buttonTitle: 'Turn On',
                                  onTap: () {
                                    box.put(AppSettingKeys.phoneContact, true);
                                  },
                                ),
                              )
                            : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                  onTap: () =>
                                      box.put(AppSettingKeys.phoneContact, false),
                                  child: Container(
                                    height: 48,
                                    width: screenWidth(context),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Turn Off',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).colorScheme.mediumBlack
                                              .withAlpha(125)),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.lightGrey,
                                        borderRadius: BorderRadius.circular(16)),
                                  ),
                                ),
                            ),
                        verticalSpaceLarge,
                        bottomPadding(context),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
