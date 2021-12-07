import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';

import 'package:hint/ui/views/settings/update_email/update_email_viewmodel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:string_validator/string_validator.dart';

class UpdateEmailView extends StatelessWidget {
  const UpdateEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateEmailViewModel>.reactive(
      viewModelBuilder: () => UpdateEmailViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: cwAuthAppBar(context,
              title: 'Update Email', onPressed: () => Navigator.pop(context)),
          // body: Form(
          //     key: model.updateEmailFormKey,
          //     child: Column(
          //       children: [
          //         verticalSpaceMedium,
          //         const Padding(
          //           padding: EdgeInsets.all(32.0),
          //           child: Icon(
          //             FeatherIcons.atSign,
          //             size: 128.0,
          //             color: AppColors.inActiveGray,
          //           ),
          //         ),
          //         const Padding(
          //           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //           child: Text(
          //             'After click on button we send an verfication link on your provided email you must verify it.',
          //             style:
          //                 TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //         verticalSpaceRegular,
          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 16),
          //           child: TextFormField(
          //             textAlign: TextAlign.center,
          //             validator: (value) {
          //               if (value == null || value.isEmpty) {
          //                 return 'Please enter some text';
          //               }
          //             },
          //             controller: model.upadteEmailTech,
          //             decoration: InputDecoration(
          //               hintText: 'enter your email',
          //               hintStyle: Theme.of(context)
          //                   .textTheme
          //                   .caption!
          //                   .copyWith(fontSize: 16),
          //               contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          //               border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(16),
          //                   borderSide: const BorderSide(
          //                       color: AppColors.inActiveGray)),
          //             ),
          //           ),
          //         ),
          //         verticalSpaceLarge,
          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 16),
          //           child: cwAuthProceedButton(
          //             context,
          //             isLoading: model.isBusy,
          //             buttonTitle: 'Update Email',
          //             onTap: () {
          //               if (model.updateEmailFormKey.currentState!.validate()) {
          //                 model
          //                     .updateUserEmail(context, model.upadteEmailTech.text)
          //                     .whenComplete(() => model.upadteEmailTech.clear());
          //               }
          //             },
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          body: ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.userdataHiveBox),
            builder: (context, userDataHiveBox, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: model.updateEmailFormKey,
                  child: ListView(
                    children: [
                      cwEADetailsTile(context, 'Your Current Email'),
                      Text(
                        userDataHiveBox.get(FireUserField.email),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      verticalSpaceRegular,
                      const Divider(),
                      verticalSpaceRegular,
                      cwEADescriptionTitle(context, 'Type Your New Email'),
                      verticalSpaceSmall,
                      cwEATextField(context, model.upadteEmailTech, 'New Email',
                          onChanged: (value) {
                        model.updateDisplayNameEmpty();
                        
                      }, validator: (value) {
                        if (!isEmail(value!)) {
                          return customSnackbars.errorSnackbar(context,
                              title: 'Provide a valid email address');
                        }
                      }),
                      verticalSpaceLarge,
                      cwAuthProceedButton(context,
                          buttonTitle: 'Change Email',
                          isActive: !model.isDisplayNameEmpty,
                          isLoading: model.isBusy, onTap: () {
                        if (model.updateEmailFormKey.currentState!.validate()) {
                          model
                              .updateUserEmail(
                                  context, model.upadteEmailTech.text)
                              .whenComplete(
                                  () => model.upadteEmailTech.clear());
                        }
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
