import 'package:hint/api/firestore.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/views/distant_view/distant_view.dart';
import 'encryption.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'profile_viewmodel.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  static const String id = '/ProfileView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => ValueListenableBuilder<Box>(
          valueListenable: hiveApi.hiveStream(HiveApi.userdataHiveBox),
          builder: (context, box, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () async {
                      final fireUser = await firestoreApi
                          .getUserFromFirebase(AuthService.liveUser!.uid);
                      navService.cupertinoPageRoute(
                          context, DistantView(currentFireUser: fireUser!));
                    },
                    icon: const Icon(FeatherIcons.settings),
                    color: Colors.black,
                    iconSize: 24,
                  ),
                  IconButton(
                    onPressed: () => navService.cupertinoPageRoute(
                        context, const EncryptionView()),
                    icon: const Icon(FeatherIcons.shield),
                    color: Colors.black,
                    iconSize: 24,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(FeatherIcons.edit),
                    color: Colors.black,
                    iconSize: 24,
                  ),
                  horizontalSpaceSmall
                ],
                elevation: 0.0,
                toolbarHeight: 60,
                systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.dark),
                title: Text(
                  box.get(FireUserField.username),
                  style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 32),
                ),
                backgroundColor:
                    MaterialStateColor.resolveWith((Set<MaterialState> states) {
                  return states.contains(MaterialState.scrolledUnder)
                      ? Colors.grey.shade50
                      : Colors.white;
                }),
                leadingWidth: 0,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    verticalSpaceRegular,
                    Row(
                      children: [
                        horizontalSpaceRegular,
                        ClipOval(
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: Image.network(
                              box.get(FireUserField.photoUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceRegular,
                    Row(
                      children: [
                        horizontalSpaceRegular,
                        Text(
                          box.get(FireUserField.displayName),
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                    verticalSpaceRegular,
                    Row(
                      children: [
                        horizontalSpaceRegular,
                        Text(
                          box.get(FireUserField.bio),
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
