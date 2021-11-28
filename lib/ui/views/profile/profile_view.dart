import 'package:hint/api/firestore.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/views/distant_view/distant_view.dart';

import 'encryption.dart';
import 'profile_viewmodel.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  static const String id = '/ProfileView';

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
 
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
                  onPressed: () async{
                   final fireUser = await firestoreApi.getUserFromFirebase(AuthService.liveUser!.uid);
                   navService.cupertinoPageRoute(context, DistantView(currentFireUser: fireUser!));

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
                box.get(AuthService.liveUser!.uid)[FireUserField.username],
                style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 32),
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
                            'https://images.unsplash.com/photo-1596698749858-7a2ce0a09220?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=376&q=80',
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
                        box.get(AuthService.liveUser!.uid)[FireUserField.username],
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
                      box.get(AuthService.liveUser!.uid)[FireUserField.bio],
                        style: const TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                  verticalSpaceRegular,
                  // Wrap(
                  //   children: List.generate(
                  //     box.get(AuthService.liveUser!.uid)[FireUserField.interests].,
                  //     (index) {
                  //       List<dynamic> list = hiveCurrentUser.interests;
                  //       List<String> hiveList =
                  //           list.map((e) => e.toString()).toList();
                  //       return Container(
                  //         margin: const EdgeInsets.symmetric(horizontal: 4),
                  //         child: Chip(
                  //           label: Text(hiveList[index].toString()),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  //),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}