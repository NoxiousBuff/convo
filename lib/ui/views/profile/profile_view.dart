import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/constants/interest.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'profile_viewmodel.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  static const String id = '/ProfileView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(FeatherIcons.settings),
              color: Colors.black,
              iconSize: 24,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(FeatherIcons.shield),
              color: Colors.black,
              iconSize: 24,
            ),
            IconButton(
              onPressed: () {
                authService.signOut(context);
              },
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
          title: const Text(
            'Vikas Sharma',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Colors.black, fontSize: 32),
          ),
          backgroundColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
            return states.contains(MaterialState.scrolledUnder)
                ? Colors.grey.shade50
                : Colors.white;
          }),
          leadingWidth: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            verticalSpaceRegular,
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1596698749858-7a2ce0a09220?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=376&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),verticalSpaceRegular,
            Row(children: const [
              Text('Bio'),
            ],),
            Row(children: const [
              Text('Hey I am dule.'),
            ],),
            verticalSpaceRegular,
            Row(children: const [
              Text('Hashtags'),
            ],),
            Row(
              children: const [
                Text('What you love'),
                horizontalSpaceSmall,
                Text('Flutter'),
              ],
            ),
            Row(
              children: const [
                Text('What you hate'),
                horizontalSpaceSmall,
                Text('someone'),
              ],
            ),
            Row(
              children: const [
                Text('What you do'),
                horizontalSpaceSmall,
                Text('Programming'),
              ],
            ),
            verticalSpaceRegular,
            Row(
              children: const [
                Text('Interests'),
              ],
            ),
            verticalSpaceTiny,
            Wrap(children: Interest().activities.map((e) => Chip(label: Text(e))).toList(),)
          ],
        ),
      ),
    );
  }
}
